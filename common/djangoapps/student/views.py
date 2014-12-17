# encoding=utf-8
"""
Student Views
"""
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import datetime
import json
import logging
import re
import urllib
import uuid
import time
import base64
import socket
import urllib2
import hashlib
from suds.client import Client
import xmltodict

from django.utils import timezone
from collections import defaultdict
from pytz import UTC
from Crypto.Cipher import DES

from django.conf import settings
from django.contrib.auth import logout, authenticate, login, load_backend
from django.contrib.auth.models import User, AnonymousUser
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import password_reset_confirm
from django.core.cache import cache
from django.core.context_processors import csrf
from django.core.mail import send_mail
from util.email_utils import send_mails

from django.core.urlresolvers import reverse
from django.core.validators import validate_email, validate_slug, ValidationError
from django.db import IntegrityError, transaction
from django.http import (HttpResponse, HttpResponseBadRequest, HttpResponseForbidden,
                         Http404)
from django.views.decorators.cache import cache_control
from django.shortcuts import redirect
from django_future.csrf import ensure_csrf_cookie
from django.views.decorators.csrf import csrf_exempt
from django.utils.http import cookie_date, base36_to_int
from django.utils.translation import ugettext as _
from django.views.decorators.http import require_POST, require_GET

# captcha
from django import forms
from captcha.fields import CaptchaField

from captcha.helpers import captcha_image_url
from captcha.models import CaptchaStore

from ratelimitbackend.exceptions import RateLimitException
from ratelimitbackend.backends import RateLimitModelBackend

from edxmako.shortcuts import render_to_response, render_to_string

from course_modes.models import CourseMode
from student.models import (
    Registration, UserProfile, PendingNameChange,
    PendingEmailChange, CourseEnrollment, unique_id_for_user,
    CourseEnrollmentAllowed, UserStanding, LoginFailures
)
from student.forms import PasswordResetFormNoActive
from student.firebase_token_generator import create_token

from verify_student.models import SoftwareSecurePhotoVerification, MidcourseReverificationWindow
from certificates.models import CertificateStatuses, certificate_status_for_student
from dark_lang.models import DarkLangConfig

from xmodule.course_module import CourseDescriptor
from xmodule.modulestore.exceptions import ItemNotFoundError
from xmodule.modulestore.django import modulestore
from xmodule.modulestore import XML_MODULESTORE_TYPE, Location

from collections import namedtuple

from instructor.offline_gradecalc import student_grades

from courseware.courses import get_courses, sort_by_announcement, filter_audited_items, get_course_about_section, course_image_url, get_course_by_id
from courseware.access import has_access

from django_comment_common.models import Role

from external_auth.models import ExternalAuthMap
import external_auth.views

from bulk_email.models import Optout, CourseAuthorization
import shoppingcart
from user_api.models import UserPreference
from lang_pref import LANGUAGE_KEY

import track.views

from dogapi import dog_stats_api

from util.json_request import JsonResponse
from util.bad_request_rate_limiter import BadRequestRateLimiter

from microsite_configuration import microsite

from util.password_policy_validators import (
    validate_password_length, validate_password_complexity,
    validate_password_dictionary
)
from syscustom.models import CustomImage

log = logging.getLogger("edx.student")
AUDIT_LOG = logging.getLogger("audit")

Article = namedtuple('Article', 'title url author image deck publication publish_date')
ReverifyInfo = namedtuple('ReverifyInfo', 'course_id course_name course_number date status display')  # pylint: disable=C0103

SYNCUSERATTR = ['username', 'email', 'password', 'gender', 'mailing_address', 'level_of_education']


class CaptchaLoginForm(forms.Form):
    captcha = CaptchaField()


def csrf_token(context):
    """A csrf token that can be included in a form."""
    csrf_token = context.get('csrf_token', '')
    if csrf_token == 'NOTPROVIDED':
        return ''
    return (u'<div style="display:none"><input type="hidden"'
            ' name="csrfmiddlewaretoken" value="%s" /></div>' % (csrf_token))


# Acquire login failure time in five minutes
def failure_time(request_obj):
    try:
        return sum(RateLimitModelBackend().get_counters(request_obj).values())
    except:
        return 0


def audit_courses(request, user=AnonymousUser()):
    # The course selection work is done in courseware.courses.
    domain = settings.FEATURES.get('FORCE_UNIVERSITY_DOMAIN')  # normally False
    # do explicit check, because domain=None is valid
    if domain is False:
        domain = request.META.get('HTTP_HOST')

    courses = get_courses(user, domain=domain)
    
    return filter_audited_items(sort_by_announcement(courses))


# NOTE: This view is not linked to directly--it is called from
# branding/views.py:index(), which is cached for anonymous users.
# This means that it should always return the same thing for anon
# users. (in particular, no switching based on query params allowed)
def index(request, extra_context={}, user=AnonymousUser()):
    """
    Render the edX main page.

    extra_context is used to allow immediate display of certain modal windows, eg signup,
    as used by external_auth.
    """
    context = {"courses": audit_courses(request, user)}
    context.update(extra_context)
    luobo_list = CustomImage.objects.filter(type=1).order_by('order_num', 'id')[:8]
    context['luobo_list'] = luobo_list
    return render_to_response('index.html', context)


def lead_courses(request):
    """
    conditional filter courses
    """
    user = request.user or AnonymousUser()
    crude_courses = audit_courses(request, user)

    # need condition filter
    def uniq_filter_org(courses):
        org_arr = []
        
        for course in courses:
            course_org = course.display_org_with_default.strip()
            if [course_org, course_org] not in org_arr:
                org_arr.append([course_org, course_org])

        return org_arr

    # format string
    def format_course(course):
        format_course_json = {
            "id": course.id,
            "is_new": course.is_newish,
            "course_about_url": reverse('about_course', args=[course.id]),
            "course_number": course.display_number_with_default or "",
            "title": get_course_about_section(course, 'title'),
            "short_description": get_course_about_section(course, "short_description"),
            "img_src": course_image_url(course),
            "university": get_course_about_section(course, 'university'),
            "is_start_date_default": course.start_date_is_still_default,
        }

        if not format_course_json["is_start_date_default"]:
            format_course_json.update({"start_date_text": course.start_date_text})

        return format_course_json

    sel_items = {
        "subject": [
                       ["XSecure", "信息安全基础理论"],
                       ["CTec", "通用安全技术"],
                       ["CManage", "安全管理"],
                       ["SPTec", "专项安全技术"],
                ],
        "level": [
                   ["J", "初级"],
                   ["M", "中级"],
                   ["S", "高级"],
                ],
        "org": uniq_filter_org(crude_courses)
    }

    con_col = {}
    con_courses = []

    org_con = request.GET.get("org", "")
    con_col.update({"orgCon": org_con.split(',')})
    
    subject_con = request.GET.get("subject", "")
    con_col.update({"subCon": subject_con.split(',')})

    level_con = request.GET.get('level', "")
    con_col.update({"levelCon": level_con.split(',')})

    for course in crude_courses:
        # acquire org condition
        org_flag = False
        if org_con:    
            if "all" in con_col["orgCon"] or ("all" not in con_col["orgCon"] and course.display_org_with_default in con_col["orgCon"]):
                if course in con_courses:
                    continue
                con_courses.append(course)
        else:
            org_flag = True


        # acquire subject condition
        subject_flag = False
        if subject_con:   
            if "all" in con_col['subCon'] or ("all" not in con_col['subCon'] and course.course_category in con_col['subCon']):
                if course in con_courses:
                    continue
                con_courses.append(course) 
        else:
            subject_flag = True


        # acquire level condition
        level_flag = False
        if level_con:
            if "all" in con_col['levelCon'] or ("all" not in con_col['levelCon'] and course.course_level in con_col['levelCon']):
                if course in con_courses:
                    continue
                con_courses.append(course)
        else:
            level_flag = True

        if org_flag and subject_flag and level_flag:
            con_courses = crude_courses
            break

    # acquire course_id condition
    def course_dep(crucourses, course_id):
        course_index = 0
        try:
            for idx, c in enumerate(crucourses):
                if c.id == course_id:
                    course_index = (idx + 1)
                    break
        except:
            course_index = 0

        courses_list = crucourses[course_index: course_index + 3]

        return courses_list

    id_con = request.GET.get('course_id', '').strip()
    con_col.update({'course_id': id_con})
    con_courses = course_dep(con_courses, id_con)

    context = {"courses": con_courses}
    context.update(sel_items)
    context.update(con_col)

    if request.is_ajax():
        context["courses"] = map(format_course, context["courses"])
        return JsonResponse(context)

    return render_to_response('lead_courses.html', context)


def course_from_id(course_id):
    """Return the CourseDescriptor corresponding to this course_id"""
    course_loc = CourseDescriptor.id_to_location(course_id)
    return modulestore().get_instance(course_id, course_loc)

day_pattern = re.compile(r'\s\d+,\s')
multimonth_pattern = re.compile(r'\s?\-\s?\S+\s')


def _get_date_for_press(publish_date):
    # strip off extra months, and just use the first:
    date = re.sub(multimonth_pattern, ", ", publish_date)
    if re.search(day_pattern, date):
        date = datetime.datetime.strptime(date, "%B %d, %Y").replace(tzinfo=UTC)
    else:
        date = datetime.datetime.strptime(date, "%B, %Y").replace(tzinfo=UTC)
    return date


def embargo(_request):
    """
    Render the embargo page.

    Explains to the user why they are not able to access a particular embargoed course.
    """
    return render_to_response('static_templates/embargo.html')


def press(request):
    json_articles = cache.get("student_press_json_articles")
    if json_articles is None:
        if hasattr(settings, 'RSS_URL'):
            content = urllib.urlopen(settings.PRESS_URL).read()
            json_articles = json.loads(content)
        else:
            content = open(settings.PROJECT_ROOT / "templates" / "press.json").read()
            json_articles = json.loads(content)
        cache.set("student_press_json_articles", json_articles)
    articles = [Article(**article) for article in json_articles]
    articles.sort(key=lambda item: _get_date_for_press(item.publish_date), reverse=True)
    return render_to_response('static_templates/press.html', {'articles': articles})


def process_survey_link(survey_link, user):
    """
    If {UNIQUE_ID} appears in the link, replace it with a unique id for the user.
    Currently, this is sha1(user.username).  Otherwise, return survey_link.
    """
    return survey_link.format(UNIQUE_ID=unique_id_for_user(user))


def cert_info(user, course):
    """
    Get the certificate info needed to render the dashboard section for the given
    student and course.  Returns a dictionary with keys:

    'status': one of 'generating', 'ready', 'notpassing', 'processing', 'restricted'
    'show_download_url': bool
    'download_url': url, only present if show_download_url is True
    'show_disabled_download_button': bool -- true if state is 'generating'
    'show_survey_button': bool
    'survey_url': url, only if show_survey_button is True
    'grade': if status is not 'processing'
    """
    if not course.has_ended():
        return {}

    return _cert_info(user, course, certificate_status_for_student(user, course.id))


def reverification_info(course_enrollment_pairs, user, statuses):
    """
    Returns reverification-related information for *all* of user's enrollments whose
    reverification status is in status_list

    Args:
        course_enrollment_pairs (list): list of (course, enrollment) tuples
        user (User): the user whose information we want
        statuses (list): a list of reverification statuses we want information for
            example: ["must_reverify", "denied"]

    Returns:
        dictionary of lists: dictionary with one key per status, e.g.
            dict["must_reverify"] = []
            dict["must_reverify"] = [some information]
    """
    reverifications = defaultdict(list)
    for (course, enrollment) in course_enrollment_pairs:
        info = single_course_reverification_info(user, course, enrollment)
        if info:
            reverifications[info.status].append(info)

    # Sort the data by the reverification_end_date
    for status in statuses:
        if reverifications[status]:
            reverifications[status].sort(key=lambda x: x.date)
    return reverifications


def single_course_reverification_info(user, course, enrollment):  # pylint: disable=invalid-name
    """Returns midcourse reverification-related information for user with enrollment in course.

    If a course has an open re-verification window, and that user has a verified enrollment in
    the course, we return a tuple with relevant information. Returns None if there is no info..

    Args:
        user (User): the user we want to get information for
        course (Course): the course in which the student is enrolled
        enrollment (CourseEnrollment): the object representing the type of enrollment user has in course

    Returns:
        ReverifyInfo: (course_id, course_name, course_number, date, status)
        OR, None: None if there is no re-verification info for this enrollment
    """
    window = MidcourseReverificationWindow.get_window(course.id, datetime.datetime.now(UTC))

    # If there's no window OR the user is not verified, we don't get reverification info
    if (not window) or (enrollment.mode != "verified"):
        return None
    return ReverifyInfo(
        course.id, course.display_name, course.number,
        window.end_date.strftime('%B %d, %Y %X %p'),
        SoftwareSecurePhotoVerification.user_status(user, window)[0],
        SoftwareSecurePhotoVerification.display_status(user, window),
    )


def get_course_enrollment_pairs(user, course_org_filter, org_filter_out_set):
    """
    Get the relevant set of (Course, CourseEnrollment) pairs to be displayed on
    a student's dashboard.
    """
    for enrollment in CourseEnrollment.enrollments_for_user(user):
        try:
            course = course_from_id(enrollment.course_id)

            # if we are in a Microsite, then filter out anything that is not
            # attributed (by ORG) to that Microsite
            if course_org_filter and course_org_filter != course.location.org:
                continue
            # Conversely, if we are not in a Microsite, then let's filter out any enrollments
            # with courses attributed (by ORG) to Microsites
            elif course.location.org in org_filter_out_set:
                continue

            yield (course, enrollment)
        except ItemNotFoundError:
            log.error("User {0} enrolled in non-existent course {1}"
                      .format(user.username, enrollment.course_id))


def _cert_info(user, course, cert_status):
    """
    Implements the logic for cert_info -- split out for testing.
    """
    default_status = 'processing'

    default_info = {'status': default_status,
                    'show_disabled_download_button': False,
                    'show_download_url': False,
                    'show_survey_button': False,
                    }

    if cert_status is None:
        return default_info

    # simplify the status for the template using this lookup table
    template_state = {
        CertificateStatuses.generating: 'generating',
        CertificateStatuses.regenerating: 'generating',
        CertificateStatuses.downloadable: 'ready',
        CertificateStatuses.notpassing: 'notpassing',
        CertificateStatuses.restricted: 'restricted',
    }

    status = template_state.get(cert_status['status'], default_status)

    d = {'status': status,
         'show_download_url': status == 'ready',
         'show_disabled_download_button': status == 'generating',
         'mode': cert_status.get('mode', None)}

    if (status in ('generating', 'ready', 'notpassing', 'restricted') and
            course.end_of_course_survey_url is not None):
        d.update({
            'show_survey_button': True,
            'survey_url': process_survey_link(course.end_of_course_survey_url, user)})
    else:
        d['show_survey_button'] = False

    if status == 'ready':
        if 'download_url' not in cert_status:
            log.warning("User %s has a downloadable cert for %s, but no download url",
                        user.username, course.id)
            return default_info
        else:
            d['download_url'] = cert_status['download_url']

    if status in ('generating', 'ready', 'notpassing', 'restricted'):
        if 'grade' not in cert_status:
            # Note: as of 11/20/2012, we know there are students in this state-- cs169.1x,
            # who need to be regraded (we weren't tracking 'notpassing' at first).
            # We can add a log.warning here once we think it shouldn't happen.
            return default_info
        else:
            d['grade'] = cert_status['grade']

    return d


@ensure_csrf_cookie
def signin_user(request):
    """
    This view will display the non-modal login form
    """
    if (settings.FEATURES['AUTH_USE_CERTIFICATES'] and
            external_auth.views.ssl_get_cert_from_request(request)):
        # SSL login doesn't require a view, so redirect
        # branding and allow that to process the login if it
        # is enabled and the header is in the request.
        return redirect(reverse('root'))
    if request.user.is_authenticated():
        return redirect(reverse('dashboard'))

    flag =request.GET.get('flag',0)

    form = CaptchaLoginForm()

    if request.is_ajax():
        new_cptch_key = CaptchaStore.generate_key()
        cpt_image_url = captcha_image_url(new_cptch_key)

        return JsonResponse({'captcha_image_url': cpt_image_url})

    context = {
        'flag':flag,
        'course_id': request.GET.get('course_id'),
        'enrollment_action': request.GET.get('enrollment_action'),
        'platform_name': microsite.get_value(
            'platform_name',
            settings.PLATFORM_NAME
        ),
        'form': form,
    }
    return render_to_response('login.html', context)

@ensure_csrf_cookie
def register_user(request, extra_context=None):
    """
    This view will display the non-modal registration form
    """
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

    if context.get("extauth_domain", '').startswith(external_auth.views.SHIBBOLETH_DOMAIN_PREFIX):
        return render_to_response('register-shib.html', context)
    return render_to_response('register.html', context)


def complete_course_mode_info(course_id, enrollment):
    """
    We would like to compute some more information from the given course modes
    and the user's current enrollment

    Returns the given information:
        - whether to show the course upsell information
        - numbers of days until they can't upsell anymore
    """
    modes = CourseMode.modes_for_course_dict(course_id)
    mode_info = {'show_upsell': False, 'days_for_upsell': None}
    # we want to know if the user is already verified and if verified is an
    # option
    if 'verified' in modes and enrollment.mode != 'verified':
        mode_info['show_upsell'] = True
        # if there is an expiration date, find out how long from now it is
        if modes['verified'].expiration_datetime:
            today = datetime.datetime.now(UTC).date()
            mode_info['days_for_upsell'] = (modes['verified'].expiration_datetime.date() - today).days

    return mode_info


@login_required
@ensure_csrf_cookie
def dashboard(request):
    user = request.user

    # for microsites, we want to filter and only show enrollments for courses within
    # the microsites 'ORG'
    course_org_filter = microsite.get_value('course_org_filter')

    # Let's filter out any courses in an "org" that has been declared to be
    # in a Microsite
    org_filter_out_set = microsite.get_all_orgs()

    # remove our current Microsite from the "filter out" list, if applicable
    if course_org_filter:
        org_filter_out_set.remove(course_org_filter)

    # Build our (course, enrollment) list for the user, but ignore any courses that no
    # longer exist (because the course IDs have changed). Still, we don't delete those
    # enrollments, because it could have been a data push snafu.
    course_enrollment_pairs = list(get_course_enrollment_pairs(user, course_org_filter, org_filter_out_set))

    course_optouts = Optout.objects.filter(user=user).values_list('course_id', flat=True)

    message = ""
    if not user.is_active:
        message = render_to_string('registration/activate_account_notice.html', {'email': user.email})

    # Global staff can see what courses errored on their dashboard
    staff_access = False
    errored_courses = {}
    if has_access(user, 'global', 'staff'):
        # Show any courses that errored on load
        staff_access = True
        errored_courses = modulestore().get_errored_courses()

    show_courseware_links_for = frozenset(course.id for course, _enrollment in course_enrollment_pairs
                                          if has_access(request.user, course, 'load'))

    course_modes = {course.id: complete_course_mode_info(course.id, enrollment) for course, enrollment in course_enrollment_pairs}
    cert_statuses = {course.id: cert_info(request.user, course) for course, _enrollment in course_enrollment_pairs}

    # only show email settings for Mongo course and when bulk email is turned on
    show_email_settings_for = frozenset(
        course.id for course, _enrollment in course_enrollment_pairs if (
            settings.FEATURES['ENABLE_INSTRUCTOR_EMAIL'] and
            modulestore().get_modulestore_type(course.id) != XML_MODULESTORE_TYPE and
            CourseAuthorization.instructor_email_enabled(course.id)
        )
    )

    # Verification Attempts
    # Used to generate the "you must reverify for course x" banner
    verification_status, verification_msg = SoftwareSecurePhotoVerification.user_status(user)

    # Gets data for midcourse reverifications, if any are necessary or have failed
    statuses = ["approved", "denied", "pending", "must_reverify"]
    reverifications = reverification_info(course_enrollment_pairs, user, statuses)

    show_refund_option_for = frozenset(course.id for course, _enrollment in course_enrollment_pairs
                                       if _enrollment.refundable())

    # get info w.r.t ExternalAuthMap
    external_auth_map = None
    try:
        external_auth_map = ExternalAuthMap.objects.get(user=user)
    except ExternalAuthMap.DoesNotExist:
        pass

    # If there are *any* denied reverifications that have not been toggled off,
    # we'll display the banner
    denied_banner = any(item.display for item in reverifications["denied"])

    language_options = DarkLangConfig.current().released_languages_list

    # add in the default language if it's not in the list of released languages
    if settings.LANGUAGE_CODE not in language_options:
        language_options.append(settings.LANGUAGE_CODE)

    # try to get the prefered language for the user
    cur_lang_code = UserPreference.get_preference(request.user, LANGUAGE_KEY)
    if cur_lang_code:
        # if the user has a preference, get the name from the code
        current_language = settings.LANGUAGE_DICT[cur_lang_code]
    else:
        # if the user doesn't have a preference, use the default language
        current_language = settings.LANGUAGE_DICT[settings.LANGUAGE_CODE]

    context = {
        'course_enrollment_pairs': course_enrollment_pairs,
        'course_optouts': course_optouts,
        'message': message,
        'external_auth_map': external_auth_map,
        'staff_access': staff_access,
        'errored_courses': errored_courses,
        'show_courseware_links_for': show_courseware_links_for,
        'all_course_modes': course_modes,
        'cert_statuses': cert_statuses,
        'show_email_settings_for': show_email_settings_for,
        'reverifications': reverifications,
        'verification_status': verification_status,
        'verification_msg': verification_msg,
        'show_refund_option_for': show_refund_option_for,
        'denied_banner': denied_banner,
        'billing_email': settings.PAYMENT_SUPPORT_EMAIL,
        'language_options': language_options,
        'current_language': current_language,
        'current_language_code': cur_lang_code,
    }

    return render_to_response('dashboard.html', context)


def try_change_enrollment(request):
    """
    This method calls change_enrollment if the necessary POST
    parameters are present, but does not return anything. It
    simply logs the result or exception. This is usually
    called after a registration or login, as secondary action.
    It should not interrupt a successful registration or login.
    """
    if 'enrollment_action' in request.POST:
        try:
            enrollment_response = change_enrollment(request)
            # There isn't really a way to display the results to the user, so we just log it
            # We expect the enrollment to be a success, and will show up on the dashboard anyway
            log.info(
                "Attempted to automatically enroll after login. Response code: {0}; response body: {1}".format(
                    enrollment_response.status_code,
                    enrollment_response.content
                )
            )
            if enrollment_response.content != '':
                return enrollment_response.content
        except Exception, e:
            log.exception("Exception automatically enrolling after login: {0}".format(str(e)))


@require_POST
@csrf_exempt
def mobi_change_enrollment(request):
    """
    for mobile api function to change register class status
    """
    if "application/json" not in request.META.get('HTTP_ACCEPT', 'application/json'):
        return HttpResponseBadRequest('Only supports json requests')

    user = request.user
    params = eval(request.body)

    if 'action' in params and 'courseid' in params:
        action, course_id = params["action"], params['courseid']
    else:
        return JsonResponse({"success": False, 'errmsg': 'Action and courseid must be included params'})

    if not user.is_authenticated():
        return JsonResponse({"success": False, 'errmsg': 'Authentication failed'})

    if not isinstance(course_id, list):
        course_ids_list = [course_id]
    else:
        course_ids_list = course_id

    success_oper = []
    if action == 'enroll':
        for c in course_ids_list:
            c = unicode(c.replace('.', '/'))
            try:
                course = course_from_id(c)
            except ItemNotFoundError:
                continue

            if not has_access(user, course, 'enroll'):
                continue

            is_course_full = CourseEnrollment.is_course_full(course)

            if is_course_full:
                continue

            available_modes = CourseMode.modes_for_course(c)
            if len(available_modes) > 1:
                return HttpResponse(
                    reverse("course_modes_choose", kwargs={'course_id': c})
                )

            current_mode = available_modes[0]

            course_id_dict = Location.parse_course_id(c)
            dog_stats_api.increment(
                "common.student.enrollment",
                tags=[u"org:{org}".format(**course_id_dict),
                      u"course:{course}".format(**course_id_dict),
                      u"run:{name}".format(**course_id_dict)]
            )

            CourseEnrollment.enroll(user, course.id, mode=current_mode.slug)
            success_oper.append(c.replace('/', '.'))

        return JsonResponse({"success": True, 'success_enrolled': success_oper})
    elif action == 'unenroll':
        for c in course_ids_list:
            c = c.replace('.', '/')

            if not CourseEnrollment.is_enrolled(user, c):
                continue

            CourseEnrollment.unenroll(user, c)
            success_oper.append(c.replace('/', '.'))
            course_id_dict = Location.parse_course_id(c)
            dog_stats_api.increment(
                "common.student.unenrollment",
                tags=[u"org:{org}".format(**course_id_dict),
                      u"course:{course}".format(**course_id_dict),
                      u"run:{name}".format(**course_id_dict)]
            )

        return JsonResponse({"success": True, 'success_unenrolled': success_oper})

    else:
        return JsonResponse({"success": False, "errmsg": "error action"})


@require_POST
def change_enrollment(request):
    """
    Modify the enrollment status for the logged-in user.

    The request parameter must be a POST request (other methods return 405)
    that specifies course_id and enrollment_action parameters. If course_id or
    enrollment_action is not specified, if course_id is not valid, if
    enrollment_action is something other than "enroll" or "unenroll", if
    enrollment_action is "enroll" and enrollment is closed for the course, or
    if enrollment_action is "unenroll" and the user is not enrolled in the
    course, a 400 error will be returned. If the user is not logged in, 403
    will be returned; it is important that only this case return 403 so the
    front end can redirect the user to a registration or login page when this
    happens. This function should only be called from an AJAX request or
    as a post-login/registration helper, so the error messages in the responses
    should never actually be user-visible.
    """
    user = request.user

    action = request.POST.get("enrollment_action")
    course_id = request.POST.get("course_id")
    if course_id is None:
        return HttpResponseBadRequest(_("Course id not specified"))

    if not user.is_authenticated():
        return HttpResponseForbidden()

    if action == "enroll":
        # Make sure the course exists
        # We don't do this check on unenroll, or a bad course id can't be unenrolled from
        try:
            course = course_from_id(course_id)
        except ItemNotFoundError:
            log.warning("User {0} tried to enroll in non-existent course {1}"
                        .format(user.username, course_id))
            return HttpResponseBadRequest(_("Course id is invalid"))

        if not has_access(user, course, 'enroll'):
            return HttpResponseBadRequest(_("Enrollment is closed"))

        # see if we have already filled up all allowed enrollments
        is_course_full = CourseEnrollment.is_course_full(course)

        if is_course_full:
            return HttpResponseBadRequest(_("Course is full"))

        # If this course is available in multiple modes, redirect them to a page
        # where they can choose which mode they want.
        available_modes = CourseMode.modes_for_course(course_id)
        if len(available_modes) > 1:
            return HttpResponse(
                reverse("course_modes_choose", kwargs={'course_id': course_id})
            )

        current_mode = available_modes[0]

        course_id_dict = Location.parse_course_id(course_id)
        dog_stats_api.increment(
            "common.student.enrollment",
            tags=[u"org:{org}".format(**course_id_dict),
                  u"course:{course}".format(**course_id_dict),
                  u"run:{name}".format(**course_id_dict)]
        )

        CourseEnrollment.enroll(user, course.id, mode=current_mode.slug)

        return HttpResponse()

    elif action == "add_to_cart":
        # Pass the request handling to shoppingcart.views
        # The view in shoppingcart.views performs error handling and logs different errors.  But this elif clause
        # is only used in the "auto-add after user reg/login" case, i.e. it's always wrapped in try_change_enrollment.
        # This means there's no good way to display error messages to the user.  So we log the errors and send
        # the user to the shopping cart page always, where they can reasonably discern the status of their cart,
        # whether things got added, etc

        shoppingcart.views.add_course_to_cart(request, course_id)
        return HttpResponse(
            reverse("shoppingcart.views.show_cart")
        )

    elif action == "unenroll":
        if not CourseEnrollment.is_enrolled(user, course_id):
            return HttpResponseBadRequest(_("You are not enrolled in this course"))
        CourseEnrollment.unenroll(user, course_id)
        course_id_dict = Location.parse_course_id(course_id)
        dog_stats_api.increment(
            "common.student.unenrollment",
            tags=[u"org:{org}".format(**course_id_dict),
                  u"course:{course}".format(**course_id_dict),
                  u"run:{name}".format(**course_id_dict)]
        )
        return HttpResponse()
    else:
        return HttpResponseBadRequest(_("Enrollment action is invalid"))


def _parse_course_id_from_string(input_str):
    """
    Helper function to determine if input_str (typically the queryparam 'next') contains a course_id.
    @param input_str:
    @return: the course_id if found, None if not
    """
    m_obj = re.match(r'^/courses/(?P<course_id>[^/]+/[^/]+/[^/]+)', input_str)
    if m_obj:
        return m_obj.group('course_id')
    return None


def _get_course_enrollment_domain(course_id):
    """
    Helper function to get the enrollment domain set for a course with id course_id
    @param course_id:
    @return:
    """
    try:
        course = course_from_id(course_id)
        return course.enrollment_domain
    except ItemNotFoundError:
        return None


@ensure_csrf_cookie
def accounts_login(request):
    """
    This view is mainly used as the redirect from the @login_required decorator.  I don't believe that
    the login path linked from the homepage uses it.
    """
    if settings.FEATURES.get('AUTH_USE_CAS'):
        return redirect(reverse('cas-login'))
    if settings.FEATURES['AUTH_USE_CERTIFICATES']:
        # SSL login doesn't require a view, so redirect
        # to branding and allow that to process the login.
        return redirect(reverse('root'))
    # see if the "next" parameter has been set, whether it has a course context, and if so, whether
    # there is a course-specific place to redirect
    redirect_to = request.GET.get('next')
    if redirect_to:
        course_id = _parse_course_id_from_string(redirect_to)
        if course_id and _get_course_enrollment_domain(course_id):
            return external_auth.views.course_specific_login(request, course_id)

    context = {
        'platform_name': settings.PLATFORM_NAME,
    }
    return render_to_response('login.html', context)


def des_auth_login(request):
    context = {
        'platform_name': settings.PLATFORM_NAME,
    }

    return render_to_response('des_auth_login.html', context)


def login_failure_count(request):

    return JsonResponse({'failure_time': failure_time(request)})


# Need different levels of logging
@ensure_csrf_cookie
def login_user(request, error=""):
    """AJAX request to log in the user."""
    if 'email' not in request.POST or 'password' not in request.POST:
        return JsonResponse({
            "success": False,
            "value": _('There was an error receiving your login information. Please email us.'),  # TODO: User error message
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    email = request.POST['email']
    password = request.POST['password']
    # more than three times failure, show captcha
    failure_auth_count = failure_time(request)
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        if settings.FEATURES['SQUELCH_PII_IN_LOGS']:
            AUDIT_LOG.warning(u"Login failed - Unknown user email")
        else:
            AUDIT_LOG.warning(u"Login failed - Unknown user email: {0}".format(email))
        user = None

    # check user role rejetc login when student login cms
    if user is not None:
        studio_name = settings.ROOT_URLCONF.split(".")[0]
        user_profile = UserProfile.objects.get(user=user)
        if studio_name == "cms" and user_profile.profile_role not in ["th",'in']:
            user = None;

    # check if the user has a linked shibboleth account, if so, redirect the user to shib-login
    # This behavior is pretty much like what gmail does for shibboleth.  Try entering some @stanford.edu
    # address into the Gmail login.
    if settings.FEATURES.get('AUTH_USE_SHIB') and user:
        try:
            eamap = ExternalAuthMap.objects.get(user=user)
            if eamap.external_domain.startswith(external_auth.views.SHIBBOLETH_DOMAIN_PREFIX):
                return JsonResponse({
                    "success": False,
                    "redirect": reverse('shib-login'),
                })  # TODO: this should be status code 301  # pylint: disable=fixme
        except ExternalAuthMap.DoesNotExist:
            # This is actually the common case, logging in user without external linked login
            AUDIT_LOG.info("User %s w/o external auth attempting login", user)

    # see if account has been locked out due to excessive login failures
    user_found_by_email_lookup = user
    if user_found_by_email_lookup and LoginFailures.is_feature_enabled():
        if LoginFailures.is_user_locked_out(user_found_by_email_lookup):
            return JsonResponse({
                "success": False,
                "value": _('This account has been temporarily locked due to excessive login failures. Try again later.'),
            })  # TODO: this should be status code 429  # pylint: disable=fixme

    # if the user doesn't exist, we want to set the username to an invalid
    # username so that authentication is guaranteed to fail and we can take
    # advantage of the ratelimited backend
    username = user.username if user else ""

    try:
        user = authenticate(username=username, password=password, request=request)
    # this occurs when there are too many attempts from the same IP address
    except RateLimitException:
        return JsonResponse({
            "success": False,
            "value": _('Too many failed login attempts. Try again later.'),
        })  # TODO: this should be status code 429  # pylint: disable=fixme
    if user is None:
        # tick the failed login counters if the user exists in the database
        if user_found_by_email_lookup and LoginFailures.is_feature_enabled():
            LoginFailures.increment_lockout_counter(user_found_by_email_lookup)

        # if we didn't find this username earlier, the account for this email
        # doesn't exist, and doesn't have a corresponding password
        if username != "":
            if settings.FEATURES['SQUELCH_PII_IN_LOGS']:
                loggable_id = user_found_by_email_lookup.id if user_found_by_email_lookup else "<unknown>"
                AUDIT_LOG.warning(u"Login failed - password for user.id: {0} is invalid".format(loggable_id))
            else:
                AUDIT_LOG.warning(u"Login failed - password for {0} is invalid".format(email))
        return JsonResponse({
            "success": False,
            "value": _('Email or password is incorrect.'),
            "failure_auth_count": failure_auth_count,
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    # successful login, clear failed login attempts counters, if applicable
    if LoginFailures.is_feature_enabled():
        LoginFailures.clear_lockout_counter(user)

    if failure_auth_count > 3: 
        form_captcha = CaptchaLoginForm(request.POST)
        if form_captcha.is_valid():
            human = True
        else:
            return JsonResponse({
                "success": False,
                "value": '验证码错误',
            })

    if user is not None and user.is_active:
        try:
            # We do not log here, because we have a handler registered
            # to perform logging on successful logins.
            login(request, user)
            if request.POST.get('remember') == 'true':
                request.session.set_expiry(604800)
                log.debug("Setting user session to never expire")
            else:
                request.session.set_expiry(0)
        except Exception as e:
            AUDIT_LOG.critical("Login failed - Could not create session. Is memcached running?")
            log.critical("Login failed - Could not create session. Is memcached running?")
            log.exception(e)
            raise

        redirect_url = try_change_enrollment(request)

        dog_stats_api.increment("common.student.successful_login")
        response = JsonResponse({
            "success": True,
            "redirect_url": redirect_url,
        })

        # set the login cookie for the edx marketing site
        # we want this cookie to be accessed via javascript
        # so httponly is set to None

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

        response.set_cookie(
            "logged_username", user.username, max_age=max_age,
            expires=expires, domain=settings.SESSION_COOKIE_DOMAIN,
            path='/', secure=None, httponly=None,
        )
        return response

    if settings.FEATURES['SQUELCH_PII_IN_LOGS']:
        AUDIT_LOG.warning(u"Login failed - Account not active for user.id: {0}, resending activation".format(user.id))
    else:
        AUDIT_LOG.warning(u"Login failed - Account not active for user {0}, resending activation".format(username))

    reactivation_email_for_user(user)
    not_activated_msg = _("This account has not been activated. We have sent another activation message. Please check your e-mail for the activation instructions.")
    return JsonResponse({
        "success": False,
        "value": not_activated_msg,
    })  # TODO: this should be status code 400  # pylint: disable=fixme


@ensure_csrf_cookie
def logout_user(request):
    """
    HTTP request to log out the user. Redirects to marketing page.
    Deletes both the CSRF and sessionid cookies so the marketing
    site can determine the logged in state of the user
    """
    # We do not log here, because we have a handler registered
    # to perform logging on successful logouts.
    logout(request)
    if settings.FEATURES.get('AUTH_USE_CAS'):
        target = reverse('cas-logout')
    else:
        target = '/'
    response = redirect(target)
    response.delete_cookie(
        settings.EDXMKTG_COOKIE_NAME,
        path='/', domain=settings.SESSION_COOKIE_DOMAIN,
    )
    response.delete_cookie(
        'logged_username',
        path='/', domain=settings.SESSION_COOKIE_DOMAIN,
    )
    return response


@require_GET
@login_required
@ensure_csrf_cookie
def manage_user_standing(request):
    """
    Renders the view used to manage user standing. Also displays a table
    of user accounts that have been disabled and who disabled them.
    """
    if not request.user.is_staff:
        raise Http404
    all_disabled_accounts = UserStanding.objects.filter(
        account_status=UserStanding.ACCOUNT_DISABLED
    )

    all_disabled_users = [standing.user for standing in all_disabled_accounts]

    headers = ['username', 'account_changed_by']
    rows = []
    for user in all_disabled_users:
        row = [user.username, user.standing.all()[0].changed_by]
        rows.append(row)

    context = {'headers': headers, 'rows': rows}

    return render_to_response("manage_user_standing.html", context)


@require_POST
@login_required
@ensure_csrf_cookie
def disable_account_ajax(request):
    """
    Ajax call to change user standing. Endpoint of the form
    in manage_user_standing.html
    """
    if not request.user.is_staff:
        raise Http404
    username = request.POST.get('username')
    context = {}
    if username is None or username.strip() == '':
        context['message'] = _('Please enter a username')
        return JsonResponse(context, status=400)

    account_action = request.POST.get('account_action')
    if account_action is None:
        context['message'] = _('Please choose an option')
        return JsonResponse(context, status=400)

    username = username.strip()
    try:
        user = User.objects.get(username=username)
    except User.DoesNotExist:
        context['message'] = _("User with username {} does not exist").format(username)
        return JsonResponse(context, status=400)
    else:
        user_account, _success = UserStanding.objects.get_or_create(
            user=user, defaults={'changed_by': request.user},
        )
        if account_action == 'disable':
            user_account.account_status = UserStanding.ACCOUNT_DISABLED
            context['message'] = _("Successfully disabled {}'s account").format(username)
            log.info("{} disabled {}'s account".format(request.user, username))
        elif account_action == 'reenable':
            user_account.account_status = UserStanding.ACCOUNT_ENABLED
            context['message'] = _("Successfully reenabled {}'s account").format(username)
            log.info("{} reenabled {}'s account".format(request.user, username))
        else:
            context['message'] = _("Unexpected account status")
            return JsonResponse(context, status=400)
        user_account.changed_by = request.user
        user_account.standing_last_changed_at = datetime.datetime.now(UTC)
        user_account.save()

    return JsonResponse(context)


@login_required
@ensure_csrf_cookie
def change_setting(request):
    """JSON call to change a profile setting: Right now, location"""
    # TODO (vshnayder): location is no longer used
    up = UserProfile.objects.get(user=request.user)  # request.user.profile_cache
    if 'location' in request.POST:
        up.location = request.POST['location']
    up.save()

    return JsonResponse({
        "success": True,
        "location": up.location,
    })

def _do_create_account(post_vars):
    """
    Given cleaned post variables, create the User and UserProfile objects, as well as the
    registration for this user.

    Returns a tuple (User, UserProfile, Registration).

    Note: this function is also used for creating test users.
    """
    user = User(username=post_vars['username'],
                email=post_vars['email'],
                is_active=False)
    user.set_password(post_vars['password'])
    registration = Registration()
    # TODO: Rearrange so that if part of the process fails, the whole process fails.
    # Right now, we can have e.g. no registration e-mail sent out and a zombie account
    try:
        user.save()
    except IntegrityError:
        js = {'success': False}
        # Figure out the cause of the integrity error
        if len(User.objects.filter(username=post_vars['username'])) > 0:
            js['value'] = _("An account with the Public Username '{username}' already exists.").format(username=post_vars['username'])
            js['field'] = 'username'
            return JsonResponse(js, status=400)

        if len(User.objects.filter(email=post_vars['email'])) > 0:
            js['value'] = _("An account with the Email '{email}' already exists.").format(email=post_vars['email'])
            js['field'] = 'email'
            return JsonResponse(js, status=400)

        raise

    registration.register(user)

    profile = UserProfile(user=user)
    profile.name = post_vars['name']
    profile.level_of_education = post_vars.get('level_of_education')
    profile.gender = post_vars.get('gender')
    profile.mailing_address = post_vars.get('mailing_address')
    profile.city = post_vars.get('city')
    profile.country = post_vars.get('country')
    profile.goals = post_vars.get('goals')

    try:
        profile.year_of_birth = int(post_vars['year_of_birth'])
    except (ValueError, KeyError):
        # If they give us garbage, just ignore it instead
        # of asking them to put an integer.
        profile.year_of_birth = None
    try:
        profile.save()
    except Exception:
        log.exception("UserProfile creation failed for user {id}.".format(id=user.id))
    return (user, profile, registration)


def _do_teacher_create_account(post_vars):
    user = User(username=post_vars['username'],
                email=post_vars['email'],
                is_active=False)
    user.set_password(post_vars['password'])
    registration = Registration()
    # TODO: Rearrange so that if part of the process fails, the whole process fails.
    # Right now, we can have e.g. no registration e-mail sent out and a zombie account
    try:
        user.save()
    except IntegrityError:
        js = {'success': False}
        # Figure out the cause of the integrity error
        if len(User.objects.filter(username=post_vars['username'])) > 0:
            js['value'] = _("An account with the Public Username '{username}' already exists.").format(username=post_vars['username'])
            js['field'] = 'username'
            return JsonResponse(js, status=400)

        if len(User.objects.filter(email=post_vars['email'])) > 0:
            js['value'] = _("An account with the Email '{email}' already exists.").format(email=post_vars['email'])
            js['field'] = 'email'
            return JsonResponse(js, status=400)

        raise

    registration.register(user)

    profile = UserProfile(user=user)
    profile.name = post_vars['name']
    profile.level_of_education = post_vars.get('level_of_education')
    profile.gender = post_vars.get('gender')
    profile.mailing_address = post_vars.get('mailing_address')
    profile.city = post_vars.get('city')
    profile.country = post_vars.get('country')
    profile.goals = post_vars.get('goals')
    profile.profile_role = 'th'

    try:
        profile.year_of_birth = int(post_vars['year_of_birth'])
    except (ValueError, KeyError):
        # If they give us garbage, just ignore it instead
        # of asking them to put an integer.
        profile.year_of_birth = None
    try:
        profile.save()
    except Exception:
        log.exception("UserProfile creation failed for user {id}.".format(id=user.id))
    return (user, profile, registration)


def _do_institution_create_account(post_vars):

    """
    Given cleaned post variables, create the User and UserProfile objects, as well as the
    registration for this user.

    Returns a tuple (User, UserProfile, Registration).

    Note: this function is also used for creating test users.
    """
    user = User(username=post_vars['username'],
                email=post_vars['email'],
                is_active=False)
    user.set_password(post_vars['password'])
    registration = Registration()
    # TODO: Rearrange so that if part of the process fails, the whole process fails.
    # Right now, we can have e.g. no registration e-mail sent out and a zombie account
    try:
        user.save()
    except IntegrityError:
        js = {'success': False}
        # Figure out the cause of the integrity error
        if len(User.objects.filter(username=post_vars['username'])) > 0:
            js['value'] = _("An account with the Public Username '{username}' already exists.").format(username=post_vars['username'])
            js['field'] = 'username'
            return JsonResponse(js, status=400)

        if len(User.objects.filter(email=post_vars['email'])) > 0:
            js['value'] = _("An account with the Email '{email}' already exists.").format(email=post_vars['email'])
            js['field'] = 'email'
            return JsonResponse(js, status=400)

        raise

    registration.register(user)

    profile = UserProfile(user=user)
    profile.name = post_vars['name']
    profile.level_of_education = post_vars.get('level_of_education')
    profile.gender = post_vars.get('gender')
    profile.mailing_address = post_vars.get('mailing_address')
    profile.city = post_vars.get('city')
    profile.country = post_vars.get('country')
    profile.goals = post_vars.get('goals')
    profile.profile_role = 'in'

    try:
        profile.year_of_birth = int(post_vars['year_of_birth'])
    except (ValueError, KeyError):
        # If they give us garbage, just ignore it instead
        # of asking them to put an integer.
        profile.year_of_birth = None
    try:
        profile.save()
    except Exception:
        log.exception("UserProfile creation failed for user {id}.".format(id=user.id))
    return (user, profile, registration)


@ensure_csrf_cookie
def mobi_create_account(request, post_override=None):
    js = {"success": False}

    post_vars = post_override if post_override else request.POST
    for a in ['username', 'email', 'password', 'name']:
        if a not in post_vars:
            js['value'] = _("Error (401 {field}). E-mail us.").format(field=a)
            js['field'] = a
            return JsonResponse(js, status=400)

    # Can't have terms of service for certain SHIB users, like at Stanford
    tos_required = (
        not settings.FEATURES.get("AUTH_USE_SHIB") or
        not settings.FEATURES.get("SHIB_DISABLE_TOS") or
        not DoExternalAuth or
        not eamap.external_domain.startswith(
            external_auth.views.SHIBBOLETH_DOMAIN_PREFIX
        )
    )

    if tos_required:
        if post_vars.get('terms_of_service', 'false') != u'true':
            js['value'] = _("You must accept the terms of service.").format(field=a)
            js['field'] = 'terms_of_service'
            return JsonResponse(js, status=400)

    try:
        validate_email(post_vars['email'])
    except ValidationError:
        js['value'] = _("Valid e-mail is required.").format(field=a)
        js['field'] = 'email'
        return JsonResponse(js, status=400)

    try:
        validate_slug(post_vars['username'])
    except ValidationError:
        js['value'] = _("Username should only consist of A-Z and 0-9, with no spaces.").format(field=a)
        js['field'] = 'username'
        return JsonResponse(js, status=400)

    # enforce password complexity as an optional feature
    if settings.FEATURES.get('ENFORCE_PASSWORD_POLICY', False):
        try:
            password = post_vars['password']

            validate_password_length(password)
            validate_password_complexity(password)
            validate_password_dictionary(password)
        except ValidationError, err:
            js['value'] = _('Password: ') + '; '.join(err.messages)
            js['field'] = 'password'
            return JsonResponse(js, status=400)

    # Ok, looks like everything is legit.  Create the account.
    ret = _do_create_account(post_vars)
    if isinstance(ret, HttpResponse):  # if there was an error then return that
        return ret
    (user, profile, registration) = ret

    context = {
        'name': post_vars['name'],
        'key': registration.activation_key,
        'username': user.username,
    }

    # composes activation email
    subject = render_to_string('emails/activation_email_subject.txt', context)
    # Email subject *must not* contain newlines
    subject = ''.join(subject.splitlines())
    message = render_to_string('emails/activation_email.txt', context)

    response = JsonResponse({
        'success': True,
        'redirect_url': reverse('wechat.views.mobi_register_success', args=[user.id]),
    })

    return response


@ensure_csrf_cookie
def create_account(request, post_override=None):
    """
    JSON call to create new edX account.
    Used by form in signup_modal.html, which is included into navigation.html
    """
    js = {'success': False}

    request_type = request.GET.get("created_role", "")
    if request_type == 'mobi':
        return mobi_create_account(request)

    post_vars = post_override if post_override else request.POST
    extra_fields = getattr(settings, 'REGISTRATION_EXTRA_FIELDS', {})

    # if doing signup for an external authorization, then get email, password, name from the eamap
    # don't use the ones from the form, since the user could have hacked those
    # unless originally we didn't get a valid email or name from the external auth
    DoExternalAuth = 'ExternalAuthMap' in request.session
    if DoExternalAuth:
        eamap = request.session['ExternalAuthMap']
        try:
            validate_email(eamap.external_email)
            email = eamap.external_email
        except ValidationError:
            email = post_vars.get('email', '')
        if eamap.external_name.strip() == '':
            name = post_vars.get('name', '')
        else:
            name = eamap.external_name
        password = eamap.internal_password
        post_vars = dict(post_vars.items())
        post_vars.update(dict(email=email, name=name, password=password))
        log.debug(u'In create_account with external_auth: user = %s, email=%s', name, email)

    # Confirm we have a properly formed request
    for a in ['username', 'email', 'password', 'name']:
        if a not in post_vars:
            js['value'] = _("Error (401 {field}). E-mail us.").format(field=a)
            js['field'] = a
            return JsonResponse(js, status=400)

    if extra_fields.get('honor_code', 'required') == 'required' and \
            post_vars.get('honor_code', 'false') != u'true':
        js['value'] = _("To enroll, you must follow the honor code.").format(field=a)
        js['field'] = 'honor_code'
        return JsonResponse(js, status=400)

    if post_vars.get('terms_of_service', 'false') != u'true':
        js['value'] = _("You must accept the terms of service.").format(field=a)
        js['field'] = 'terms_of_service'
        return JsonResponse(js, status=400)

    # Confirm appropriate fields are there.
    # TODO: Check e-mail format is correct.
    # TODO: Confirm e-mail is not from a generic domain (mailinator, etc.)? Not sure if
    # this is a good idea
    # TODO: Check password is sane

    required_post_vars = ['username', 'email', 'name', 'password']
    required_post_vars += [fieldname for fieldname, val in extra_fields.items()
                           if val == 'required']

    tos_required = (
        not settings.FEATURES.get("AUTH_USE_SHIB") or
        not settings.FEATURES.get("SHIB_DISABLE_TOS") or
        not DoExternalAuth or
        not eamap.external_domain.startswith(
            external_auth.views.SHIBBOLETH_DOMAIN_PREFIX
        )
    )

    if tos_required:
        required_post_vars.append('terms_of_service')

    for field_name in required_post_vars:
        if field_name in ('gender', 'level_of_education'):
            min_length = 1
        else:
            min_length = 2

        if len(post_vars[field_name]) < min_length:
            error_str = {
                'username': _('Username must be minimum of two characters long'),
                'email': _('A properly formatted e-mail is required'),
                'name': "您的姓名名称至少要两个字符",
                'password': _('A valid password is required'),
                'terms_of_service': _('Accepting Terms of Service is required'),
                'honor_code': _('Agreeing to the Honor Code is required'),
                'level_of_education': _('A level of education is required'),
                'gender': _('Your gender is required'),
                'year_of_birth': _('Your year of birth is required'),
                'mailing_address': _('Your mailing address is required'),
                'goals': _('A description of your goals is required'),
                'city': _('A city is required'),
                'country': _('A country is required')
            }
            js['value'] = error_str[field_name]
            js['field'] = field_name
            return JsonResponse(js, status=400)

        max_length = 75
        if field_name == 'username':
            max_length = 30

        if field_name in ('email', 'username') and len(post_vars[field_name]) > max_length:
            error_str = {
                'username': _('Username cannot be more than {0} characters long').format(max_length),
                'email': _('Email cannot be more than {0} characters long').format(max_length)
            }
            js['value'] = error_str[field_name]
            js['field'] = field_name
            return JsonResponse(js, status=400)

    try:
        validate_email(post_vars['email'])
    except ValidationError:
        js['value'] = _("Valid e-mail is required.").format(field=a)
        js['field'] = 'email'
        return JsonResponse(js, status=400)

    try:
        validate_slug(post_vars['username'])
    except ValidationError:
        js['value'] = _("Username should only consist of A-Z and 0-9, with no spaces.").format(field=a)
        js['field'] = 'username'
        return JsonResponse(js, status=400)

    # enforce password complexity as an optional feature
    if settings.FEATURES.get('ENFORCE_PASSWORD_POLICY', False):
        try:
            password = post_vars['password']

            validate_password_length(password)
            validate_password_complexity(password)
            validate_password_dictionary(password)
        except ValidationError, err:
            js['value'] = _('Password: ') + '; '.join(err.messages)
            js['field'] = 'password'
            return JsonResponse(js, status=400)

    # Ok, looks like everything is legit.  Create the account.
    if request_type == 'ins':
        ret = _do_institution_create_account(post_vars)
    elif request_type == 'th':
        ret = _do_teacher_create_account(post_vars)
    else:
        ret = _do_create_account(post_vars)
    if isinstance(ret, HttpResponse):  # if there was an error then return that
        return ret
    (user, profile, registration) = ret

    context = {
        'name': post_vars['name'],
        'key': registration.activation_key,
        'username': user.username,
    }

    # composes activation email
    subject = render_to_string('emails/activation_email_subject.txt', context)
    # Email subject *must not* contain newlines
    subject = ''.join(subject.splitlines())


    message = render_to_string('emails/activation_email.txt', context)
    print  message.encode('utf-8')
    # don't send email if we are doing load testing or random user generation for some reason
    if not (settings.FEATURES.get('AUTOMATIC_AUTH_FOR_TESTING')):
        from_address = microsite.get_value(
            'email_from_address',
            settings.DEFAULT_FROM_EMAIL
        )
        try:
            if settings.FEATURES.get('REROUTE_ACTIVATION_EMAIL'):
                dest_addr = settings.FEATURES['REROUTE_ACTIVATION_EMAIL']
                message = ("Activation for %s (%s): %s\n" % (user, user.email, profile.name) +
                           '-' * 80 + '\n\n' + message)
                send_mails(subject, "", from_address, [user.email], fail_silently=False, html=message)
            else:
                #user.email_user(subject, message, from_address)
                send_mails(subject, "", from_address, [user.email], fail_silently=False, html=message)
        except Exception:  # pylint: disable=broad-except
            log.warning('Unable to send activation email to user', exc_info=True)
            js['value'] = _('Could not send activation e-mail.')
            # What is the correct status code to use here? I think it's 500, because
            # the problem is on the server's end -- but also, the account was created.
            # Seems like the core part of the request was successful.
            return JsonResponse(js, status=500)

    # Immediately after a user creates an account, we log them in. They are only
    # logged in until they close the browser. They can't log in again until they click
    # the activation link from the email.
#    login_user = authenticate(username=post_vars['username'], password=post_vars['password'])
#    login(request, login_user)
#    request.session.set_expiry(0)
#
#    # TODO: there is no error checking here to see that the user actually logged in successfully,
#    # and is not yet an active user.
#    if login_user is not None:
#        AUDIT_LOG.info(u"Login success on new account creation - {0}".format(login_user.username))
#
#    if DoExternalAuth:
#        eamap.user = login_user
#        eamap.dtsignup = datetime.datetime.now(UTC)
#        eamap.save()
#        AUDIT_LOG.info("User registered with external_auth %s", post_vars['username'])
#        AUDIT_LOG.info('Updated ExternalAuthMap for %s to be %s', post_vars['username'], eamap)
#
#        if settings.FEATURES.get('BYPASS_ACTIVATION_EMAIL_FOR_EXTAUTH'):
#            log.info('bypassing activation email')
#            login_user.is_active = True
#            login_user.save()
#            AUDIT_LOG.info(u"Login activated on extauth account - {0} ({1})".format(login_user.username, login_user.email))
#
    dog_stats_api.increment("common.student.account_created")

#    logout(request)

    response = JsonResponse({
        'success': True,
        'redirect_url': '/login?flag=1',
#        'redirect_url': try_change_enrollment(request),
    })

    # set the login cookie for the edx marketing site
    # we want this cookie to be accessed via javascript
    # so httponly is set to None

    if request.session.get_expire_at_browser_close():
        max_age = None
        expires = None
    else:
        max_age = request.session.get_expiry_age()
        expires_time = time.time() + max_age
        expires = cookie_date(expires_time)

    response.set_cookie(settings.EDXMKTG_COOKIE_NAME,
                        'true', max_age=max_age,
                        expires=expires, domain=settings.SESSION_COOKIE_DOMAIN,
                        path='/',
                        secure=None,
                        httponly=None)
    return response


def auto_auth(request):
    """
    Create or configure a user account, then log in as that user.

    Enabled only when
    settings.FEATURES['AUTOMATIC_AUTH_FOR_TESTING'] is true.

    Accepts the following querystring parameters:
    * `username`, `email`, and `password` for the user account
    * `full_name` for the user profile (the user's full name; defaults to the username)
    * `staff`: Set to "true" to make the user global staff.
    * `course_id`: Enroll the student in the course with `course_id`
    * `roles`: Comma-separated list of roles to grant the student in the course with `course_id`

    If username, email, or password are not provided, use
    randomly generated credentials.
    """

    # Generate a unique name to use if none provided
    unique_name = uuid.uuid4().hex[0:30]

    # Use the params from the request, otherwise use these defaults
    username = request.GET.get('username', unique_name)
    password = request.GET.get('password', unique_name)
    email = request.GET.get('email', unique_name + "@example.com")
    full_name = request.GET.get('full_name', username)
    is_staff = request.GET.get('staff', None)
    course_id = request.GET.get('course_id', None)
    role_names = [v.strip() for v in request.GET.get('roles', '').split(',') if v.strip()]

    # Get or create the user object
    post_data = {
        'username': username,
        'email': email,
        'password': password,
        'name': full_name,
        'honor_code': u'true',
        'terms_of_service': u'true',
    }

    # Attempt to create the account.
    # If successful, this will return a tuple containing
    # the new user object; otherwise it will return an error
    # message.
    result = _do_create_account(post_data)

    if isinstance(result, tuple):
        user = result[0]

    # If we did not create a new account, the user might already
    # exist.  Attempt to retrieve it.
    else:
        user = User.objects.get(username=username)
        user.email = email
        user.set_password(password)
        user.save()

    # Set the user's global staff bit
    if is_staff is not None:
        user.is_staff = (is_staff == "true")
        user.save()

    # Activate the user
    reg = Registration.objects.get(user=user)
    reg.activate()
    reg.save()

    # Enroll the user in a course
    if course_id is not None:
        CourseEnrollment.enroll(user, course_id)

    # Apply the roles
    for role_name in role_names:
        role = Role.objects.get(name=role_name, course_id=course_id)
        user.roles.add(role)

    # Log in as the user
    user = authenticate(username=username, password=password)
    login(request, user)

    # Provide the user with a valid CSRF token
    # then return a 200 response
    success_msg = u"Logged in user {0} ({1}) with password {2} and user_id {3}".format(
        username, email, password, user.id
    )
    response = HttpResponse(success_msg)
    response.set_cookie('csrftoken', csrf(request)['csrf_token'])
    return response


@ensure_csrf_cookie
def activate_account(request, key):
    """When link in activation e-mail is clicked"""
    r = Registration.objects.filter(activation_key=key)
    if len(r) == 1:
        user_logged_in = request.user.is_authenticated()
        already_active = True
        if not r[0].user.is_active:
            r[0].activate()
            already_active = False

        # Enroll student in any pending courses he/she may have if auto_enroll flag is set
        student = User.objects.filter(id=r[0].user_id)
        if student:
            ceas = CourseEnrollmentAllowed.objects.filter(email=student[0].email)
            for cea in ceas:
                if cea.auto_enroll:
                    CourseEnrollment.enroll(student[0], cea.course_id)

        resp = render_to_response(
            "registration/activation_complete.html",
            {
                'user_logged_in': user_logged_in,
                'already_active': already_active
            }
        )
        return resp
    if len(r) == 0:
        return render_to_response(
            "registration/activation_invalid.html",
            {'csrf': csrf(request)['csrf_token']}
        )
    return HttpResponse(_("Unknown error. Please e-mail us to let us know how it happened."))


@ensure_csrf_cookie
def password_reset(request):
    """ Attempts to send a password reset e-mail. """
    if request.method != "POST":
        raise Http404

    # Add some rate limiting here by re-using the RateLimitMixin as a helper class
    limiter = BadRequestRateLimiter()
    if limiter.is_rate_limit_exceeded(request):
        AUDIT_LOG.warning("Rate limit exceeded in password_reset")
        return HttpResponseForbidden()

    form = PasswordResetFormNoActive(request.POST)
    if form.is_valid():
        form.save(use_https=request.is_secure(),
                  from_email=settings.DEFAULT_FROM_EMAIL,
                  request=request,
                  domain_override=request.get_host())
    else:
        # bad user? tick the rate limiter counter
        AUDIT_LOG.info("Bad password_reset user passed in.")
        limiter.tick_bad_request_counter(request)

    if not  request.POST.get('email') :
        print '11111111111111111111'
        return JsonResponse({
            'Failure': False,
            'value': render_to_string('registration/password_reset_done.html', {}),
            })

    try:
        validate_email(request.POST.get('email'))
    except :
        return JsonResponse({
            'Failure': False,
            'value': render_to_string('registration/password_reset_done.html', {}),
            })

    return JsonResponse({
        'success': True,
        'value': render_to_string('registration/password_reset_done.html', {}),
    })


def password_reset_confirm_wrapper(
    request,
    uidb36=None,
    token=None,
):
    """ A wrapper around django.contrib.auth.views.password_reset_confirm.
        Needed because we want to set the user as active at this step.
    """
    # cribbed from django.contrib.auth.views.password_reset_confirm
    try:
        uid_int = base36_to_int(uidb36)
        user = User.objects.get(id=uid_int)
        user.is_active = True
        user.save()
    except (ValueError, User.DoesNotExist):
        pass
    # we also want to pass settings.PLATFORM_NAME in as extra_context

    extra_context = {"platform_name": settings.PLATFORM_NAME}
    return password_reset_confirm(
        request, uidb36=uidb36, token=token, extra_context=extra_context
    )


def reactivation_email_for_user(user):
    try:
        reg = Registration.objects.get(user=user)
    except Registration.DoesNotExist:
        return JsonResponse({
            "success": False,
            "error": _('No inactive user with this e-mail exists'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    context = {
        'name': user.profile.name,
        'key': reg.activation_key,
        'username': user.username,
    }

    subject = render_to_string('emails/activation_email_subject.txt', context)
    subject = ''.join(subject.splitlines())
    message = render_to_string('emails/activation_email.txt', context)

    try:
        send_mails(subject, "", settings.DEFAULT_FROM_EMAIL, [user.email], fail_silently=False, html=message)
#        user.email_user(subject, message, settings.DEFAULT_FROM_EMAIL)
    except Exception:  # pylint: disable=broad-except
        log.warning('Unable to send reactivation email', exc_info=True)
        return JsonResponse({
            "success": False,
            "error": _('Unable to send reactivation email')
        })  # TODO: this should be status code 500  # pylint: disable=fixme

    return JsonResponse({"success": True})


@ensure_csrf_cookie
def change_email_request(request):
    """ AJAX call from the profile page. User wants a new e-mail.
    """
    ## Make sure it checks for existing e-mail conflicts
    if not request.user.is_authenticated:
        raise Http404

    user = request.user

    if not user.check_password(request.POST['password']):
        return JsonResponse({
            "success": False,
            "error": _('Invalid password'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    new_email = request.POST['new_email']
    try:
        validate_email(new_email)
    except ValidationError:
        return JsonResponse({
            "success": False,
            "error": _('Valid e-mail address required.'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    if User.objects.filter(email=new_email).count() != 0:
        ## CRITICAL TODO: Handle case sensitivity for e-mails
        return JsonResponse({
            "success": False,
            "error": _('An account with this e-mail already exists.'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    pec_list = PendingEmailChange.objects.filter(user=request.user)
    if len(pec_list) == 0:
        pec = PendingEmailChange()
        pec.user = user
    else:
        pec = pec_list[0]

    pec.new_email = request.POST['new_email']
    pec.activation_key = uuid.uuid4().hex
    pec.save()

    if pec.new_email == user.email:
        pec.delete()
        return JsonResponse({
            "success": False,
            "error": _('Old email is the same as the new email.'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    context = {
        'key': pec.activation_key,
        'old_email': user.email,
        'new_email': pec.new_email
    }

    subject = render_to_string('emails/email_change_subject.txt', context)
    subject = ''.join(subject.splitlines())

    message = render_to_string('emails/email_change.txt', context)

    from_address = microsite.get_value(
        'email_from_address',
        settings.DEFAULT_FROM_EMAIL
    )

    send_mail(subject, message, from_address, [pec.new_email])

    return JsonResponse({"success": True})


@ensure_csrf_cookie
@transaction.commit_manually
def confirm_email_change(request, key):
    """ User requested a new e-mail. This is called when the activation
    link is clicked. We confirm with the old e-mail, and update
    """
    try:
        try:
            pec = PendingEmailChange.objects.get(activation_key=key)
        except PendingEmailChange.DoesNotExist:
            response = render_to_response("invalid_email_key.html", {})
            transaction.rollback()
            return response

        user = pec.user
        address_context = {
            'old_email': user.email,
            'new_email': pec.new_email
        }

        if len(User.objects.filter(email=pec.new_email)) != 0:
            response = render_to_response("email_exists.html", {})
            transaction.rollback()
            return response

        subject = render_to_string('emails/email_change_subject.txt', address_context)
        subject = ''.join(subject.splitlines())
        message = render_to_string('emails/confirm_email_change.txt', address_context)
        up = UserProfile.objects.get(user=user)
        meta = up.get_meta()
        if 'old_emails' not in meta:
            meta['old_emails'] = []
        meta['old_emails'].append([user.email, datetime.datetime.now(UTC).isoformat()])
        up.set_meta(meta)
        up.save()
        # Send it to the old email...
        try:
            user.email_user(subject, message, settings.DEFAULT_FROM_EMAIL)
        except Exception:
            log.warning('Unable to send confirmation email to old address', exc_info=True)
            response = render_to_response("email_change_failed.html", {'email': user.email})
            transaction.rollback()
            return response

        user.email = pec.new_email
        user.save()
        pec.delete()
        # And send it to the new email...
        try:
            user.email_user(subject, message, settings.DEFAULT_FROM_EMAIL)
        except Exception:
            log.warning('Unable to send confirmation email to new address', exc_info=True)
            response = render_to_response("email_change_failed.html", {'email': pec.new_email})
            transaction.rollback()
            return response

        response = render_to_response("email_change_successful.html", address_context)
        transaction.commit()
        return response
    except Exception:
        # If we get an unexpected exception, be sure to rollback the transaction
        transaction.rollback()
        raise




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


def accept_shortbio_change_by_id(id):
    try:
        pnc = PendingNameChange.objects.get(id=id)
    except PendingNameChange.DoesNotExist:
        return JsonResponse({
            "success": False,
            "error": _('Invalid ID'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    u = pnc.user
    up = UserProfile.objects.get(user=u)

    # Save old name
    meta = up.get_meta()
    if 'old_shortbios' not in meta:
        meta['old_shortbios'] = []
    meta['old_shortbios'].append([up.shortbio, pnc.rationale, datetime.datetime.now(UTC).isoformat()])
    up.set_meta(meta)

    up.shortbio = pnc.rationale
    up.save()
    pnc.delete()

    return JsonResponse({"success": True})




@ensure_csrf_cookie
def change_picurl_request(request):
    """ Log a request for a new name. """
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
            "error": _('Name required'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme
    pnc.save()

    # The following automatically accepts name change requests. Remove this to
    # go back to the old system where it gets queued up for admin approval.
    accept_picurl_change_by_id(pnc.id)

    return JsonResponse({"success": True})


def accept_picurl_change_by_id(id):
    try:
        pnc = PendingNameChange.objects.get(id=id)
    except PendingNameChange.DoesNotExist:
        return JsonResponse({
            "success": False,
            "error": _('Invalid ID'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    u = pnc.user
    up = UserProfile.objects.get(user=u)

    # Save old name
    # meta = up.get_meta()
    # if 'old_picurls' not in meta:
    #     meta['old_names'] = []
    # meta['old_names'].append([up.picurl, pnc.rationale, datetime.datetime.now(UTC).isoformat()])
    # up.set_meta(meta)

    up.picurl = pnc.new_name
    up.save()
    pnc.delete()

    return JsonResponse({"success": True})



@ensure_csrf_cookie
def change_name_request(request):
    """ Log a request for a new name. """
    if not request.user.is_authenticated:
        raise Http404

    try:
        pnc = PendingNameChange.objects.get(user=request.user)
    except PendingNameChange.DoesNotExist:
        pnc = PendingNameChange()
    pnc.user = request.user
    pnc.new_name = request.POST['new_name']
    pnc.rationale = request.POST['rationale']
    if len(pnc.new_name) < 2:
        return JsonResponse({
            "success": False,
            "error": _('Name required'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme
    pnc.save()

    # The following automatically accepts name change requests. Remove this to
    # go back to the old system where it gets queued up for admin approval.
    accept_name_change_by_id(pnc.id)

    return JsonResponse({"success": True})


@ensure_csrf_cookie
def pending_name_changes(request):
    """ Web page which allows staff to approve or reject name changes. """
    if not request.user.is_staff:
        raise Http404

    students = []
    for change in PendingNameChange.objects.all():
        profile = UserProfile.objects.get(user=change.user)
        students.append({
            "new_name": change.new_name,
            "rationale": change.rationale,
            "old_name": profile.name,
            "email": change.user.email,
            "uid": change.user.id,
            "cid": change.id,
        })

    return render_to_response("name_changes.html", {"students": students})


@ensure_csrf_cookie
def reject_name_change(request):
    """ JSON: Name change process. Course staff clicks 'reject' on a given name change """
    if not request.user.is_staff:
        raise Http404

    try:
        pnc = PendingNameChange.objects.get(id=int(request.POST['id']))
    except PendingNameChange.DoesNotExist:
        return JsonResponse({
            "success": False,
            "error": _('Invalid ID'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    pnc.delete()
    return JsonResponse({"success": True})


def accept_name_change_by_id(id):
    try:
        pnc = PendingNameChange.objects.get(id=id)
    except PendingNameChange.DoesNotExist:
        return JsonResponse({
            "success": False,
            "error": _('Invalid ID'),
        })  # TODO: this should be status code 400  # pylint: disable=fixme

    u = pnc.user
    up = UserProfile.objects.get(user=u)

    # Save old name
    meta = up.get_meta()
    if 'old_names' not in meta:
        meta['old_names'] = []
    meta['old_names'].append([up.name, pnc.rationale, datetime.datetime.now(UTC).isoformat()])
    up.set_meta(meta)

    up.name = pnc.new_name
    up.save()
    pnc.delete()

    return JsonResponse({"success": True})


@ensure_csrf_cookie
def accept_name_change(request):
    """ JSON: Name change process. Course staff clicks 'accept' on a given name change

    We used this during the prototype but now we simply record name changes instead
    of manually approving them. Still keeping this around in case we want to go
    back to this approval method.
    """
    if not request.user.is_staff:
        raise Http404

    return accept_name_change_by_id(int(request.POST['id']))


@require_POST
@login_required
@ensure_csrf_cookie
def change_email_settings(request):
    """Modify logged-in user's setting for receiving emails from a course."""
    user = request.user

    course_id = request.POST.get("course_id")
    receive_emails = request.POST.get("receive_emails")
    if receive_emails:
        optout_object = Optout.objects.filter(user=user, course_id=course_id)
        if optout_object:
            optout_object.delete()
        log.info(u"User {0} ({1}) opted in to receive emails from course {2}".format(user.username, user.email, course_id))
        track.views.server_track(request, "change-email-settings", {"receive_emails": "yes", "course": course_id}, page='dashboard')
    else:
        Optout.objects.get_or_create(user=user, course_id=course_id)
        log.info(u"User {0} ({1}) opted out of receiving emails from course {2}".format(user.username, user.email, course_id))
        track.views.server_track(request, "change-email-settings", {"receive_emails": "no", "course": course_id}, page='dashboard')

    return JsonResponse({"success": True})


@csrf_exempt
def bs_sync_accounts(request):
    init_keys = ['name', 'passwd', 'email', 'gender', 'originPlace', 'address', 'education', 'birthday', 'profile_role']
    succ_add_ids = []
    try:
        sync_user_params = eval(request.body)['staff']
    except:
        sync_user_params = request.POST['staff']

    def filter_and_init_keys(user_json):
        filter_keys_json = {key: user_json[key] for key in user_json if key in init_keys}
        ret_json = {}
        for key, val in filter_keys_json.items():
            if key == 'name':
                ret_json['username'] = val.decode('utf-8').encode('utf-8')

            if key == 'passwd':
                ret_json['password'] = val

            if key == 'email' or key == 'gender':
                ret_json[key] = val

            if key in ('originPlace', 'address') and not ret_json.get('mailing_address'):
                ret_json['mailing_address'] = filter_keys_json.get(key).decode('utf-8').encode('utf-8')

            if key == 'education':
                ret_json['level_of_education'] = val

            if key == 'birthday':
                ret_json['year_of_birth'] = val

            if key == 'profile_role':
                ret_json['profile_role'] = val

        return ret_json

    def create_actived_user(user_params):
        user = User(username=user_params['username'],
                    email=user_params['email'],
                    is_active=True)
        # user.is_staff = True
        user.set_password(user_params['password'])

        try:
            user.save()
        except IntegrityError:
            raise

        profile = UserProfile(user=user)
        profile.name = user_params['username']
        profile.level_of_education = user_params.get('level_of_education')
        profile.gender = user_params.get('gender')
        profile.mailing_address = user_params.get('mailing_address')

        profile_role = user_params.get("profile_role")

        if profile_role and profile_role in ["th", "st"]:
            profile.profile_role = profile_role

        try:
            profile.year_of_birth = int(user_params['year_of_birth'])
        except:
            profile.year_of_birth = None

        try:
            profile.save()
        except Exception:
            raise

        return user

    email_re = re.compile(r'^[\w\d]+[\d\w\_\.]+@([\w\d-]+)\.([\d\w]+)(?:\.[\d\w]+)?$')
    for idx, staff in enumerate(sync_user_params):
        init_hash = {"index": idx, "success": False,}
        if all(k in staff for k in ('name', 'passwd', 'email')):
            # create a activated user account

            params = filter_and_init_keys(staff)
            try:
                # validate_email(params['email'])
                # validate_slug(params['username'])
                email_re.match(params['email']).group()
            except:
                init_hash.update({"errmsg": "该邮箱格式不正确！"})
                succ_add_ids.append(init_hash)
                continue

            # create a user
            try:
                created_user = create_actived_user(params)
                init_hash.update({'success': True, "userid": created_user.id})
                succ_add_ids.append(init_hash)
            except:
                init_hash.update({"errmsg": "用户名或邮箱已存在！"})
                succ_add_ids.append(init_hash)
                continue
        else:
            init_hash.update({"errmsg": "给定的参数不全！必须存在'name'、'passwd'、'email'字段"})
            succ_add_ids.append(init_hash)

    return JsonResponse({"staff": succ_add_ids})


@csrf_exempt
def bs_change_profle_role(request, user_id=None, profile_role=None):
    uniform_re = {"success": False}
    request_method = request.method

    if request_method != "POST":
        uniform_re['errmsg'] = "Only POST request support!"
        return JsonResponse(uniform_re)

    try:
        user = User.objects.get(id=int(user_id))
        user_profile = UserProfile.objects.get(user=user)

        user_profile.profile_role = profile_role
        user_profile.save()

        uniform_re['success'] = True
        return JsonResponse(uniform_re)
    except:
        uniform_re['errmsg'] = "some error occurs when change user with id " + str(user_id) +" to role" + profile_role 

        return JsonResponse(uniform_re)


@csrf_exempt
def bs_ban_account(request, user_id):
    uniform_re = {"success": False}
    request_method = request.method
    if request_method != 'POST':
        uniform_re['errmsg'] = 'Only POST request support!'

    try:
        active_status = eval(request.body).get('is_active').lower()
    except:
        active_status = request.POST.get('is_active').lower()

    if active_status is None:
        uniform_re['errmsg'] = 'params error!'
        return JsonResponse(uniform_re)

    oper_active_user = User.objects.get(id=int(user_id))

    if oper_active_user is None:
        uniform_re['errmsg'] = 'can not find the user with id ' + user_id
        return JsonResponse(uniform_re)

    if active_status == 'yes':
        active_status = True
    elif active_status == 'no':
        active_status = False
    else:
        uniform_re['errmsg'] = 'can not realize operation!'
        return JsonResponse(uniform_re)

    if active_status == oper_active_user.is_active:
        uniform_re['errmsg'] = 'user has activated!' if oper_active_user.is_active else "user has been disabled!"
        return JsonResponse(uniform_re)

    oper_active_user.is_active = active_status

    try:
        oper_active_user.save()
    except:
        uniform_re['errmsg'] = 'Operation failed'
        return JsonResponse({'success': False, 'errmsg': 'Operation failed'})

    uniform_re['success'] = True
    return JsonResponse(uniform_re)


@cache_control(no_cache=True, no_store=True, must_revalidate=True)
def bs_recv_grade(request, student_id, ptype='all'):
    """
    Show user's grade_book with student_id 
    """
    re_format = {"success": False} 

    try:
        user = User.objects.get(id=int(student_id))
    except:
        re_format.update({"errmsg": "Can not find user with id {}".format(student_id)})
        return JsonResponse(re_format)

    # for microsites, we want to filter and only show enrollments for courses within
    # the microsites 'ORG'
    course_org_filter = microsite.get_value('course_org_filter')

    # Let's filter out any courses in an "org" that has been declared to be
    # in a Microsite
    org_filter_out_set = microsite.get_all_orgs()

    # remove our current Microsite from the "filter out" list, if applicable
    if course_org_filter:
        org_filter_out_set.remove(course_org_filter)

    enrollment_courses_list = map(lambda x: x[0], list(get_course_enrollment_pairs(user, course_org_filter, org_filter_out_set)))

    def student_course_format_dict(course):
        pass_line = sorted(course.grade_cutoffs.items(), key=lambda i: i[1], reverse=True)[0][1]
        pass_or_not = lambda x: x >= pass_line
        
        return {
            "course_id": course.id.replace('/', '.'),
            "pass_line": "{0:.0f}".format( 100 * pass_line ),
            "is_pass": pass_or_not(student_grades(user, request, course))
        }

    def selcon(passor):
        r = True
        if ptype == 'pass':
            r = passor['is_pass']
        elif ptype == 'fail':
            r = not passor['is_pass']

        return r


    courses_grade_book = []
    for course, enrollment in list(get_course_enrollment_pairs(user, course_org_filter, org_filter_out_set)):
        rcourse = student_course_format_dict(course)
        if selcon(rcourse):
            courses_grade_book.append(rcourse) 

    re_format.update({"user_id": user.id, "grade_book": courses_grade_book, "success": True})

    return JsonResponse(re_format)


@login_required
def token(request):
    '''
    Return a token for the backend of annotations.
    It uses the course id to retrieve a variable that contains the secret
    token found in inheritance.py. It also contains information of when
    the token was issued. This will be stored with the user along with
    the id for identification purposes in the backend.
    '''
    course_id = request.GET.get("course_id")
    course = course_from_id(course_id)
    dtnow = datetime.datetime.now()
    dtutcnow = datetime.datetime.utcnow()
    delta = dtnow - dtutcnow
    newhour, newmin = divmod((delta.days * 24 * 60 * 60 + delta.seconds + 30) // 60, 60)
    newtime = "%s%+02d:%02d" % (dtnow.isoformat(), newhour, newmin)
    secret = course.annotation_token_secret
    custom_data = {"issuedAt": newtime, "consumerKey": secret, "userId": request.user.email, "ttl": 86400}
    newtoken = create_token(secret, custom_data)
    response = HttpResponse(newtoken, mimetype="text/plain")
    return response


@csrf_exempt
def mobi_token_handler(request, action=None):
    if "application/json" not in request.META.get('HTTP_ACCEPT', 'application/json'):
        return HttpResponseBadRequest('Only supports json requests')

    if request.method != 'POST':
        return JsonResponse({'success': False, 'errmsg': "Only support POST request"})

    if not action:
        return mobi_token(request)
    elif action == "login":
        return mobi_token_login(request)
    elif action == "logout":
        return mobi_token_logout(request)
    else:
        return HttpResponseForbidden()


def mobi_token(request):
    # record request data
    # {
    #     "appkey": "appkey001",
    #     "imei": "3487314302810384",
    #     "os": "adnroid",
    #     "osversion": "5.0",
    #     "appversion": "1.0.0",
    #     "sourceid": "Google play",
    #     "ver": '1.0'
    # }
    return JsonResponse({"success": True})


def mobi_token_login(request):
    if "email" not in request.POST or "password" not in request.POST:
        return JsonResponse({
            "success": False,
            "value": "email or password missing!"
        })

    email, password = [request.POST['email'], request.POST['password']]

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        AUDIT_LOG.warning(u"Login failed - Unknown user email: {0}".format(email))
        user = None

    # check if the user has a linked shibboleth account, if so, redirect the user to shib-login
    # This behavior is pretty much like what gmail does for shibboleth.  Try entering some @stanford.edu
    # address into the Gmail login.
    if settings.FEATURES.get('AUTH_USE_SHIB') and user:
        try:
            eamap = ExternalAuthMap.objects.get(user=user)
            if eamap.external_domain.startswith(external_auth.views.SHIBBOLETH_DOMAIN_PREFIX):
                return JsonResponse({
                    "success": False,
                    "redirect": reverse('shib-login'),
                })
        except ExternalAuthMap.DoesNotExist:
            # This is actually the common case, logging in user without external linked login
            AUDIT_LOG.info("User %s w/o external auth attempting login", user)

    user_found_by_email_lookup = user

    if user_found_by_email_lookup and LoginFailures.is_feature_enabled():
        if LoginFailures.is_user_locked_out(user_found_by_email_lookup):
            return JsonResponse({
                "success": False,
                "value": "This account has been temporarily locked due to excessive login failures. Try again later."\
            })

    username = user.username if user else ""

    try:
        user = authenticate(username=username, password=password, request=request)
    except RateLimitException:
        return JsonResponse({
            "success": False,
            "value": "Too many failed login attempts. Try again later."
        })

    if user is None:
        if user_found_by_email_lookup and LoginFailures.is_feature_enabled():
            LoginFailures.increment_lockout_counter(user_found_by_email_lookup)

        if username != "":
             AUDIT_LOG.warning(u"Login failed - password for {0} is invalid".format(email))

        return JsonResponse({
            "success": False,
            "value": "Email or password is incorrect.",
        })

    if LoginFailures.is_feature_enabled():
        LoginFailures.clear_lockout_counter(user)

    if user is not None and user.is_active:
        try:
            login(request, user)
            # get token and expires for return
            expires = 60*60*24*365
            request.session.set_expiry(expires)
            # if request.POST.get('remember') == 'true':
            #     request.session.set_expiry(604800)
            #     expires = 0
            #     log.debug("Setting user session to never expire")
            # else:
            #     request.session.set_expiry(0)
            #     expires = 60*60*24
        except Exception as e:
            AUDIT_LOG.critical("Login failed - Could not create session. Is memcached running?")
            log.critical("Login failed - Could not create session. Is memcached running?")
            log.exception(e)
            raise

        dog_stats_api.increment("common.student.successful_login")
        request.session.save()

        response = JsonResponse({
            "success": True,
            "access_token": request.session.session_key,
            "expires": expires,
            "username": user.username
        })

        return response

        # response.set_cookie(
        #     settings.EDXMKTG_COOKIE_NAME, 'true', max_age=max_age,
        #     expires=expires, domain=settings.SESSION_COOKIE_DOMAIN,
        #     path='/', secure=None, httponly=None,
        # )

    reactivation_email_for_user(user)

    return JsonResponse({
        "success": False,
        "value": "This account has not been activated. We have sent another activation message. Please check your e-mail for the activation instructions."
    })


def mobi_token_logout(request):
    # erase the token
    logout(request)

    return JsonResponse({
        "success": True
    })




def do_institution_import_teacher_create_account(post_vars, institute_id):
    """
    Given cleaned post variables, create the User and UserProfile objects, as well as the
    registration for this user.

    Returns a tuple (User, UserProfile, Registration).

    Note: this function is also used for creating test users.
    """
    user = User(username=post_vars['username'],
                email=post_vars['email'],
                is_active=True)
    user.set_password(post_vars['password'])
    registration = Registration()
    # TODO: Rearrange so that if part of the process fails, the whole process fails.
    # Right now, we can have e.g. no registration e-mail sent out and a zombie account
    try:
        user.save()
    except IntegrityError:
        js = {'success': False}
        # Figure out the cause of the integrity error
        if len(User.objects.filter(username=post_vars['username'])) > 0:
            js['value'] = _("An account with the Public Username '{username}' already exists.").format(username=post_vars['username'])
            js['field'] = 'username'
            profile = UserProfile.objects.get(user_id=User.objects.get(username=post_vars['username']).id)
            profile.institute = institute_id
            profile.save()
            return JsonResponse(js, status=400)

        if len(User.objects.filter(email=post_vars['email'])) > 0:
            js['value'] = _("An account with the Email '{email}' already exists.").format(email=post_vars['email'])
            js['field'] = 'email'
            profile = UserProfile.objects.get(user_id=User.objects.get(email=post_vars['email']).id)
            profile.institute = institute_id
            profile.save()
            return JsonResponse(js, status=400)

        raise

    registration.register(user)

    profile = UserProfile(user=user)
    profile.name = post_vars['name']
    profile.level_of_education = post_vars.get('level_of_education')
    profile.gender = post_vars.get('gender')
    profile.mailing_address = post_vars.get('mailing_address')
    profile.city = post_vars.get('city')
    profile.country = post_vars.get('country')
    profile.goals = post_vars.get('goals')
    profile.profile_role = 'th'
    profile.institute = institute_id

    try:
        profile.year_of_birth = int(post_vars['year_of_birth'])
    except (ValueError, KeyError):
        # If they give us garbage, just ignore it instead
        # of asking them to put an integer.
        profile.year_of_birth = None
    try:
        profile.save()
    except Exception:
        log.exception("UserProfile creation failed for user {id}.".format(id=user.id))
    return (user, profile, registration)
