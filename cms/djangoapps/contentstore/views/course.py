# -*- coding: utf-8 -*-
#coding=utf-8
import Queue
import sys,os
from envs.common import PROJECT_ROOT
import xlrd
from student.views import do_institution_import_teacher_create_account
from student.models import PendingNameChange
from student.views import accept_picurl_change_by_id, accept_shortbio_change_by_id
from student.views import do_institution_import_teacher_create_account,do_institution_import_student_create_account
import random

reload(sys)
sys.setdefaultencoding('utf8')
"""
Views related to operations on course objects
"""
import json
import random
import string  # pylint: disable=W0402
import re
import bson
import socket
import urllib2
from Crypto.Cipher import DES
import base64
import hashlib

import analytics.basic

from datetime import *
from django.utils import timezone

from django.db.models import Q
from django.utils.translation import ugettext as _
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User, Group
from django_future.csrf import ensure_csrf_cookie
from django.conf import settings
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from django.core.exceptions import PermissionDenied
from django.core.urlresolvers import reverse
from django.http import HttpResponseBadRequest, HttpResponseNotFound, HttpResponseRedirect, HttpResponse, Http404
from util.json_request import JsonResponse
from edxmako.shortcuts import render_to_response

from xmodule.error_module import ErrorDescriptor
from xmodule.modulestore.django import modulestore, loc_mapper
from xmodule.contentstore.content import StaticContent

from xmodule.modulestore.exceptions import (
    ItemNotFoundError, InvalidLocationError)
from xmodule.modulestore import Location
from xmodule.fields import Date

from contentstore.course_info_model import get_course_updates, update_course_updates, delete_course_update, get_course_update_items
from contentstore.utils import (
    get_lms_link_for_item, add_extra_panel_tab, remove_extra_panel_tab,
    get_modulestore)
from contentstore.utils import send_mail_update
from models.settings.course_details import CourseDetails, CourseSettingsEncoder

from models.settings.course_grading import CourseGradingModel
from models.settings.course_metadata import CourseMetadata
from util.json_request import expect_json

from .access import has_course_access
from .tabs import initialize_course_tabs
from .component import (
    OPEN_ENDED_COMPONENT_TYPES, NOTE_COMPONENT_TYPES,
    ADVANCED_COMPONENT_POLICY_KEY)

from django_comment_common.models import assign_default_role
from django_comment_common.utils import seed_permissions_roles

from student.models import CourseEnrollment,UserProfile,UploadFileForm

from xmodule.html_module import AboutDescriptor
from xmodule.modulestore.locator import BlockUsageLocator, CourseLocator
from course_creators.views import get_course_creator_status, add_user_with_status_unrequested
from contentstore import utils
from student.roles import CourseInstructorRole, CourseStaffRole, CourseCreatorRole, GlobalStaff
from student import auth

from microsite_configuration import microsite
from syscustom.models import CourseClass

__all__ = ['course_info_handler', 'course_handler', 'course_info_update_handler',
           'settings_handler',
           'grading_handler',
           'advanced_settings_handler',
           'calendar_settings_handler',
           'calendar_common',
           'calendar_common_addevent',
           'calendar_common_deleteevent',
           'calendar_common_updateevent',
           'calendar_settings_getevents',
           'textbooks_list_handler',
           'textbooks_detail_handler', 'course_audit_api', 'sync_class_appointment', 'institution_upload_teacher', 'remove_institute_teacher', 'teacher_intro_edit', 'change_picurl_request', 'change_shortbio_request', 'import_student']

WENJUAN_STATUS = {
    "0": "未发布",
    "1": "收集中",
    "2": "已结束",
    "3": "暂停中",
    "4": "状态未明",
    "-1": "已删除",
}

def _get_locator_and_course(package_id, branch, version_guid, block_id, user, depth=0):
    """
    Internal method used to calculate and return the locator and course module
    for the view functions in this file.
    """
    locator = BlockUsageLocator(package_id=package_id, branch=branch, version_guid=version_guid, block_id=block_id)
    if not has_course_access(user, locator):
        raise PermissionDenied()
    course_location = loc_mapper().translate_locator_to_location(locator)
    course_module = modulestore().get_item(course_location, depth=depth)
    return locator, course_module

def _get_institute(curr_user):
    course_org = ""
    u = UserProfile.objects.get(user_id=curr_user.id)
    if u.profile_role == 'in':
        course_org = u.name
    elif u.profile_role == 'th' and  u.institute:
        course_org = UserProfile.objects.get(user_id=u.institute).name

    print course_org.encode('utf-8')

    return course_org

def _get_course_org_from_bs(user):
    course_org = ""
    try:
        request_host = settings.XIAODUN_BACK_HOST
        # request_url = request_host + "/teacher/teacher!branch.do?teacherid=" + str(user.id)
        request_url = "{}/teacher/teacher!branch.do?teacherid={}".format(request_host, str(user.id))

        timeout = 5
        socket.setdefaulttimeout(timeout)
        req = urllib2.Request(request_url)
        request_json = json.load(urllib2.urlopen(req))

        if request_json['success']:
            course_org = request_json['name']
    except:
        print "some errors occur!"

    return course_org


@login_required
def sync_class_appointment(request):
    """
    Synchronous classroom Appointment
    """
    user = request.user

    # load settings viedio meeting domain
    video_meeting_domain = settings.VEDIO_MEETING_DOMAIN  # "http://192.168.1.6:8091"

    # des encrypt user info for login into video meetting sys
    '''
    pad = lambda s: s + (8 - len(s) % 8) * chr(8 - len(s) % 8)
    def des_encrypt(input_str):
        obj = DES.new(secure_key(KEY), DES.MODE_ECB)

        return base64.b64encode(obj.encrypt(pad(input_str)))

    des_user_info = des_encrypt(user.username + "#" + user.password)
    '''

    des_user_info = 'gwRz4rZHXMtbbPORcrVTgjnoi4oaEnkd/wIMDjUGklRqQfIlN7gypcbbstLUWdxg'

    tabs = [
        ["我的小屋", "{}/sns/meeting/edx_list_class_room.jsp?userInfo={}".format(video_meeting_domain, des_user_info), True],
        ["查找小屋", "{}/sns/meeting/edx_find_class_room.jsp?userInfo={}".format(video_meeting_domain, des_user_info), False],
        ["添加小屋", "{}/sns/meeting/edx_add_class_room.jsp?userInfo={}".format(video_meeting_domain, des_user_info), False],
        ["信息通知", "{}/sns/pm/edx_pm.jsp?userInfo={}".format(video_meeting_domain, des_user_info), False],
    ]

    return render_to_response("sync_class_appointment.html", {"user": user, 'ftabs': tabs})


# pylint: disable=unused-argument
@login_required
def course_handler(request, tag=None, package_id=None, branch=None, version_guid=None, block=None):
    """
    The restful handler for course specific requests.
    It provides the course tree with the necessary information for identifying and labeling the parts. The root
    will typically be a 'course' object but may not be especially as we support modules.

    GET
        html: return course listing page if not given a course id
        html: return html page overview for the given course if given a course id
        json: return json representing the course branch's index entry as well as dag w/ all of the children
        replaced w/json docs where each doc has {'_id': , 'display_name': , 'children': }
    POST
        json: create a course, return resulting json
        descriptor (same as in GET course/...). Leaving off /branch/draft would imply create the course w/ default
        branches. Cannot change the structure contents ('_id', 'display_name', 'children') but can change the
        index entry.
    PUT
        json: update this course (index entry not xblock) such as repointing head, changing display name, org,
        package_id, prettyid. Return same json as above.
    DELETE
        json: delete this branch from this course (leaving off /branch/draft would imply delete the course)
    """
    response_format = request.REQUEST.get('format', 'html')
    if response_format == 'json' or 'application/json' in request.META.get('HTTP_ACCEPT', 'application/json'):
        if request.method == 'GET':
            return JsonResponse(_course_json(request, package_id, branch, version_guid, block))
        elif request.method == 'POST':  # not sure if this is only post. If one will have ids, it goes after access
            return create_new_course(request)
        elif not has_course_access(
            request.user,
            BlockUsageLocator(package_id=package_id, branch=branch, version_guid=version_guid, block_id=block)
        ):
            raise PermissionDenied()
        elif request.method == 'PUT':
            raise NotImplementedError()
        elif request.method == 'DELETE':
            raise NotImplementedError()
        else:
            return HttpResponseBadRequest()
    elif request.method == 'GET':  # assume html
        if package_id is None:
            return course_listing(request)
        else:
            return course_index(request, package_id, branch, version_guid, block)
    else:
        return HttpResponseNotFound()


@login_required
def _course_json(request, package_id, branch, version_guid, block):
    """
    Returns a JSON overview of a course
    """
    __, course = _get_locator_and_course(
        package_id, branch, version_guid, block, request.user, depth=None
    )

    return _xmodule_json(course, course.location.course_id)


def _xmodule_json(xmodule, course_id):
    """
    Returns a JSON overview of an XModule
    """
    locator = loc_mapper().translate_location(
        course_id, xmodule.location, published=False, add_entry_if_missing=True
    )
    is_container = xmodule.has_children
    result = {
        'display_name': xmodule.display_name,
        'id': unicode(locator),
        'category': xmodule.category,
        'is_draft': getattr(xmodule, 'is_draft', False),
        'is_container': is_container,
    }
    if is_container:
        result['children'] = [_xmodule_json(child, course_id) for child in xmodule.get_children()]
    return result


def _accessible_courses_list(request):
    """
    List all courses available to the logged in user by iterating through all the courses
    """
    courses = modulestore('direct').get_courses()

    # filter out courses that we don't have access too
    def course_filter(course):
        """
        Get courses to which this user has access
        """
        if GlobalStaff().has_user(request.user):
            return course.location.course != 'templates'

        return (has_course_access(request.user, course.location)
                # pylint: disable=fixme
                # TODO remove this condition when templates purged from db
                and course.location.course != 'templates'
                )
    courses = filter(course_filter, courses)
    return courses


# pylint: disable=invalid-name
def _accessible_courses_list_from_groups(request):
    """
    List all courses available to the logged in user by reversing access group names
    """
    courses_list = []
    course_ids = set()

    user_staff_group_names = request.user.groups.filter(
        Q(name__startswith='instructor_') | Q(name__startswith='staff_')
    ).values_list('name', flat=True)

    # we can only get course_ids from role names with the new format (instructor_org/number/run or
    # instructor_org.number.run but not instructor_number).
    for user_staff_group_name in user_staff_group_names:
        # to avoid duplication try to convert all course_id's to format with dots e.g. "edx.course.run"
        if user_staff_group_name.startswith("instructor_"):
            # strip starting text "instructor_"
            course_id = user_staff_group_name[11:]
        else:
            # strip starting text "staff_"
            course_id = user_staff_group_name[6:]

        course_ids.add(course_id.replace('/', '.').lower())

    for course_id in course_ids:
        # get course_location with lowercase id
        course_location = loc_mapper().translate_locator_to_location(
            CourseLocator(package_id=course_id), get_course=True, lower_only=True
        )
        if course_location is None:
            raise ItemNotFoundError(course_id)

        course = modulestore('direct').get_course(course_location.course_id)
        courses_list.append(course)

    return courses_list


@login_required
@ensure_csrf_cookie
def course_listing(request):
    """
    List all courses available to the logged in user
    Try to get all courses by first reversing django groups and fallback to old method if it fails
    Note: overhead of pymongo reads will increase if getting courses from django groups fails
    """
    if GlobalStaff().has_user(request.user):
        # user has global access so no need to get courses from django groups
        courses = _accessible_courses_list(request)
    else:
        try:
            courses = _accessible_courses_list_from_groups(request)
        except ItemNotFoundError:
            # user have some old groups or there was some error getting courses from django groups
            # so fallback to iterating through all courses
            courses = _accessible_courses_list(request)

            # update location entry in "loc_mapper" for user courses (add keys 'lower_id' and 'lower_course_id')
            for course in courses:
                loc_mapper().create_map_entry(course.location)

    def format_course_for_view(course):
        """
        return tuple of the data which the view requires for each course
        """
        # published = false b/c studio manipulates draft versions not b/c the course isn't pub'd
        course_loc = loc_mapper().translate_location(
            course.location.course_id, course.location, published=False, add_entry_if_missing=True
        )
        return (
            course.display_name,
            # note, couldn't get django reverse to work; so, wrote workaround
            course_loc.url_reverse('course/', ''),
            get_lms_link_for_item(course.location),
            course.display_org_with_default,
            course.display_number_with_default,
            course.location.name
        )

    # questionnaire
    # KEY: site(required) user(required) ctime(required format yyyy-mm-dd HH:MM) email(required) mobile
    qparams = {
        "site": '99999', # TODO: settings.WENJUANSITEID
        "user": request.user.username,
        "ctime": datetime.now().strftime("%Y-%m-%d %H:%M"),
        "email": request.user.email
    }

    def sorted_url(params_hash={}):
        pkeys = params_hash.keys()
        pkeys.sort()

        demd5_str = hashlib.md5("".join([params_hash[k] for k in pkeys]) + settings.WENJUAN_SECKEY).hexdigest()

        return ("&".join(["".join([k, '=', v]) for k, v in params_hash.iteritems()]), demd5_str)


    # demd5_qparams_str = hashlib.md5("".join([qparams[k] for k in qparams_keys]) + "9d15a674a6e621058f1ea9171413b7c0").hexdigest()
    wenjuan_domain = settings.WENJUAN_DOMAIN
    wenjuan_loginapi = "{}/openapi/login?{}&md5={}".format(wenjuan_domain, *sorted_url(qparams))

    # get questionnaire list
    qlist = []
    try:
        list_url = "{}/openapi/proj_list?{}&md5={}".format(wenjuan_domain, *sorted_url(qparams))
        timeout = 10
        socket.setdefaulttimeout(timeout)
        req = urllib2.Request(list_url.replace(' ', '%20'))
        # {"status": 1, "respondent_count": 0, "proj_id": "AzaYja", "ctime": "2014-08-08 15:23", "title": "测试问卷", "type": "survey"}
        for wj in json.load(urllib2.urlopen(req)):
            """
            list structure
            [
                title,
                status,
                reponse,
                create time,
                q url
                result url
            ]
            """
            qlist.append([
                wj.get('title', "未知"),
                WENJUAN_STATUS[str(wj.get('status', 4))],
                wj.get('respondent_count', 0),
                wj.get('ctime', ''),
                "{}/s/{}".format(wenjuan_domain, wj.get('proj_id', '')),
                "{}/openapi/basic_chart/?{}&md5={}".format(wenjuan_domain, *sorted_url({"site": '99999', "user": request.user.username,"proj_id": wj.get("proj_id", "")}))
            ])
    except:
        print "=====error===== " * 5

    curr_user = User.objects.get(username=request.user)
    course_org = _get_institute(curr_user)
    profile = UserProfile.objects.get(user_id=curr_user.id)

    # get institute teacher user
    userprofile_list = UserProfile.objects.all()
    user_institute_teacher_list = []
    for ul in userprofile_list:
        if ul.institute == str(profile.user_id) and ul.profile_role == 'th':
            u = User.objects.get(id=ul.user_id)
            content = {
                'id': int(u.id),
                'username': u.username.encode('utf8'),
                'email': u.email.encode('utf8'),
                'name': ul.name.encode('utf8')
            }
            user_institute_teacher_list.append(content)

     # import student
    user_student_list = []
    for sl in userprofile_list:
        if sl.institute == str(profile.user_id) and sl.profile_role == 'st':
            s = User.objects.get(id=sl.user_id)
            student_context = {
               'id': int(s.id),
                'username': s.username.encode('utf8'),
                'email': s.email.encode('utf8'),
                'name': sl.name.encode('utf8')
            }
            user_student_list.append(student_context)

    return render_to_response('index.html', {
        'courses': [format_course_for_view(c) for c in courses if not isinstance(c, ErrorDescriptor)],
        'user': request.user,
        'request_course_creator_url': reverse('contentstore.views.request_course_creator'),
        'course_creator_status': _get_course_creator_status(request.user),
        'course_org': course_org,
        'wenjuan_link': wenjuan_loginapi,
        'qlist': qlist,
        'profile': profile,
        'user_institute_teacher_list': user_institute_teacher_list,
        "course_class_list": CourseClass.objects.all().order_by('order_num','id'),
        'user_student_list': user_student_list
    })


@login_required
@ensure_csrf_cookie
def course_index(request, package_id, branch, version_guid, block):
    """
    Display an editable course overview.

    org, course, name: Attributes of the Location for the item to edit
    """
    locator, course = _get_locator_and_course(
        package_id, branch, version_guid, block, request.user, depth=3
    )
    lms_link = get_lms_link_for_item(course.location)
    sections = course.get_children()

    return render_to_response('overview.html', {
        'context_course': course,
        'lms_link': lms_link,
        'sections': sections,
        'course_graders': json.dumps(
            CourseGradingModel.fetch(locator).graders
        ),
        'parent_locator': locator,
        'new_section_category': 'chapter',
        'new_subsection_category': 'sequential',
        'new_unit_category': 'vertical',
        'category': 'vertical'
    })


@expect_json
def create_new_course(request):
    """
    Create a new course.
    Returns the URL for the course overview page.
    """
    if not auth.has_access(request.user, CourseCreatorRole()):
        raise PermissionDenied()

    org = request.json.get('org')
    number = request.json.get('number')
    display_name = request.json.get('display_name')
    course_category = request.json.get('course_category')
    course_level = request.json.get('course_level')
    course_price = request.json.get('course_price')
    run = request.json.get('run')

    try:
        dest_location = Location(u'i4x', org, number, u'course', run)
    except InvalidLocationError as error:
        return JsonResponse({
            "ErrMsg": _("Unable to create course '{name}'.\n\n{err}").format(
                name=display_name, err=error.message)})

    # see if the course already exists
    existing_course = None
    try:
        existing_course = modulestore('direct').get_item(dest_location)
    except ItemNotFoundError:
        pass
    if existing_course is not None:
        return JsonResponse({
            'ErrMsg': _(
                'There is already a course defined with the same '
                'organization, course number, and course run. Please '
                'change either organization or course number to be '
                'unique.'
            ),
            'OrgErrMsg': _(
                'Please change either the organization or '
                'course number so that it is unique.'
            ),
            'CourseErrMsg': _(
                'Please change either the organization or '
                'course number so that it is unique.'
            ),
        })

    # dhm: this query breaks the abstraction, but I'll fix it when I do my suspended refactoring of this
    # file for new locators. get_items should accept a query rather than requiring it be a legal location
    course_search_location = bson.son.SON({
        '_id.tag': 'i4x',
        # cannot pass regex to Location constructor; thus this hack
        # pylint: disable=E1101
        '_id.org': re.compile(u'^{}$'.format(dest_location.org), re.IGNORECASE | re.UNICODE),
        # pylint: disable=E1101
        '_id.course': re.compile(u'^{}$'.format(dest_location.course), re.IGNORECASE | re.UNICODE),
        '_id.category': 'course',
    })
    courses = modulestore().collection.find(course_search_location, fields=('_id'))
    if courses.count() > 0:
        return JsonResponse({
            'ErrMsg': _(
                'There is already a course defined with the same '
                'organization and course number. Please '
                'change at least one field to be unique.'),
            'OrgErrMsg': _(
                'Please change either the organization or '
                'course number so that it is unique.'),
            'CourseErrMsg': _(
                'Please change either the organization or '
                'course number so that it is unique.'),
        })

    # instantiate the CourseDescriptor and then persist it
    # note: no system to pass
    if display_name is None and course_category is None and course_level is None:
        metadata = {}
    else:
        metadata = {'display_name': display_name, 'course_category': course_category, 'course_level': course_level, 'course_price': course_price}

    modulestore('direct').create_and_save_xmodule(
        dest_location,
        metadata=metadata
    )
    new_course = modulestore('direct').get_item(dest_location)

    # clone a default 'about' overview module as well
    dest_about_location = dest_location.replace(
        category='about',
        name='overview'
    )

    overview_template = AboutDescriptor.get_template('overview.yaml')
    modulestore('direct').create_and_save_xmodule(
        dest_about_location,
        system=new_course.system,
        definition_data=overview_template.get('data')
    )

    initialize_course_tabs(new_course, request.user)

    new_location = loc_mapper().translate_location(new_course.location.course_id, new_course.location, False, True)
    # can't use auth.add_users here b/c it requires request.user to already have Instructor perms in this course
    # however, we can assume that b/c this user had authority to create the course, the user can add themselves
    CourseInstructorRole(new_location).add_users(request.user)
    auth.add_users(request.user, CourseStaffRole(new_location), request.user)

    # seed the forums
    seed_permissions_roles(new_course.location.course_id)

    # auto-enroll the course creator in the course so that "View Live" will
    # work.
    CourseEnrollment.enroll(request.user, new_course.location.course_id)
    _users_assign_default_role(new_course.location)

    # begin change showanswer to attempted
    # it can also add other parameter on Advanced settings
    course_location = loc_mapper().translate_locator_to_location(new_location)
    course_module = get_modulestore(course_location).get_item(course_location) 

    key_val = "/courses/" + org +"/"+ number +"/"+ run + "/notes/api"
    data_json = {
      "showanswer": "always",
      "advanced_modules": ["notes"],
      "annotation_storage_url": key_val,
      'course_audit':'1'
    }
    CourseMetadata.update_from_json(course_module, data_json, True, request.user)
    # end 

    return JsonResponse({'url': new_location.url_reverse("course/", "")})


def _users_assign_default_role(course_location):
    """
    Assign 'Student' role to all previous users (if any) for this course
    """
    enrollments = CourseEnrollment.objects.filter(course_id=course_location.course_id)
    for enrollment in enrollments:
        assign_default_role(course_location.course_id, enrollment.user)


# pylint: disable=unused-argument
@login_required
@ensure_csrf_cookie
@require_http_methods(["GET"])
def course_info_handler(request, tag=None, package_id=None, branch=None, version_guid=None, block=None):
    """
    GET
        html: return html for editing the course info handouts and updates.
    """
    __, course_module = _get_locator_and_course(
        package_id, branch, version_guid, block, request.user
    )
    if 'text/html' in request.META.get('HTTP_ACCEPT', 'text/html'):
        handouts_old_location = course_module.location.replace(category='course_info', name='handouts')
        handouts_locator = loc_mapper().translate_location(
            course_module.location.course_id, handouts_old_location, False, True
        )

        update_location = course_module.location.replace(category='course_info', name='updates')
        update_locator = loc_mapper().translate_location(
            course_module.location.course_id, update_location, False, True
        )

        return render_to_response(
            'course_info.html',
            {
                'context_course': course_module,
                'updates_url': update_locator.url_reverse('course_info_update/'),
                'handouts_locator': handouts_locator,
                'base_asset_url': StaticContent.get_base_url_path_for_course_assets(course_module.location) + '/'
            }
        )
    else:
        return HttpResponseBadRequest("Only supports html requests")


# pylint: disable=unused-argument
@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT", "DELETE"))
@expect_json
def course_info_update_handler(request, tag=None, package_id=None, branch=None, version_guid=None, block=None,
                               provided_id=None):
    """
    restful CRUD operations on course_info updates.
    provided_id should be none if it's new (create) and index otherwise.
    GET
        json: return the course info update models
    POST
        json: create an update
    PUT or DELETE
        json: change an existing update
    """
    if 'application/json' not in request.META.get('HTTP_ACCEPT', 'application/json'):
        return HttpResponseBadRequest("Only supports json requests")

    course_location = loc_mapper().translate_locator_to_location(
        CourseLocator(package_id=package_id), get_course=True
    )
    updates_location = course_location.replace(category='course_info', name=block)
    print course_location
    print updates_location
    if provided_id == '':
        provided_id = None

    # check that logged in user has permissions to this item (GET shouldn't require this level?)
    if not has_course_access(request.user, updates_location):
        raise PermissionDenied()

    if request.method == 'GET':
        course_updates = get_course_updates(updates_location, provided_id)
        if isinstance(course_updates, dict) and course_updates.get('error'):
            return JsonResponse(get_course_updates(updates_location, provided_id), course_updates.get('status', 400))
        else:
            return JsonResponse(get_course_updates(updates_location, provided_id))
    elif request.method == 'DELETE':
        try:
            return JsonResponse(delete_course_update(updates_location, request.json, provided_id, request.user))
        except:
            return HttpResponseBadRequest(
                "Failed to delete",
                content_type="text/plain"
            )
    # can be either and sometimes django is rewriting one to the other:
    elif request.method in ('POST', 'PUT'):
        if  request.json.get('is_send_mail','false')=='true':
            notice_course_update_to_student(request.json,course_location, package_id)
        try:
            return JsonResponse(update_course_updates(updates_location, request.json, provided_id, request.user))
        except:
            return HttpResponseBadRequest(
                "Failed to save",
                content_type="text/plain"
            )

def notice_course_update_to_student(json,course_location,package_id):
    # 发送邮件给所有的注册学生
    queue = Queue.Queue()
    course_module = modulestore().get_item(course_location, depth=0)
    sub = "课程  [" + course_module.display_name_with_default.encode("utf-8") + ']  更新提醒'
    try:
        update_content = json['content']
        update_content = "<p>感谢您参加人卫慕课"+course_module.display_name_with_default.encode("utf-8")+"课程，目前该门课程有新内容更新，具体如下：</p><p>"+"\n\n"+update_content+"\n\n"+"</p><p>为了保证您的学习进度，请尽快开始学习，"+course_module.display_name_with_default.encode("utf-8")+"课程团队竭诚为您服务。<br/>祝您学习愉快!<br/>"+course_module.display_name_with_default.encode("utf-8")+"课程团队</p>"
        student_email_list = analytics.basic.enrolled_students_features(package_id.replace(".", "/"), ['email'])
        print student_email_list
        student_data_email_list = []
        for i in student_email_list:
            queue.put(i.values()[0])

        for k in range(2):
            threadname = 'Thread' + str(k)
            send_mail_update(threadname, queue, update_content, sub)
            print 'success'
        # queue.join()
    except:
        raise
        print 'failure'


@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "PUT", "POST"))
@expect_json
def settings_handler(request, tag=None, package_id=None, branch=None, version_guid=None, block=None):
    """
    Course settings for dates and about pages
    GET
        html: get the page
        json: get the CourseDetails model
    PUT
        json: update the Course and About xblocks through the CourseDetails model
    """
    locator, course_module = _get_locator_and_course(
        package_id, branch, version_guid, block, request.user
    )
    if 'text/html' in request.META.get('HTTP_ACCEPT', '') and request.method == 'GET':
        upload_asset_url = locator.url_reverse('assets/')

        # see if the ORG of this course can be attributed to a 'Microsite'. In that case, the
        # course about page should be editable in Studio
        about_page_editable = not microsite.get_value_for_org(
            course_module.location.org,
            'ENABLE_MKTG_SITE',
            settings.FEATURES.get('ENABLE_MKTG_SITE', False)
        )
        short_description_editable = settings.FEATURES.get('EDITABLE_SHORT_DESCRIPTION', True)

        return render_to_response('settings.html', {
            'context_course': course_module,
            'course_locator': locator,
            'lms_link_for_about_page': utils.get_lms_link_for_about_page(course_module.location),
            'course_image_url': utils.course_image_url(course_module),
            'details_url': locator.url_reverse('/settings/details/'),
            'about_page_editable': about_page_editable,
            'short_description_editable': short_description_editable,
            'upload_asset_url': upload_asset_url
        })
    elif 'application/json' in request.META.get('HTTP_ACCEPT', ''):
        if request.method == 'GET':
            return JsonResponse(
                CourseDetails.fetch(locator),
                # encoder serializes dates, old locations, and instances
                encoder=CourseSettingsEncoder
            )
        else:  # post or put, doesn't matter.
            return JsonResponse(
                CourseDetails.update_from_json(locator, request.json, request.user),
                encoder=CourseSettingsEncoder
            )


@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT", "DELETE"))
@expect_json
def grading_handler(request, tag=None, package_id=None, branch=None, version_guid=None, block=None, grader_index=None):
    """
    Course Grading policy configuration
    GET
        html: get the page
        json no grader_index: get the CourseGrading model (graceperiod, cutoffs, and graders)
        json w/ grader_index: get the specific grader
    PUT
        json no grader_index: update the Course through the CourseGrading model
        json w/ grader_index: create or update the specific grader (create if index out of range)
    """
    locator, course_module = _get_locator_and_course(
        package_id, branch, version_guid, block, request.user
    )

    if 'text/html' in request.META.get('HTTP_ACCEPT', '') and request.method == 'GET':
        course_details = CourseGradingModel.fetch(locator)

        return render_to_response('settings_graders.html', {
            'context_course': course_module,
            'course_locator': locator,
            'course_details': json.dumps(course_details, cls=CourseSettingsEncoder),
            'grading_url': locator.url_reverse('/settings/grading/'),
        })
    elif 'application/json' in request.META.get('HTTP_ACCEPT', ''):
        if request.method == 'GET':
            if grader_index is None:
                return JsonResponse(
                    CourseGradingModel.fetch(locator),
                    # encoder serializes dates, old locations, and instances
                    encoder=CourseSettingsEncoder
                )
            else:
                return JsonResponse(CourseGradingModel.fetch_grader(locator, grader_index))
        elif request.method in ('POST', 'PUT'):  # post or put, doesn't matter.
            # None implies update the whole model (cutoffs, graceperiod, and graders) not a specific grader
            if grader_index is None:
                return JsonResponse(
                    CourseGradingModel.update_from_json(locator, request.json, request.user),
                    encoder=CourseSettingsEncoder
                )
            else:
                return JsonResponse(
                    CourseGradingModel.update_grader_from_json(locator, request.json, request.user)
                )
        elif request.method == "DELETE" and grader_index is not None:
            CourseGradingModel.delete_grader(locator, grader_index, request.user)
            return JsonResponse()


# pylint: disable=invalid-name
def _config_course_advanced_components(request, course_module):
    """
    Check to see if the user instantiated any advanced components. This
    is a hack that does the following :
    1) adds/removes the open ended panel tab to a course automatically
    if the user has indicated that they want to edit the
    combinedopendended or peergrading module
    2) adds/removes the notes panel tab to a course automatically if
    the user has indicated that they want the notes module enabled in
    their course
    """
    # TODO refactor the above into distinct advanced policy settings
    filter_tabs = True  # Exceptional conditions will pull this to False
    if ADVANCED_COMPONENT_POLICY_KEY in request.json:  # Maps tab types to components
        tab_component_map = {
            'open_ended': OPEN_ENDED_COMPONENT_TYPES,
            'notes': NOTE_COMPONENT_TYPES,
        }
        # Check to see if the user instantiated any notes or open ended
        # components
        for tab_type in tab_component_map.keys():
            component_types = tab_component_map.get(tab_type)
            found_ac_type = False
            for ac_type in component_types:
                if ac_type in request.json[ADVANCED_COMPONENT_POLICY_KEY]:
                    # Add tab to the course if needed
                    changed, new_tabs = add_extra_panel_tab(tab_type, course_module)
                    # If a tab has been added to the course, then send the
                    # metadata along to CourseMetadata.update_from_json
                    if changed:
                        course_module.tabs = new_tabs
                        request.json.update({'tabs': new_tabs})
                        # Indicate that tabs should not be filtered out of
                        # the metadata
                        filter_tabs = False  # Set this flag to avoid the tab removal code below.
                    found_ac_type = True  #break

            # If we did not find a module type in the advanced settings,
            # we may need to remove the tab from the course.
            if not found_ac_type:  # Remove tab from the course if needed
                changed, new_tabs = remove_extra_panel_tab(tab_type, course_module)
                if changed:
                    course_module.tabs = new_tabs
                    request.json.update({'tabs':new_tabs})
                    # Indicate that tabs should *not* be filtered out of
                    # the metadata
                    filter_tabs = False

    return filter_tabs

@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT"))
@expect_json
def calendar_common(request, course_id):
    """
    Course settings configuration
    GET
        html: get the page
        json: get the model
    PUT, POST
        json: update the Course's settings. The payload is a json rep of the
            metadata dicts. The dict can include a "unsetKeys" entry which is a list
            of keys whose values to unset: i.e., revert to default
    """
    return render_to_response('calendar_common.html', {    })


@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT"))
@expect_json
def calendar_settings_handler(request, package_id=None, branch=None, version_guid=None, block=None, tag=None):
    locator, course_module = _get_locator_and_course(
        package_id, branch, version_guid, block, request.user
    )
    if 'text/html' in request.META.get('HTTP_ACCEPT', '') and request.method == 'GET':

        return render_to_response('settings_calendar.html', {
            'package_id': package_id,
            'context_course': course_module,
            'advanced_dict': json.dumps(CourseMetadata.fetch(course_module)),
            'advanced_settings_url': locator.url_reverse('settings/calendar')
        })
    elif 'application/json' in request.META.get('HTTP_ACCEPT', ''):
        if request.method == 'GET':
            return JsonResponse(CourseMetadata.fetch(course_module))
        else:
            # Whether or not to filter the tabs key out of the settings metadata
            filter_tabs = _config_course_advanced_components(request, course_module)
            try:
                return JsonResponse(CourseMetadata.update_from_json(
                    course_module,
                    request.json,
                    filter_tabs=filter_tabs,
                    user=request.user,
                ))
            except (TypeError, ValueError) as err:
                return HttpResponseBadRequest(
                    "Incorrect setting format. {}".format(err),
                    content_type="text/plain"
                )



@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT"))
@expect_json
def calendar_common_addevent(request,course_id):
    return JsonResponse(modulestore("course_calendar").save_event(course_id,{"title":request.GET.get("title"),"start":request.GET.get("start"),"end":request.GET.get("end")}))


@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT"))
@expect_json
def calendar_common_delevent(request,course_id):
    print request.GET.get("title")
    print request.GET.get("start")
    print request.GET.get("end")
    return modulestore("course_calendar")._get_cals()

@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT"))
@expect_json
def calendar_common_updateevent(request,course_id):
    event_id = request.GET.get("id")
    start = request.GET.get("start")
    end = request.GET.get("end")
    title = request.GET.get("title")
    modulestore("course_calendar").update_event(course_id,event_id,{"title":title, "start": start, "end": end})
    return JsonResponse({"success":1})


@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT"))
@expect_json
def calendar_settings_getevents(request, course_id):
    events_json = []
    for event in  modulestore("course_calendar").range_events(course_id,request.GET.get("start"),request.GET.get("end")):
        events_json.append({"id":event["id"],"title":event["calendar"]["title"],"start":event["calendar"]["start"],"end":event["calendar"]["end"]})

    return JsonResponse(events_json)

@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT"))
@expect_json
def calendar_common_deleteevent(request, course_id):
    events_json = []
    modulestore("course_calendar").delete_event(request.GET.get("delete_id"))
    return JsonResponse({"success":1})



@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT"))
@expect_json
def advanced_settings_handler(request, package_id=None, branch=None, version_guid=None, block=None, tag=None):
    """
    Course settings configuration
    GET
        html: get the page
        json: get the model
    PUT, POST
        json: update the Course's settings. The payload is a json rep of the
            metadata dicts. The dict can include a "unsetKeys" entry which is a list
            of keys whose values to unset: i.e., revert to default
    """
    locator, course_module = _get_locator_and_course(
        package_id, branch, version_guid, block, request.user
    )
    if 'text/html' in request.META.get('HTTP_ACCEPT', '') and request.method == 'GET':

        return render_to_response('settings_advanced.html', {
            'context_course': course_module,
            'advanced_dict': json.dumps(CourseMetadata.fetch(course_module)),
            'advanced_settings_url': locator.url_reverse('settings/advanced')
        })
    elif 'application/json' in request.META.get('HTTP_ACCEPT', ''):
        if request.method == 'GET':
            return JsonResponse(CourseMetadata.fetch(course_module))
        else:
            # Whether or not to filter the tabs key out of the settings metadata
            filter_tabs = _config_course_advanced_components(request, course_module)
            try:
                return JsonResponse(CourseMetadata.update_from_json(
                    course_module,
                    request.json,
                    filter_tabs=filter_tabs,
                    user=request.user,
                ))
            except (TypeError, ValueError) as err:
                return HttpResponseBadRequest(
                    "Incorrect setting format. {}".format(err),
                    content_type="text/plain"
                )


class TextbookValidationError(Exception):
    "An error thrown when a textbook input is invalid"
    pass


def validate_textbooks_json(text):
    """
    Validate the given text as representing a single PDF textbook
    """
    try:
        textbooks = json.loads(text)
    except ValueError:
        raise TextbookValidationError("invalid JSON")
    if not isinstance(textbooks, (list, tuple)):
        raise TextbookValidationError("must be JSON list")
    for textbook in textbooks:
        validate_textbook_json(textbook)
    # check specified IDs for uniqueness
    all_ids = [textbook["id"] for textbook in textbooks if "id" in textbook]
    unique_ids = set(all_ids)
    if len(all_ids) > len(unique_ids):
        raise TextbookValidationError("IDs must be unique")
    return textbooks


def validate_textbook_json(textbook):
    """
    Validate the given text as representing a list of PDF textbooks
    """
    if isinstance(textbook, basestring):
        try:
            textbook = json.loads(textbook)
        except ValueError:
            raise TextbookValidationError("invalid JSON")
    if not isinstance(textbook, dict):
        raise TextbookValidationError("must be JSON object")
    if not textbook.get("tab_title"):
        raise TextbookValidationError("must have tab_title")
    tid = unicode(textbook.get("id", ""))
    if tid and not tid[0].isdigit():
        raise TextbookValidationError("textbook ID must start with a digit")
    return textbook


def assign_textbook_id(textbook, used_ids=()):
    """
    Return an ID that can be assigned to a textbook
    and doesn't match the used_ids
    """
    tid = Location.clean(textbook["tab_title"])
    if not tid[0].isdigit():
        # stick a random digit in front
        tid = random.choice(string.digits) + tid
    while tid in used_ids:
        # add a random ASCII character to the end
        tid = tid + random.choice(string.ascii_lowercase)
    return tid


@require_http_methods(("GET", "POST", "PUT"))
@login_required
@ensure_csrf_cookie
def textbooks_list_handler(request, tag=None, package_id=None, branch=None, version_guid=None, block=None):
    """
    A RESTful handler for textbook collections.

    GET
        html: return textbook list page (Backbone application)
        json: return JSON representation of all textbooks in this course
    POST
        json: create a new textbook for this course
    PUT
        json: overwrite all textbooks in the course with the given list
    """
    locator, course = _get_locator_and_course(
        package_id, branch, version_guid, block, request.user
    )
    store = get_modulestore(course.location)

    if not "application/json" in request.META.get('HTTP_ACCEPT', 'text/html'):
        # return HTML page
        upload_asset_url = locator.url_reverse('assets/', '')
        textbook_url = locator.url_reverse('/textbooks')
        return render_to_response('textbooks.html', {
            'context_course': course,
            'textbooks': course.pdf_textbooks,
            'upload_asset_url': upload_asset_url,
            'textbook_url': textbook_url,
        })

    # from here on down, we know the client has requested JSON
    if request.method == 'GET':
        return JsonResponse(course.pdf_textbooks)
    elif request.method == 'PUT':
        try:
            textbooks = validate_textbooks_json(request.body)
        except TextbookValidationError as err:
            return JsonResponse({"error": err.message}, status=400)

        tids = set(t["id"] for t in textbooks if "id" in t)
        for textbook in textbooks:
            if not "id" in textbook:
                tid = assign_textbook_id(textbook, tids)
                textbook["id"] = tid
                tids.add(tid)

        if not any(tab['type'] == 'pdf_textbooks' for tab in course.tabs):
            course.tabs.append({"type": "pdf_textbooks"})
        course.pdf_textbooks = textbooks
        store.update_item(course, request.user.id)
        return JsonResponse(course.pdf_textbooks)
    elif request.method == 'POST':
        # create a new textbook for the course
        try:
            textbook = validate_textbook_json(request.body)
        except TextbookValidationError as err:
            return JsonResponse({"error": err.message}, status=400)
        if not textbook.get("id"):
            tids = set(t["id"] for t in course.pdf_textbooks if "id" in t)
            textbook["id"] = assign_textbook_id(textbook, tids)
        existing = course.pdf_textbooks
        existing.append(textbook)
        course.pdf_textbooks = existing
        if not any(tab['type'] == 'pdf_textbooks' for tab in course.tabs):
            tabs = course.tabs
            tabs.append({"type": "pdf_textbooks"})
            course.tabs = tabs
        store.update_item(course, request.user.id)
        resp = JsonResponse(textbook, status=201)
        resp["Location"] = locator.url_reverse('textbooks', textbook["id"]).encode("utf-8")
        return resp


@login_required
@ensure_csrf_cookie
@require_http_methods(("GET", "POST", "PUT", "DELETE"))
def textbooks_detail_handler(request, tid, tag=None, package_id=None, branch=None, version_guid=None, block=None):
    """
    JSON API endpoint for manipulating a textbook via its internal ID.
    Used by the Backbone application.

    GET
        json: return JSON representation of textbook
    POST or PUT
        json: update textbook based on provided information
    DELETE
        json: remove textbook
    """
    __, course = _get_locator_and_course(
        package_id, branch, version_guid, block, request.user
    )
    store = get_modulestore(course.location)
    matching_id = [tb for tb in course.pdf_textbooks
                   if unicode(tb.get("id")) == unicode(tid)]
    if matching_id:
        textbook = matching_id[0]
    else:
        textbook = None

    if request.method == 'GET':
        if not textbook:
            return JsonResponse(status=404)
        return JsonResponse(textbook)
    elif request.method in ('POST', 'PUT'):  # can be either and sometimes
                                        # django is rewriting one to the other
        try:
            new_textbook = validate_textbook_json(request.body)
        except TextbookValidationError as err:
            return JsonResponse({"error": err.message}, status=400)
        new_textbook["id"] = tid
        if textbook:
            i = course.pdf_textbooks.index(textbook)
            new_textbooks = course.pdf_textbooks[0:i]
            new_textbooks.append(new_textbook)
            new_textbooks.extend(course.pdf_textbooks[i + 1:])
            course.pdf_textbooks = new_textbooks
        else:
            course.pdf_textbooks.append(new_textbook)
        store.update_item(course, request.user.id)
        return JsonResponse(new_textbook, status=201)
    elif request.method == 'DELETE':
        if not textbook:
            return JsonResponse(status=404)
        i = course.pdf_textbooks.index(textbook)
        new_textbooks = course.pdf_textbooks[0:i]
        new_textbooks.extend(course.pdf_textbooks[i + 1:])
        course.pdf_textbooks = new_textbooks
        store.update_item(course, request.user.id)
        return JsonResponse()


def _get_course_creator_status(user):
    """
    Helper method for returning the course creator status for a particular user,
    taking into account the values of DISABLE_COURSE_CREATION and ENABLE_CREATOR_GROUP.

    If the user passed in has not previously visited the index page, it will be
    added with status 'unrequested' if the course creator group is in use.
    """
    if user.is_staff:
        course_creator_status = 'granted'
    elif settings.FEATURES.get('DISABLE_COURSE_CREATION', False):
        course_creator_status = 'disallowed_for_this_site'
    elif settings.FEATURES.get('ENABLE_CREATOR_GROUP', False):
        course_creator_status = get_course_creator_status(user)
        if course_creator_status is None:
            # User not grandfathered in as an existing user, has not previously visited the dashboard page.
            # Add the user to the course creator admin table with status 'unrequested'.
            add_user_with_status_unrequested(user)
            course_creator_status = get_course_creator_status(user)
    else:
        course_creator_status = 'granted'

    return course_creator_status


@csrf_exempt
def course_audit_api(request, course_id, operation):
    re_json = {"success": False}

    request_method = request.method
    if request_method != "POST":
        return JsonResponse(re_json)
    # get course location and module infomation
    try:
        course_location_info = course_id.split('.')
        locator = BlockUsageLocator(package_id=course_id, branch='draft', version_guid=None, block_id=course_location_info[-1])
        course_location = loc_mapper().translate_locator_to_location(locator)
        course_module = get_modulestore(course_location).get_item(course_location)

        instructors = CourseInstructorRole(locator).users_with_role()
        if len(instructors) <= 0:
            return JsonResponse(re_json)

        user = instructors[0]

        meta_json = {}
        if operation == "pass":
            meta_json["course_audit"] = 1
        elif operation == "offline":
            meta_json["course_audit"] = 0
        else:
            return JsonResponse(re_json)

        re_json["success"] = True
        CourseMetadata.update_from_json(course_module, meta_json, True, user)
        return JsonResponse(re_json)
    except:
        return JsonResponse(re_json)

@csrf_exempt
def institution_upload_teacher(request):
    messg=''
    if request.method == 'POST':
        use_id = request.GET['id']
        form = UploadFileForm(request.POST, request.FILES)
        if form.is_valid():
            filename = form.cleaned_data['file']
            filename_suffix = filename.name.split('.')[-1]
            if filename_suffix == 'xls' or filename_suffix == 'xlsx':
                f = handle_uploaded_file(filename)
                os.chmod(f, 0o777)
                xls_insert_into_db(request, f, use_id)
                messg = '教师导入成功'
            else:
                messg = '上传文件要为excel格式'
    else:
        form = UploadFileForm()
    return JsonResponse({'messg': messg})


def handle_uploaded_file(f):
    f_path = PROJECT_ROOT + '/static/upload/'+f.name.encode('utf8')

    with open(f_path.encode('utf8'), 'wb+') as info:
        for chunk in f.chunks():
            info.write(chunk)
    return f_path.encode('utf8')

def xls_insert_into_db(request, xlsfile, instutition_id):
    wb = xlrd.open_workbook(xlsfile)
    sh = wb.sheet_by_index(0)
    rows = sh.nrows

    def as_display_string(cell):
        if cell.ctype in (2,3):
            cell_value = int(cell.value)
        else:
            cell_value = cell.value
        return str(cell_value).strip()

    for i in range(1, rows):
        username = sh.cell(i, 2).value
        email = sh.cell(i, 0).value
        password = as_display_string(sh.cell(i, 1))
        name = sh.cell(i, 3).value
        post_vars = {
            'username': username,
            'email': email,
            'password': password,
            'name': name
        }
        do_institution_import_teacher_create_account(post_vars, instutition_id)
    return HttpResponseRedirect('/course')

def remove_institute_teacher(request):
    institute_id = request.GET['id']
    profile_user = UserProfile.objects.get(user_id=institute_id)
    profile_user.institute = None
    profile_user.save()
    return JsonResponse('/course')

@login_required
@ensure_csrf_cookie
def teacher_intro_edit(request, id):
    if request.user.id !=int(id):
        raise Http404
    if request.method == 'POST':
        picurl = request.POST.get('picurl', '').strip()
        shortbio = request.POST.get('shortbio', '')
        
        profile = UserProfile.objects.get(user_id=id)
        
        if picurl:
            if not picurl.startswith('http://'):
                picurl = 'http://' + picurl
            profile.picurl = picurl
        profile.shortbio = shortbio
        profile.save()
    
    else:
        profile = UserProfile.objects.get(user_id=id)
        if not profile.shortbio:
            profile.shortbio = ""
    return render_to_response('teacher_intro_edit.html', {'profile':profile})

@ensure_csrf_cookie
def change_picurl_request(request):
    """ Log a request for a new name. """
    print 'change_picurl_request'
    if not request.user.is_authenticated:
        raise Http404

    try:
        pnc = PendingNameChange.objects.get(user=request.user)
    except PendingNameChange.DoesNotExist:
        pnc = PendingNameChange()
    pnc.user = request.user
    pnc.new_name = request.POST['new_picurl']
    if len(pnc.new_name) < 15:
        return JsonResponse({
            "success": False,
            "error": "请输入头像链接",
        })  # TODO: this should be status code 400  # pylint: disable=fixme
    pnc.save()

    # The following automatically accepts name change requests. Remove this to
    # go back to the old system where it gets queued up for admin approval.
    accept_picurl_change_by_id(pnc.id)

    return JsonResponse({"success": True})

@ensure_csrf_cookie
def change_shortbio_request(request):
    """ Log a request for a new name. """
    if not request.user.is_authenticated:
        raise Http404

    try:
        pnc = PendingNameChange.objects.get(user=request.user)
    except PendingNameChange.DoesNotExist:
        pnc = PendingNameChange()
    pnc.user = request.user
    pnc.rationale = request.POST['new_shortbio']
    if len(pnc.rationale) < 1:
        return JsonResponse({
            "success": False,
            "error": "请输入您的个人简介",
        })  # TODO: this should be status code 400  # pylint: disable=fixme
    pnc.save()

    # The following automatically accepts name change requests. Remove this to
    # go back to the old system where it gets queued up for admin approval.
    accept_shortbio_change_by_id(pnc.id)

    return JsonResponse({"success": True})

# import_student
@csrf_exempt
def import_student(request):
    messg=''
    if request.method == 'POST':
        use_id = request.GET['id']
        print use_id
        form = UploadFileForm(request.POST, request.FILES)
        if form.is_valid():
            filename = form.cleaned_data['file']
            filename_suffix = filename.name.split('.')[-1]
            if filename_suffix == 'xls' or filename_suffix == 'xlsx':
                f = handle_uploaded_file(filename)
                os.chmod(f, 0o777)
                xls_student_insert_into_db(request, f, use_id)
                messg = '学生导入成功'
            else:
                messg = '导入文件要为excel格式'
    else:
        form = UploadFileForm()
    return JsonResponse({'messg': messg})

def xls_student_insert_into_db(request, xlsfile, instutition_id):
    wb = xlrd.open_workbook(xlsfile)
    sh = wb.sheet_by_index(0)
    rows = sh.nrows

    def as_display_string(cell):
        if cell.ctype in (2,3):
            cell_value = int(cell.value)
        else:
            cell_value = cell.value
        return str(cell_value).strip()

    for i in range(1, rows):
        username = sh.cell(i, 2).value
        email = sh.cell(i, 0).value
        password = as_display_string(sh.cell(i, 1))
        name = sh.cell(i, 3).value
        post_vars = {
            'username': username,
            'email': email,
            'password': password,
            'name': name
        }
        if len(User.objects.filter(username=post_vars['username'])) > 0:
            post_vars['username'] = post_vars['username'] + str(random.randint(0,10000))
        do_institution_import_student_create_account(post_vars, instutition_id)
    return HttpResponseRedirect('/course')