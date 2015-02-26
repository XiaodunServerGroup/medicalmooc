# coding: utf-8
import logging
import urllib
import time

from collections import defaultdict

from lxml import html

from django.conf import settings
from django.core.context_processors import csrf
from django.core.exceptions import PermissionDenied
from django.core.urlresolvers import reverse
from django.contrib.auth.models import User, AnonymousUser
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login
from django.http import Http404, HttpResponse
from django.shortcuts import redirect
from edxmako.shortcuts import render_to_response, render_to_string
from django_future.csrf import ensure_csrf_cookie
from django.views.decorators.cache import cache_control
from django.db import transaction
from markupsafe import escape
import django.utils
from django.utils.http import cookie_date, base36_to_int

from courseware import grades
from courseware.access import has_access
from courseware.courses import (get_courses, get_course_with_access, sort_by_announcement, get_course_info_section,
                                get_course_by_id, get_course, course_image_url, get_course_about_section, get_courses_by_search)

import courseware.tabs as tabs
from courseware.masquerade import setup_masquerade
from courseware.model_data import FieldDataCache
from .module_render import toc_for_course, get_module_for_descriptor,mobi_toc_for_course
from courseware.models import StudentModule, StudentModuleHistory
from course_modes.models import CourseMode

from student.models import UserTestGroup, CourseEnrollment, UserProfile, LoginFailures
from student.views import course_from_id, single_course_reverification_info
from util.cache import cache, cache_if_anonymous
from util.json_request import JsonResponse

from xblock.fragment import Fragment
from xmodule.modulestore import Location
from xmodule.modulestore.django import modulestore, loc_mapper
from xmodule.modulestore.exceptions import InvalidLocationError, ItemNotFoundError, NoPathToItem
from xmodule.modulestore.search import path_to_location
from xmodule.course_module import CourseDescriptor
from xmodule.contentstore.content import StaticContent
import shoppingcart

from dogapi import dog_stats_api

from ratelimitbackend.exceptions import RateLimitException

from microsite_configuration import microsite

log = logging.getLogger("edx.courseware")

template_imports = {'urllib': urllib}

def user_groups(user):
    """
    TODO (vshnayder): This is not used. When we have a new plan for groups, adjust appropriately.
    """
    if not user.is_authenticated():
        return []

    # TODO: Rewrite in Django
    key = 'user_group_names_{user.id}'.format(user=user)
    cache_expiration = 60 * 60  # one hour

    # Kill caching on dev machines -- we switch groups a lot
    group_names = cache.get(key)
    if settings.DEBUG:
        group_names = None

    if group_names is None:
        group_names = [u.name for u in UserTestGroup.objects.filter(users=user)]
        cache.set(key, group_names, cache_expiration)

    return group_names


#@ensure_csrf_cookie
#@cache_if_anonymous
def courses(request):
    """
    Render "find courses" page.  The course selection work is done in courseware.courses.
    """
    q = request.GET.get('query', '')

    courses_aa = get_courses_by_search(request.META.get('HTTP_HOST'))
    courses_list = []
    if q != "":
        for course in courses_aa:
            if  q in course.org or q in course.id or q in course.display_name_with_default:
                courses_list.append(course)
            else:
                continue
    else:
       courses_list = courses_aa

    courses = sort_by_announcement(courses_list)
    return render_to_response("courseware/courses.html", {'courses': courses})


def return_fixed_courses(request, courses, user=AnonymousUser(), action=None):
    default_length = 8

    course_id = request.GET.get("course_id")
    if course_id:
        course_id = course_id.replace(".", '/')

    try:
        index_course = get_course_by_id(course_id)
        course_index = (courses.index(index_course) + 1)
    except:
        course_index = 0

    current_list = courses[course_index:]
    if len(current_list) > default_length:
        current_list = current_list[course_index:(course_index + 8)]

    course_list = []
    for course in current_list:
        try:
            course_json = mobi_course_info(request, course, action)
            course_json["registered"] = registered_for_course(course, user)
            course_list.append(course_json)
        except:
            continue

    return JsonResponse({"count": len(courses), "course-list": course_list})


def courses_list_handler(request, action):
    """
    Return courses based on request params
    """
    try:
        user = request.user
    except:
        user = AnonymousUser()

    if action not in ["homefalls", "all", "hot", "latest", "my", "search", "rolling"]:
        return JsonResponse({"success": False, "errmsg": "not support other actions except homefalls all hot latest rolling and my"})

    def get_courses_depend_action():
        """
        Return courses depend on action
            action: [homefalls, hot, lastest, my, search]
                homefalls: get all courses
                hot: Number of attended people > ?
                lastest: News last week
                my: I registered
                all: like 'homefalls'
        """

        courses = get_courses(user, request.META.get('HTTP_HOST'))
        courses = sort_by_announcement(courses)
        courses_list = []

        if action == "latest":
            default_count = 20
            if len(courses) < default_count:
                default_count = len(courses)

            courses_list = courses[0:default_count]
        elif action == "my":
            # filter my registered courses
            for course in courses:
                if registered_for_course(course, user):
                    courses_list.append(course)
        elif action == "rolling":
            default_count = 5
            courses_list = courses[0:default_count]
        elif action == 'search':
            keyword = request.GET.get("keyword")

            if keyword:
                for c in courses:
                    print (keyword in c.org or keyword in c.id or keyword in c.display_name_with_default)
                    if keyword in c.org or keyword in c.id or keyword in c.display_name_with_default:
                        courses_list.append(c)
        else:
            courses_list = courses

        return courses_list

    courses = get_courses_depend_action()
    # get_courses_depend_action()

    return return_fixed_courses(request, courses, user, action)


def _course_json(course, course_id):
    locator = loc_mapper().translate_location(course_id, course.location, published=False, add_entry_if_missing=True)
    is_container = course.has_children

    result = {
        'display_name': course.display_name,
        'id': unicode(locator),
        'category': course.category,
        'is_draft': getattr(course, 'is_draft', False),
        'is_container': is_container
    }

    if is_container:
        result['children'] = [_course_json(child, course_id) for child in course.get_children()]

    category = result['category']
    if result['category'] == 'video':
        result[category + '-url'] = "http://www.diandiyun.com/Clip_480_5sec_6mbps_h264.mp4"
    elif result['category'] == 'problem':
        result[category + '-url'] = "http://music.163.com/"

    return result


def mobi_course_info(request, course, action=None):
    course_logo = course_image_url(course)
    imgurl = course_logo
    if action in ["homefalls", "all", "hot", "latest", "my", "search"]:
        try:
            course_mini_info = course.id.split('/')
            asset_location = StaticContent.compute_location(course_mini_info[0], course_mini_info[1], 'mobi-logo-img.jpg')
            imgurl = StaticContent.get_url_path_from_location(asset_location)
        except:
            print "=========================fail load mobi image==============================="
            print "We will load this info to log"

    return {
        "id": course.id.replace('/', '.'),
        "name": course.display_name_with_default,
        "logo": request.get_host() + course_image_url(course),
        "org": course.display_org_with_default,
        "course_number": course.display_number_with_default,
        "start_date": course.start.strftime("%Y-%m-%d"),
        "about": get_course_about_section(course, 'short_description'),
        "category": course.category,
        "imgurl": request.get_host() + imgurl
    }


def _course_info_content(html_parsed):
    """
    Constructs the HTML for the course info update, not including the header.
    """
    if len(html_parsed) == 1:
        # could enforce that update[0].tag == 'h2'
        content = html_parsed[0].tail
    else:
        content = html_parsed[0].tail if html_parsed[0].tail is not None else ""
        content += "\n".join([html.tostring(ele) for ele in html_parsed[1:]])
    return content


def parse_updates_html_str(html_str):
    try:
        course_html_parsed = html.fromstring(html_str)
    except:
        escaped = django.utils.html.eacape(html_str)
        course_html_parsed = html.fromstring(escaped)

    course_upd_collection = []
    if course_html_parsed.tag == 'section':
        for index, update in enumerate(course_html_parsed):
            if len(update) > 0:
                content = _course_info_content(update)

                computer_id = len(course_html_parsed) - index

                payload = {
                    "id": computer_id,
                    "date": update.findtext("h2"),
                    "content": content
                }

                course_upd_collection.append(payload)

    return {"updates": course_upd_collection}


def mobi_course_action(request, course_id, action):
    try:
        course_id_bak = course_id.replace('.', '/')
        if action in ["updates", "handouts", "structure"]:
            course = get_course_with_access(request.user, course_id_bak, 'see_exists')
            user = request.user
            if not user:
                user = AnonymousUser()

            registered = registered_for_course(course, user)

            if action == "updates" and registered:
                course_updates = get_course_info_section(request, course, action)
                return JsonResponse(parse_updates_html_str(course_updates))
            elif action == "handouts" and registered:
                course_handouts = get_course_info_section(request, course, action)
                return JsonResponse({"handouts": course_handouts})
            elif action == "structure":
                return JsonResponse(_course_json(course, course.location.course_id))
            else:
                raise Exception
        else:
            course = get_course_with_access(request.user, course_id_bak, 'see_exists')
            return JsonResponse(mobi_course_info(request, course))
    except:
        return JsonResponse({"success": False, "errmsg": "access denied!"})


def render_accordion(request, course, chapter, section, field_data_cache):
    """
    Draws navigation bar. Takes current position in accordion as
    parameter.

    If chapter and section are '' or None, renders a default accordion.

    course, chapter, and section are the url_names.

    Returns the html string
    """

    # grab the table of contents
    user = User.objects.prefetch_related("groups").get(id=request.user.id)
    request.user = user	# keep just one instance of User
    toc = toc_for_course(user, request, course, chapter, section, field_data_cache)

    context = dict([('toc', toc),
                    ('course_id', course.id),
                    ('csrf', csrf(request)['csrf_token']),
                    ('due_date_display_format', course.due_date_display_format)] + template_imports.items())
    return render_to_string('courseware/accordion.html', context)


def get_current_child(xmodule):
    """
    Get the xmodule.position's display item of an xmodule that has a position and
    children.  If xmodule has no position or is out of bounds, return the first child.
    Returns None only if there are no children at all.
    """
    if not hasattr(xmodule, 'position'):
        return None

    if xmodule.position is None:
        pos = 0
    else:
        # position is 1-indexed.
        pos = xmodule.position - 1

    children = xmodule.get_display_items()
    if 0 <= pos < len(children):
        child = children[pos]
    elif len(children) > 0:
        # Something is wrong.  Default to first child
        child = children[0]
    else:
        child = None
    return child


def redirect_to_course_position(course_module):
    """
    Return a redirect to the user's current place in the course.

    If this is the user's first time, redirects to COURSE/CHAPTER/SECTION.
    If this isn't the users's first time, redirects to COURSE/CHAPTER,
    and the view will find the current section and display a message
    about reusing the stored position.

    If there is no current position in the course or chapter, then selects
    the first child.

    """
    urlargs = {'course_id': course_module.id}
    chapter = get_current_child(course_module)
    if chapter is None:
        # oops.  Something bad has happened.
        raise Http404("No chapter found when loading current position in course")

    urlargs['chapter'] = chapter.url_name
    if course_module.position is not None:
        return redirect(reverse('courseware_chapter', kwargs=urlargs))

    # Relying on default of returning first child
    section = get_current_child(chapter)
    if section is None:
        raise Http404("No section found when loading current position in course")

    urlargs['section'] = section.url_name
    return redirect(reverse('courseware_section', kwargs=urlargs))


def save_child_position(seq_module, child_name):
    """
    child_name: url_name of the child
    """
    for position, c in enumerate(seq_module.get_display_items(), start=1):
        if c.url_name == child_name:
            # Only save if position changed
            if position != seq_module.position:
                seq_module.position = position
    # Save this new position to the underlying KeyValueStore
    seq_module.save()


def chat_settings(course, user):
    """
    Returns a dict containing the settings required to connect to a
    Jabber chat server and room.
    """
    domain = getattr(settings, "JABBER_DOMAIN", None)
    if domain is None:
        log.warning('You must set JABBER_DOMAIN in the settings to '
                    'enable the chat widget')
        return None

    return {
        'domain': domain,

        # Jabber doesn't like slashes, so replace with dashes
        'room': "{ID}_class".format(ID=course.id.replace('/', '-')),

        'username': "{USER}@{DOMAIN}".format(
            USER=user.username, DOMAIN=domain
        ),

        # TODO: clearly this needs to be something other than the username
        #       should also be something that's not necessarily tied to a
        #       particular course
        'password': "{USER}@{DOMAIN}".format(
            USER=user.username, DOMAIN=domain
        ),
    }


@login_required
@ensure_csrf_cookie
@cache_control(no_cache=True, no_store=True, must_revalidate=True)
def index(request, course_id, chapter=None, section=None,
          position=None):
    """
    Displays courseware accordion and associated content.  If course, chapter,
    and section are all specified, renders the page, or returns an error if they
    are invalid.

    If section is not specified, displays the accordion opened to the right chapter.

    If neither chapter or section are specified, redirects to user's most recent
    chapter, or the first chapter if this is the user's first visit.

    Arguments:

     - request    : HTTP request
     - course_id  : course id (str: ORG/course/URL_NAME)
     - chapter    : chapter url_name (str)
     - section    : section url_name (str)
     - position   : position in module, eg of <sequential> module (str)

    Returns:

     - HTTPresponse
    """
    user = User.objects.prefetch_related("groups").get(id=request.user.id)
    request.user = user  # keep just one instance of User
    course = get_course_with_access(user, course_id, 'load', depth=2)
    staff_access = has_access(user, course, 'staff')
    registered = registered_for_course(course, user)
    if not registered:
        # TODO (vshnayder): do course instructors need to be registered to see course?
        log.debug(u'User %s tried to view course %s but is not enrolled', user, course.location.url())
        return redirect(reverse('about_course', args=[course.id]))

    masq = setup_masquerade(request, staff_access)

    try:
        field_data_cache = FieldDataCache.cache_for_descriptor_descendents(
            course.id, user, course, depth=2)

        course_module = get_module_for_descriptor(user, request, course, field_data_cache, course.id)
        if course_module is None:
            log.warning(u'If you see this, something went wrong: if we got this'
                        u' far, should have gotten a course module for this user')
            return redirect(reverse('about_course', args=[course.id]))

        if chapter is None:
            return redirect_to_course_position(course_module)

        context = {
            'csrf': csrf(request)['csrf_token'],
            'accordion': render_accordion(request, course, chapter, section, field_data_cache),
            'COURSE_TITLE': course.display_name_with_default,
            'course': course,
            'init': '',
            'fragment': Fragment(),
            'staff_access': staff_access,
            'masquerade': masq,
            'xqa_server': settings.FEATURES.get('USE_XQA_SERVER', 'http://xqa:server@content-qa.mitx.mit.edu/xqa'),
            'reverifications': fetch_reverify_banner_info(request, course_id),
            }

        # Only show the chat if it's enabled by the course and in the
        # settings.
        show_chat = course.show_chat and settings.FEATURES['ENABLE_CHAT']
        if show_chat:
            context['chat'] = chat_settings(course, user)
            # If we couldn't load the chat settings, then don't show
            # the widget in the courseware.
            if context['chat'] is None:
                show_chat = False

        context['show_chat'] = show_chat

        chapter_descriptor = course.get_child_by(lambda m: m.url_name == chapter)
        if chapter_descriptor is not None:
            save_child_position(course_module, chapter)
        else:
            raise Http404('No chapter descriptor found with name {}'.format(chapter))

        chapter_module = course_module.get_child_by(lambda m: m.url_name == chapter)
        if chapter_module is None:
            # User may be trying to access a chapter that isn't live yet
            if masq=='student':  # if staff is masquerading as student be kinder, don't 404
                log.debug('staff masq as student: no chapter %s' % chapter)
                return redirect(reverse('courseware', args=[course.id]))
            raise Http404

        if section is not None:
            section_descriptor = chapter_descriptor.get_child_by(lambda m: m.url_name == section)
            if section_descriptor is None:
                # Specifically asked-for section doesn't exist
                if masq=='student':  # if staff is masquerading as student be kinder, don't 404
                    log.debug('staff masq as student: no section %s' % section)
                    return redirect(reverse('courseware', args=[course.id]))
                raise Http404

            # cdodge: this looks silly, but let's refetch the section_descriptor with depth=None
            # which will prefetch the children more efficiently than doing a recursive load
            section_descriptor = modulestore().get_instance(course.id, section_descriptor.location, depth=None)

            # Load all descendants of the section, because we're going to display its
            # html, which in general will need all of its children
            section_field_data_cache = FieldDataCache.cache_for_descriptor_descendents(
                course_id, user, section_descriptor, depth=None)

            section_module = get_module_for_descriptor(request.user,
                request,
                section_descriptor,
                section_field_data_cache,
                course_id,
                position
            )

            if section_module is None:
                # User may be trying to be clever and access something
                # they don't have access to.
                raise Http404

            # Save where we are in the chapter
            save_child_position(chapter_module, section)
            context['fragment'] = section_module.render('student_view')
            context['section_title'] = section_descriptor.display_name_with_default
        else:
            # section is none, so display a message
            prev_section = get_current_child(chapter_module)
            if prev_section is None:
                # Something went wrong -- perhaps this chapter has no sections visible to the user
                raise Http404
            prev_section_url = reverse('courseware_section', kwargs={'course_id': course_id,
                                                                     'chapter': chapter_descriptor.url_name,
                                                                     'section': prev_section.url_name})
            context['fragment'] = Fragment(content=render_to_string(
                'courseware/welcome-back.html',
                {
                    'course': course,
                    'chapter_module': chapter_module,
                    'prev_section': prev_section,
                    'prev_section_url': prev_section_url
                }
            ))

        result = render_to_response('courseware/courseware.html', context)
    except Exception as e:
        if isinstance(e, Http404):
            # let it propagate
            raise

        # In production, don't want to let a 500 out for any reason
        if settings.DEBUG:
            raise
        else:
            log.exception("Error in index view: user={user}, course={course},"
                          " chapter={chapter} section={section}"
                          "position={position}".format(
                              user=user,
                              course=course,
                              chapter=chapter,
                              section=section,
                              position=position
                              ))
            try:
                result = render_to_response('courseware/courseware-error.html',
                                            {'staff_access': staff_access,
                                            'course': course})
            except:
                # Let the exception propagate, relying on global config to at
                # at least return a nice error message
                log.exception("Error while rendering courseware-error page")
                raise

    return result

@login_required
@ensure_csrf_cookie
@cache_control(no_cache=True, no_store=True, must_revalidate=True)
def mobi_index(request, course_id, chapter=None, section=None,
          position=None):
    user = User.objects.prefetch_related("groups").get(id=request.user.id)
    request.user = user  # keep just one instance of User
    course = get_course_with_access(user, course_id, 'load', depth=2)
    staff_access = has_access(user, course, 'staff')
    registered = registered_for_course(course, user)
    if not registered:
        # TODO (vshnayder): do course instructors need to be registered to see course?
        log.debug(u'User %s tried to view course %s but is not enrolled', user, course.location.url())
        return redirect(reverse('about_course', args=[course.id]))

    masq = setup_masquerade(request, staff_access)

    try:
        field_data_cache = FieldDataCache.cache_for_descriptor_descendents(
            course.id, user, course, depth=2)

        course_module = get_module_for_descriptor(user, request, course, field_data_cache, course.id)
        if course_module is None:
            log.warning(u'If you see this, something went wrong: if we got this'
                        u' far, should have gotten a course module for this user')
            return redirect(reverse('about_course', args=[course.id]))

        if chapter is None:
            return redirect_to_course_position(course_module)

        context = {
            'csrf': csrf(request)['csrf_token'],
            'accordion': render_accordion(request, course, chapter, section, field_data_cache),
            'COURSE_TITLE': course.display_name_with_default,
            'course': course,
            'init': '',
            'fragment': Fragment(),
            'staff_access': staff_access,
            'masquerade': masq,
            'xqa_server': settings.FEATURES.get('USE_XQA_SERVER', 'http://xqa:server@content-qa.mitx.mit.edu/xqa'),
            'reverifications': fetch_reverify_banner_info(request, course_id),
            }
        # Only show the chat if it's enabled by the course and in the
        # settings.
        show_chat = course.show_chat and settings.FEATURES['ENABLE_CHAT']
        if show_chat:
            context['chat'] = chat_settings(course, user)
            # If we couldn't load the chat settings, then don't show
            # the widget in the courseware.
            if context['chat'] is None:
                show_chat = False

        context['show_chat'] = show_chat

        chapter_descriptor = course.get_child_by(lambda m: m.url_name == chapter)
        if chapter_descriptor is not None:
            save_child_position(course_module, chapter)
        else:
            raise Http404('No chapter descriptor found with name {}'.format(chapter))

        chapter_module = course_module.get_child_by(lambda m: m.url_name == chapter)
        if chapter_module is None:
            # User may be trying to access a chapter that isn't live yet
            if masq=='student':  # if staff is masquerading as student be kinder, don't 404
                log.debug('staff masq as student: no chapter %s' % chapter)
                return redirect(reverse('courseware', args=[course.id]))
            raise Http404

        if section is not None:
            section_descriptor = chapter_descriptor.get_child_by(lambda m: m.url_name == section)
            if section_descriptor is None:
                # Specifically asked-for section doesn't exist
                if masq=='student':  # if staff is masquerading as student be kinder, don't 404
                    log.debug('staff masq as student: no section %s' % section)
                    return redirect(reverse('courseware', args=[course.id]))
                raise Http404

            # cdodge: this looks silly, but let's refetch the section_descriptor with depth=None
            # which will prefetch the children more efficiently than doing a recursive load
            section_descriptor = modulestore().get_instance(course.id, section_descriptor.location, depth=None)


            # Load all descendants of the section, because we're going to display its
            # html, which in general will need all of its children
            section_field_data_cache = FieldDataCache.cache_for_descriptor_descendents(
                course_id, user, section_descriptor, depth=None)
            section_module = get_module_for_descriptor(request.user,
                request,
                section_descriptor,
                section_field_data_cache,
                course_id,
                position
            )

            if section_module is None:
                # User may be trying to be clever and access something
                # they don't have access to.
                raise Http404

            # Save where we are in the chapter
            save_child_position(chapter_module, section)
            context['fragment'] = section_module.render('mobi_student_view')
            context['section_title'] = section_descriptor.display_name_with_default

        else:
            # section is none, so display a message
            prev_section = get_current_child(chapter_module)
            if prev_section is None:
                # Something went wrong -- perhaps this chapter has no sections visible to the user
                raise Http404
            prev_section_url = reverse('courseware_section', kwargs={'course_id': course_id,
                                                                     'chapter': chapter_descriptor.url_name,
                                                                     'section': prev_section.url_name})
            context['fragment'] = Fragment(content=render_to_string(
                'courseware/welcome-back.html',
                {
                    'course': course,
                    'chapter_module': chapter_module,
                    'prev_section': prev_section,
                    'prev_section_url': prev_section_url
                }
            ))
        result = render_to_response('wechat/mobi_courseware.html', context)
        result.set_cookie('sessionid', request.COOKIES.get('sessionid',''))
    except Exception as e:
        if isinstance(e, Http404):
            # let it propagate
            raise

        # In production, don't want to let a 500 out for any reason
        if settings.DEBUG:
            raise
        else:
            log.exception("Error in index view: user={user}, course={course},"
                          " chapter={chapter} section={section}"
                          "position={position}".format(
                              user=user,
                              course=course,
                              chapter=chapter,
                              section=section,
                              position=position
                              ))
            try:
                result = render_to_response('courseware/courseware-error.html',
                                            {'staff_access': staff_access,
                                            'course': course})
            except:
                # Let the exception propagate, relying on global config to at
                # at least return a nice error message
                log.exception("Error while rendering courseware-error page")
                raise
    return result


def mobi_directory(request, course_id):
    user = User.objects.prefetch_related("groups").get(id=request.user.id)
    request.user = user  # keep just one instance of User
    course = get_course_with_access(user, course_id, 'load', depth=2)
    staff_access = has_access(user, course, 'staff')
    registered = registered_for_course(course, user)

    motoc = mobi_toc_for_course(user, request, course)
    show_list = list()
    for toc in motoc:
        videolist = toc['show_url'][0]
        show_list.append(videolist)
        
    if not registered:
        # TODO (vshnayder): do course instructors need to be registered to see course?
        log.debug(u'User %s tried to view course %s but is not enrolled', user, course.location.url())
        return redirect(reverse('about_course', args=[course.id]))

    masq = setup_masquerade(request, staff_access)

    try:
        field_data_cache = FieldDataCache.cache_for_descriptor_descendents(
            course.id, user, course, depth=2)

        course_module = get_module_for_descriptor(user, request, course, field_data_cache, course.id)
        if course_module is None:
            log.warning(u'If you see this, something went wrong: if we got this'
                        u' far, should have gotten a course module for this user')
            return redirect(reverse('about_course', args=[course.id]))
        context = {
            'csrf': csrf(request)['csrf_token'],
            'accordion': mobi_render_accordion(request, course),
            'COURSE_TITLE': course.display_name_with_default,
            'course': course,
            'init': '',
            'fragment': Fragment(),
            'staff_access': staff_access,
            'masquerade': masq,
            'xqa_server': settings.FEATURES.get('USE_XQA_SERVER', 'http://xqa:server@content-qa.mitx.mit.edu/xqa'),
            'reverifications': fetch_reverify_banner_info(request, course_id),
            'show_url': show_list and show_list[0] or '',
            }
        result = render_to_response('wechat/mobi_directory.html', context)
    except Exception as e:
        if isinstance(e, Http404):
            # let it propagate
            raise

        # In production, don't want to let a 500 out for any reason
        if settings.DEBUG:
            raise
        else:
            log.exception("Error in index view: user={user}, course={course},".format(
                              user=user,
                              course=course,))
            try:
                result = render_to_response('courseware/courseware-error.html',
                                            {'staff_access': staff_access,
                                            'course': course})
            except:
                # Let the exception propagate, relying on global config to at
                # at least return a nice error message
                log.exception("Error while rendering courseware-error page")
                raise
    return result


def mobi_render_accordion(request, course):
    user = User.objects.prefetch_related("groups").get(id=request.user.id)
    request.user = user	# keep just one instance of User
    toc = mobi_toc_for_course(user, request, course)
    context = dict([('toc', toc),
                    ('course_id', course.id),
                    ('csrf', csrf(request)['csrf_token']),
                    ('due_date_display_format', course.due_date_display_format)] + template_imports.items())
    return render_to_string('wechat/mobi_accordion.html', context)

@ensure_csrf_cookie
def jump_to_id(request, course_id, module_id):
    """
    This entry point allows for a shorter version of a jump to where just the id of the element is
    passed in. This assumes that id is unique within the course_id namespace
    """

    course_location = CourseDescriptor.id_to_location(course_id)

    items = modulestore().get_items(
        Location('i4x', course_location.org, course_location.course, None, module_id),
        course_id=course_id
    )

    if len(items) == 0:
        raise Http404("Could not find id = {0} in course_id = {1}. Referer = {2}".
                      format(module_id, course_id, request.META.get("HTTP_REFERER", "")))
    if len(items) > 1:
        log.warning("Multiple items found with id = {0} in course_id = {1}. Referer = {2}. Using first found {3}...".
                    format(module_id, course_id, request.META.get("HTTP_REFERER", ""), items[0].location.url()))

    return jump_to(request, course_id, items[0].location.url())


@ensure_csrf_cookie
def jump_to(request, course_id, location):
    """
    Show the page that contains a specific location.

    If the location is invalid or not in any class, return a 404.

    Otherwise, delegates to the index view to figure out whether this user
    has access, and what they should see.
    """
    # Complain if the location isn't valid
    try:
        location = Location(location)
    except InvalidLocationError:
        raise Http404("Invalid location")

    # Complain if there's not data for this location
    try:
        (course_id, chapter, section, position) = path_to_location(modulestore(), course_id, location)
    except ItemNotFoundError:
        raise Http404(u"No data at this location: {0}".format(location))
    except NoPathToItem:
        raise Http404(u"This location is not in any class: {0}".format(location))

    # choose the appropriate view (and provide the necessary args) based on the
    # args provided by the redirect.
    # Rely on index to do all error handling and access control.
    if chapter is None:
        return redirect('courseware', course_id=course_id)
    elif section is None:
        return redirect('courseware_chapter', course_id=course_id, chapter=chapter)
    elif position is None:
        return redirect('courseware_section', course_id=course_id, chapter=chapter, section=section)
    else:
        return redirect('courseware_position', course_id=course_id, chapter=chapter, section=section, position=position)


@ensure_csrf_cookie
def course_info(request, course_id):
    """
    Display the course's info.html, or 404 if there is no such course.

    Assumes the course_id is in a valid format.
    """
    course = get_course_with_access(request.user, course_id, 'load')
    staff_access = has_access(request.user, course, 'staff')
    masq = setup_masquerade(request, staff_access)    # allow staff to toggle masquerade on info page
    reverifications = fetch_reverify_banner_info(request, course_id)

    context = {
        'request': request,
        'course_id': course_id,
        'cache': None,
        'course': course,
        'staff_access': staff_access,
        'masquerade': masq,
        'reverifications': reverifications,
    }

    return render_to_response('courseware/info.html', context)


@ensure_csrf_cookie
def static_tab(request, course_id, tab_slug):
    """
    Display the courses tab with the given name.

    Assumes the course_id is in a valid format.
    """
    course = get_course_with_access(request.user, course_id, 'load')

    tab = tabs.get_static_tab_by_slug(course, tab_slug)
    if tab is None:
        raise Http404

    contents = tabs.get_static_tab_contents(
        request,
        course,
        tab
    )
    if contents is None:
        raise Http404

    staff_access = has_access(request.user, course, 'staff')
    return render_to_response('courseware/static_tab.html',
                              {'course': course,
                               'tab': tab,
                               'tab_contents': contents,
                               'staff_access': staff_access, })

# TODO arjun: remove when custom tabs in place, see courseware/syllabus.py


@ensure_csrf_cookie
def syllabus(request, course_id):
    """
    Display the course's syllabus.html, or 404 if there is no such course.

    Assumes the course_id is in a valid format.
    """
    course = get_course_with_access(request.user, course_id, 'load')
    staff_access = has_access(request.user, course, 'staff')

    return render_to_response('courseware/syllabus.html', {'course': course,
                                            'staff_access': staff_access, })


def registered_for_course(course, user):
    """
    Return True if user is registered for course, else False
    """
    if user is None:
        return False
    if user.is_authenticated():
        return CourseEnrollment.is_enrolled(user, course.id)
    else:
        return False


@ensure_csrf_cookie
@cache_if_anonymous
def course_about(request, course_id):

    if microsite.get_value(
        'ENABLE_MKTG_SITE',
        settings.FEATURES.get('ENABLE_MKTG_SITE', False)
    ):
        raise Http404

    course = get_course_with_access(request.user, course_id, 'see_exists')
    registered = registered_for_course(course, request.user)

    if has_access(request.user, course, 'load'):
        course_target = reverse('info', args=[course.id])
    else:
        course_target = reverse('about_course', args=[course.id])

    show_courseware_link = (has_access(request.user, course, 'load') or
                            settings.FEATURES.get('ENABLE_LMS_MIGRATION'))

    # Note: this is a flow for payment for course registration, not the Verified Certificate flow.
    registration_price = 0
    in_cart = False
    reg_then_add_to_cart_link = ""
    if (settings.FEATURES.get('ENABLE_SHOPPING_CART') and
        settings.FEATURES.get('ENABLE_PAID_COURSE_REGISTRATION')):
        registration_price = CourseMode.min_course_price_for_currency(course_id,
                                                                      settings.PAID_COURSE_REGISTRATION_CURRENCY[0])
        if request.user.is_authenticated():
            cart = shoppingcart.models.Order.get_cart_for_user(request.user)
            in_cart = shoppingcart.models.PaidCourseRegistration.contained_in_order(cart, course_id)

        reg_then_add_to_cart_link = "{reg_url}?course_id={course_id}&enrollment_action=add_to_cart".format(
            reg_url=reverse('register_user'), course_id=course.id)

    # see if we have already filled up all allowed enrollments
    is_course_full = CourseEnrollment.is_course_full(course)

    return render_to_response('courseware/course_about.html',
                              {'course': course,
                               'registered': registered,
                               'course_target': course_target,
                               'registration_price': registration_price,
                               'in_cart': in_cart,
                               'reg_then_add_to_cart_link': reg_then_add_to_cart_link,
                               'show_courseware_link': show_courseware_link,
                               'is_course_full': is_course_full})


@ensure_csrf_cookie
@cache_if_anonymous
def mktg_course_about(request, course_id):
    """
    This is the button that gets put into an iframe on the Drupal site
    """

    try:
        course = get_course_with_access(request.user, course_id, 'see_exists')
    except (ValueError, Http404) as e:
        # if a course does not exist yet, display a coming
        # soon button
        return render_to_response(
            'courseware/mktg_coming_soon.html', {'course_id': course_id}
        )

    registered = registered_for_course(course, request.user)

    if has_access(request.user, course, 'load'):
        course_target = reverse('info', args=[course.id])
    else:
        course_target = reverse('about_course', args=[course.id])

    allow_registration = has_access(request.user, course, 'enroll')

    show_courseware_link = (has_access(request.user, course, 'load') or
                            settings.FEATURES.get('ENABLE_LMS_MIGRATION'))
    course_modes = CourseMode.modes_for_course(course.id)

    return render_to_response(
        'courseware/mktg_course_about.html',
        {
            'course': course,
            'registered': registered,
            'allow_registration': allow_registration,
            'course_target': course_target,
            'show_courseware_link': show_courseware_link,
            'course_modes': course_modes,
        }
    )


@login_required
@cache_control(no_cache=True, no_store=True, must_revalidate=True)
@transaction.commit_manually
def progress(request, course_id, student_id=None):
    """
    Wraps "_progress" with the manual_transaction context manager just in case
    there are unanticipated errors.
    """
    with grades.manual_transaction():
        return _progress(request, course_id, student_id)


def _progress(request, course_id, student_id):
    """
    Unwrapped version of "progress".

    User progress. We show the grade bar and every problem score.

    Course staff are allowed to see the progress of students in their class.
    """
    course = get_course_with_access(request.user, course_id, 'load', depth=None)
    staff_access = has_access(request.user, course, 'staff')

    if student_id is None or student_id == request.user.id:
        # always allowed to see your own profile
        student = request.user
    else:
        # Requesting access to a different student's profile
        if not staff_access:
            raise Http404
        student = User.objects.get(id=int(student_id))

    # NOTE: To make sure impersonation by instructor works, use
    # student instead of request.user in the rest of the function.

    # The pre-fetching of groups is done to make auth checks not require an
    # additional DB lookup (this kills the Progress page in particular).
    student = User.objects.prefetch_related("groups").get(id=student.id)

    courseware_summary = grades.progress_summary(student, request, course)

    grade_summary = grades.grade(student, request, course)

    if courseware_summary is None:
        #This means the student didn't have access to the course (which the instructor requested)
        raise Http404

    context = {
        'course': course,
        'courseware_summary': courseware_summary,
        'grade_summary': grade_summary,
        'staff_access': staff_access,
        'student': student,
        'reverifications': fetch_reverify_banner_info(request, course_id)
    }

    with grades.manual_transaction():
        response = render_to_response('courseware/progress.html', context)

    return response


def fetch_reverify_banner_info(request, course_id):
    """
    Fetches needed context variable to display reverification banner in courseware
    """
    reverifications = defaultdict(list)
    user = request.user
    if not user.id:
        return reverifications
    enrollment = CourseEnrollment.get_or_create_enrollment(request.user, course_id)
    course = course_from_id(course_id)
    info = single_course_reverification_info(user, course, enrollment)
    if info:
        reverifications[info.status].append(info)
    return reverifications


@login_required
def submission_history(request, course_id, student_username, location):
    """Render an HTML fragment (meant for inclusion elsewhere) that renders a
    history of all state changes made by this user for this problem location.
    Right now this only works for problems because that's all
    StudentModuleHistory records.
    """

    course = get_course_with_access(request.user, course_id, 'load')
    staff_access = has_access(request.user, course, 'staff')

    # Permission Denied if they don't have staff access and are trying to see
    # somebody else's submission history.
    if (student_username != request.user.username) and (not staff_access):
        raise PermissionDenied

    try:
        student = User.objects.get(username=student_username)
        student_module = StudentModule.objects.get(course_id=course_id,
                                                   module_state_key=location,
                                                   student_id=student.id)
    except User.DoesNotExist:
        return HttpResponse(escape("User {0} does not exist.".format(student_username)))
    except StudentModule.DoesNotExist:
        return HttpResponse(escape("{0} has never accessed problem {1}".format(student_username, location)))

    history_entries = StudentModuleHistory.objects.filter(
        student_module=student_module
    ).order_by('-id')

    # If no history records exist, let's force a save to get history started.
    if not history_entries:
        student_module.save()
        history_entries = StudentModuleHistory.objects.filter(
            student_module=student_module
        ).order_by('-id')

    context = {
        'history_entries': history_entries,
        'username': student.username,
        'location': location,
        'course_id': course_id
    }

    return render_to_response('courseware/submission_history.html', context)

def show_video(request):
    showurl = request.GET.get("showurl","")
    course_id = request.GET.get("course_id")    
    return render_to_response('wechat/mobi_video.html',{"showurl":showurl, "course_id": course_id})


@ensure_csrf_cookie
def mobi_register(request, extra_context=None):
    """
    This view will display the mobile registeration from
    """
    # # if request.user.is_authenticated():
    # #     return redirect(reverse("mobile_about_course"))

    # context = {
    #     "course_id": request.GET.get('course_id'),
    #     "enrollment_action": request.GET.get('enrollment_action')
    # }

    # return render_to_response('wechat/mobi_register.html', context)
    if request.user.is_authenticated():
        return redirect(reverse('dashboard'))
    if settings.FEATURES.get('AUTH_USE_CERTIFICATES_IMMEDIATE_SIGNUP'):
        # Redirect to branding to process their certificate if SSL is enabled
        # and registration is disabled.
        return redirect(reverse('root'))

    context = {
        'course_id': request.GET.get('course_id'),
        'enrollment_action': request.GET.get('enrollment_action'),
        'platform_name': microsite.get_value(
            'platform_name',
            settings.PLATFORM_NAME
        ),
    }
    if extra_context is not None:
        context.update(extra_context)

    return render_to_response('wechat/mobi_register.html', context)


def mobi_login_ajax(request, error=""):
    "mobile ajax login request"
    if 'email' not in request.POST or 'password' not in request.POST:
        return JsonResponse({
            "success": False,
            "errmsg": "登录时服务器出现错误，请稍后再试",
        })

    email = request.POST['email']
    password = request.POST['password']

    try:
        user = User.objects.get(email=email)
    except:
        user = None

    if user and LoginFailures.is_feature_enabled():
        if LoginFailures.is_user_locked_out(user):
            return JsonResponse({
                "success": False,
                "errmsg": "账户暂时被锁定，请稍后再试",
            })

    username = user.username if user else ""

    try:
        user = authenticate(username=username, password=password, request=request)
    except RateLimitException:
        return JsonResponse({
            "success": False,
            "errmsg": "登录失败次数太多，稍后再试",
        })

    if user is None:
        if user and LoginFailures.is_feature_enabled():
            LoginFailures.increment_lockout_counter(user)

        return JsonResponse({
            "success": False,
            "errmsg": "邮箱或密码错误"
        })

    if LoginFailures.is_feature_enabled():
        LoginFailures.clear_lockout_counter(user)

    if user is not None and user.is_active:
        try:
            login(request, user)
            if request.POST.get('remember') == "true":
                request.session.set_expiry(604800)
            else:
                #request.session.set_expiry(0)
                pass
        except Exception as e:
            raise

    course_id = request.POST.get("course_id")
    if not course_id:
        # TODO: add mobile course list page, but now judge to first course about page
        courses = get_courses(user, domain=settings.FEATURES.get('FORCE_UNIVERSITY_DOMAIN'))
        for course in courses:
            if course.course_audit == 1:
                course_id = course.id
                break

    redirect_url = reverse("mobile_about_course", args=[course_id])

    dog_stats_api.increment("common.student.successful_login")

    response = JsonResponse({
        "success": True,
        "redirect_url": redirect_url
    })

    if request.session.get_expire_at_browser_close():
        max_age = None
        expires = None
    else:
        max_age = request.session.get_expiry_age()
        expires_time = time.time() + max_age
        expires = cookie_date(expires_time)

    response.set_cookie(
        settings.EDXMKTG_COOKIE_NAME, 'true', max_age=max_age,
        expires=expires, domain=settings.SESSION_COOKIE_DOMAIN,
        path='/', secure=None, httponly=None,
    )

    return response


def mobi_login(request):

    context = {
        'course_id': request.GET.get('course_id'),
        'platform_name': microsite.get_value(
            'platform_name',
            settings.PLATFORM_NAME
        ),
    }

    return render_to_response('wechat/mobi_login.html', context)


def mobi_register_success(request, user_id):

    user = User.objects.get(id=int(user_id))
    context = {}
    if user:
        context.update({"email_server": "http://mail." + user.email.split("@")[1], "username": user.username})
    
    return render_to_response('wechat/register_success.html', context)