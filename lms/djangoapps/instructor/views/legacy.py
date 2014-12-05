# -*- coding: utf-8 -*
"""
Instructor Views
"""
import Queue
import csv
import json
import logging
import os
import re
import requests

from collections import defaultdict, OrderedDict
from markupsafe import escape
from requests.status_codes import codes
from StringIO import StringIO

from django.conf import settings
from django.contrib.auth.models import User
from django.http import HttpResponse
from django_future.csrf import ensure_csrf_cookie
from django.views.decorators.cache import cache_control
from django.core.urlresolvers import reverse
from django.core.mail import send_mail
from django.utils import timezone

from util.json_request import JsonResponse

from django.core.validators import validate_email, validate_slug, ValidationError
from student.models import UserProfile,Registration
from django.db import IntegrityError
from django.utils.translation import ugettext as _


from xmodule_modifiers import wrap_xblock
import xmodule.graders as xmgraders
from xmodule.modulestore import XML_MODULESTORE_TYPE, Location
from xmodule.modulestore.django import modulestore
from xmodule.modulestore.exceptions import ItemNotFoundError
from xmodule.html_module import HtmlDescriptor

from bulk_email.models import CourseEmail, CourseAuthorization
from courseware import grades
from courseware.access import has_access
from courseware.courses import get_course_with_access, get_cms_course_link
from student.roles import (
    CourseStaffRole, CourseInstructorRole, CourseBetaTesterRole, GlobalStaff
)
from courseware.models import StudentModule
from django_comment_common.models import (
    Role, FORUM_ROLE_ADMINISTRATOR, FORUM_ROLE_MODERATOR, FORUM_ROLE_COMMUNITY_TA
)
from django_comment_client.utils import has_forum_access
from instructor.offline_gradecalc import student_grades, offline_grades_available
from instructor.views.tools import strip_if_string
from instructor_task.api import (
    get_running_instructor_tasks,
    get_instructor_task_history,
    submit_rescore_problem_for_all_students,
    submit_rescore_problem_for_student,
    submit_reset_problem_attempts_for_all_students,
    submit_bulk_course_email
)
from instructor_task.views import get_task_completion_info
from edxmako.shortcuts import render_to_response, render_to_string
from class_dashboard import dashboard_data
from psychometrics import psychoanalyze
from student.models import CourseEnrollment, CourseEnrollmentAllowed, unique_id_for_user
from student.views import course_from_id
import track.views
from xblock.field_data import DictFieldData
from xblock.fields import ScopeIds
from django.utils.translation import ugettext as _u

from microsite_configuration import microsite
from contentstore.utils import send_mail_update

from util.email_utils import send_mails

log = logging.getLogger(__name__)

# internal commands for managing forum roles:
FORUM_ROLE_ADD = 'add'
FORUM_ROLE_REMOVE = 'remove'

# For determining if a shibboleth course
SHIBBOLETH_DOMAIN_PREFIX = 'shib:'


def split_by_comma_and_whitespace(a_str):
    """
    Return string a_str, split by , or whitespace
    """
    return re.split(r'[\s,]', a_str)


@ensure_csrf_cookie
@cache_control(no_cache=True, no_store=True, must_revalidate=True)
def instructor_dashboard(request, course_id):
    """Display the instructor dashboard for a course."""
    course = get_course_with_access(request.user, course_id, 'staff', depth=None)

    instructor_access = has_access(request.user, course, 'instructor')   # an instructor can manage staff lists

    forum_admin_access = has_forum_access(request.user, course_id, FORUM_ROLE_ADMINISTRATOR)

    msg = ''
    email_msg = ''
    email_to_option = None
    email_subject = None
    html_message = ''
    show_email_tab = False
    show_email_tab_free = False
    problems = []
    plots = []
    datatable = {}

    # the instructor dashboard page is modal: grades, psychometrics, admin
    # keep that state in request.session (defaults to grades mode)
    idash_mode = request.POST.get('idash_mode', '')

    if idash_mode:
        request.session['idash_mode'] = idash_mode
    else:
        idash_mode = request.session.get('idash_mode', 'Grades')

    enrollment_number = CourseEnrollment.num_enrolled_in(course_id)

    # assemble some course statistics for output to instructor
    def get_course_stats_table():
        datatable = {
            'header': ['统计', '统计值'],
            # 'title': _u('Course Statistics At A Glance'),
            'title': _u('课程统计'),
        }
        data = [['# Enrolled', enrollment_number]]
        data += [['Date', timezone.now().isoformat()]]
        data += compute_course_stats(course).items()
        if request.user.is_staff:
            for field in course.fields.values():
                if getattr(field.scope, 'user', False):
                    continue

                data.append([field.name, json.dumps(field.read_json(course))])
        datatable['data'] = data
        return datatable

    def return_csv(func, datatable, file_pointer=None):
        """Outputs a CSV file from the contents of a datatable."""
        if file_pointer is None:
            response = HttpResponse(mimetype='text/csv')
            response['Content-Disposition'] = 'attachment; filename={0}'.format(func)
        else:
            response = file_pointer
        writer = csv.writer(response, dialect='excel', quotechar='"', quoting=csv.QUOTE_ALL)
        encoded_row = [unicode(s).encode('utf-8') for s in datatable['header']]
        writer.writerow(encoded_row)
        for datarow in datatable['data']:
            # 's' here may be an integer, float (eg score) or string (eg student name)
            encoded_row = [
                # If s is already a UTF-8 string, trying to make a unicode
                # object out of it will fail unless we pass in an encoding to
                # the constructor. But we can't do that across the board,
                # because s is often a numeric type. So just do this.
                s if isinstance(s, str) else unicode(s).encode('utf-8')
                for s in datarow
            ]
            writer.writerow(encoded_row)
        return response

    def get_module_url(urlname):
        """
        Construct full URL for a module from its urlname.

        Form is either urlname or modulename/urlname.  If no modulename
        is provided, "problem" is assumed.
        """
        # remove whitespace
        urlname = strip_if_string(urlname)

        # tolerate an XML suffix in the urlname
        if urlname[-4:] == ".xml":
            urlname = urlname[:-4]

        # implement default
        if '/' not in urlname:
            urlname = "problem/" + urlname

        # complete the url using information about the current course:
        parts = Location.parse_course_id(course_id)
        parts['url'] = urlname
        return u"i4x://{org}/{name}/{url}".format(**parts)

    def get_student_from_identifier(unique_student_identifier):
        """Gets a student object using either an email address or username"""
        unique_student_identifier = strip_if_string(unique_student_identifier)
        msg = ""
        try:
            if "@" in unique_student_identifier:
                student = User.objects.get(email=unique_student_identifier)
            else:
                student = User.objects.get(username=unique_student_identifier)
            msg += _u("Found a single student.  ")
        except User.DoesNotExist:
            student = None
            msg += "<font color='red'>{text}</font>".format(
                text=_u("Couldn't find student with that email or username.")
            )
        return msg, student

    # process actions from form POST
    action = request.POST.get('action', '')
    use_offline = request.POST.get('use_offline_grades', False)

    if settings.FEATURES['ENABLE_MANUAL_GIT_RELOAD']:
        if 'GIT pull' in action:
            data_dir = course.data_dir
            log.debug('git pull {0}'.format(data_dir))
            gdir = settings.DATA_DIR / data_dir
            if not os.path.exists(gdir):
                msg += "====> ERROR in gitreload - no such directory {0}".format(gdir)
            else:
                cmd = "cd {0}; git reset --hard HEAD; git clean -f -d; git pull origin; chmod g+w course.xml".format(gdir)
                msg += "git pull on {0}:<p>".format(data_dir)
                msg += "<pre>{0}</pre></p>".format(escape(os.popen(cmd).read()))
                track.views.server_track(request, "git-pull", {"directory": data_dir}, page="idashboard")

        if 'Reload course' in action:
            log.debug('reloading {0} ({1})'.format(course_id, course))
            try:
                data_dir = course.data_dir
                modulestore().try_load_course(data_dir)
                msg += "<br/><p>Course reloaded from {0}</p>".format(data_dir)
                track.views.server_track(request, "reload", {"directory": data_dir}, page="idashboard")
                course_errors = modulestore().get_item_errors(course.location)
                msg += '<ul>'
                for cmsg, cerr in course_errors:
                    msg += "<li>{0}: <pre>{1}</pre>".format(cmsg, escape(cerr))
                msg += '</ul>'
            except Exception as err:
                msg += '<br/><p>Error: {0}</p>'.format(escape(err))

    if action == 'Dump list of enrolled students' or action == 'List enrolled students':
        log.debug(action)
        datatable = get_student_grade_summary_data(request, course, course_id, get_grades=False, use_offline=use_offline)
        datatable['title'] = _u('List of students enrolled in {0}').format(course_id)
        track.views.server_track(request, "list-students", {}, page="idashboard")

    elif 'Dump Grades' in action:
        log.debug(action)
        datatable = get_student_grade_summary_data(request, course, course_id, get_grades=True, use_offline=use_offline)
        datatable['title'] = _u('Summary Grades of students enrolled in {0}').format(course_id)
        track.views.server_track(request, "dump-grades", {}, page="idashboard")

    elif 'Dump all RAW grades' in action:
        log.debug(action)
        datatable = get_student_grade_summary_data(request, course, course_id, get_grades=True,
                                                   get_raw_scores=True, use_offline=use_offline)
        datatable['title'] = _u('Raw Grades of students enrolled in {0}').format(course_id)
        track.views.server_track(request, "dump-grades-raw", {}, page="idashboard")

    elif 'Download CSV of all student grades' in action:
        track.views.server_track(request, "dump-grades-csv", {}, page="idashboard")
        return return_csv('grades_{0}.csv'.format(course_id),
                          get_student_grade_summary_data(request, course, course_id, use_offline=use_offline))

    elif 'Download CSV of all RAW grades' in action:
        track.views.server_track(request, "dump-grades-csv-raw", {}, page="idashboard")
        return return_csv('grades_{0}_raw.csv'.format(course_id),
                          get_student_grade_summary_data(request, course, course_id, get_raw_scores=True, use_offline=use_offline))

    elif 'Download CSV of answer distributions' in action:
        track.views.server_track(request, "dump-answer-dist-csv", {}, page="idashboard")
        return return_csv('answer_dist_{0}.csv'.format(course_id), get_answers_distribution(request, course_id))

    elif 'Dump description of graded assignments configuration' in action:
        # what is "graded assignments configuration"?
        track.views.server_track(request, "dump-graded-assignments-config", {}, page="idashboard")
        msg += dump_grading_context(course)

    elif "Rescore ALL students' problem submissions" in action:
        problem_urlname = request.POST.get('problem_for_all_students', '')
        problem_url = get_module_url(problem_urlname)
        try:
            instructor_task = submit_rescore_problem_for_all_students(request, course_id, problem_url)
            if instructor_task is None:
                msg += '<font color="red">{text}</font>'.format(
                    text=_u('Failed to create a background task for rescoring "{0}".').format(problem_url)
                )
            else:
                track.views.server_track(request, "rescore-all-submissions", {"problem": problem_url, "course": course_id}, page="idashboard")
        except ItemNotFoundError as err:
            msg += '<font color="red">{text}</font>'.format(
                text=_u('Failed to create a background task for rescoring "{0}": problem not found.').format(problem_url)
            )
        except Exception as err:
            log.error("Encountered exception from rescore: {0}".format(err))
            msg += '<font color="red">{text}</font>'.format(
                text=_u('Failed to create a background task for rescoring "{url}": {message}.').format(
                    url=problem_url, message=err.message
                )
            )

    elif "Reset ALL students' attempts" in action:
        problem_urlname = request.POST.get('problem_for_all_students', '')
        problem_url = get_module_url(problem_urlname)
        try:
            instructor_task = submit_reset_problem_attempts_for_all_students(request, course_id, problem_url)
            if instructor_task is None:
                msg += '<font color="red">{text}</font>'.format(
                    text=_u('Failed to create a background task for resetting "{0}".').format(problem_url)
                )
            else:
                track.views.server_track(request, "reset-all-attempts", {"problem": problem_url, "course": course_id}, page="idashboard")
        except ItemNotFoundError as err:
            log.error('Failure to reset: unknown problem "{0}"'.format(err))
            msg += '<font color="red">{text}</font>'.format(
                text=_u('Failed to create a background task for resetting "{0}": problem not found.').format(problem_url)
            )
        except Exception as err:
            log.error("Encountered exception from reset: {0}".format(err))
            msg += '<font color="red">{text}</font>'.format(
                text=_u('Failed to create a background task for resetting "{url}": {message}.').format(
                    url=problem_url, message=err.message
                )
            )

    elif "Show Background Task History for Student" in action:
        # put this before the non-student case, since the use of "in" will cause this to be missed
        unique_student_identifier = request.POST.get('unique_student_identifier', '')
        message, student = get_student_from_identifier(unique_student_identifier)
        if student is None:
            msg += message
        else:
            problem_urlname = request.POST.get('problem_for_student', '')
            problem_url = get_module_url(problem_urlname)
            message, datatable = get_background_task_table(course_id, problem_url, student)
            msg += message

    elif "Show Background Task History" in action:
        problem_urlname = request.POST.get('problem_for_all_students', '')
        problem_url = get_module_url(problem_urlname)
        message, datatable = get_background_task_table(course_id, problem_url)
        msg += message

    elif ("Reset student's attempts" in action or
          "Delete student state for module" in action or
          "Rescore student's problem submission" in action):
        # get the form data
        unique_student_identifier = request.POST.get(
            'unique_student_identifier', ''
        )
        problem_urlname = request.POST.get('problem_for_student', '')
        module_state_key = get_module_url(problem_urlname)
        # try to uniquely id student by email address or username
        message, student = get_student_from_identifier(unique_student_identifier)
        msg += message
        student_module = None
        if student is not None:
            # find the module in question
            try:
                student_module = StudentModule.objects.get(
                    student_id=student.id,
                    course_id=course_id,
                    module_state_key=module_state_key
                )
                msg += _u("Found module.  ")
            except StudentModule.DoesNotExist as err:
                error_msg = _u("Couldn't find module with that urlname: {url}. ").format(url=problem_urlname)
                msg += "<font color='red'>{err_msg} ({err})</font>".format(err_msg=error_msg, err=err)
                log.debug(error_msg)

        if student_module is not None:
            if "Delete student state for module" in action:
                # delete the state
                try:
                    student_module.delete()
                    msg += "<font color='red'>{text}</font>".format(
                        text=_u("Deleted student module state for {state}!").format(state=module_state_key)
                    )
                    event = {
                        "problem": module_state_key,
                        "student": unique_student_identifier,
                        "course": course_id
                    }
                    track.views.server_track(
                        request,
                        "delete-student-module-state",
                        event,
                        page="idashboard"
                    )
                except Exception as err:
                    error_msg = _u("Failed to delete module state for {id}/{url}. ").format(
                        id=unique_student_identifier, url=problem_urlname
                    )
                    msg += "<font color='red'>{err_msg} ({err})</font>".format(err_msg=error_msg, err=err)
                    log.exception(error_msg)
            elif "Reset student's attempts" in action:
                # modify the problem's state
                try:
                    # load the state json
                    problem_state = json.loads(student_module.state)
                    old_number_of_attempts = problem_state["attempts"]
                    problem_state["attempts"] = 0
                    # save
                    student_module.state = json.dumps(problem_state)
                    student_module.save()
                    event = {
                        "old_attempts": old_number_of_attempts,
                        "student": unicode(student),
                        "problem": student_module.module_state_key,
                        "instructor": unicode(request.user),
                        "course": course_id
                    }
                    track.views.server_track(request, "reset-student-attempts", event, page="idashboard")
                    msg += "<font color='green'>{text}</font>".format(
                        text=_u("Module state successfully reset!")
                    )
                except Exception as err:
                    error_msg = _u("Couldn't reset module state for {id}/{url}. ").format(
                        id=unique_student_identifier, url=problem_urlname
                    )
                    msg += "<font color='red'>{err_msg} ({err})</font>".format(err_msg=error_msg, err=err)
                    log.exception(error_msg)
            else:
                # "Rescore student's problem submission" case
                try:
                    instructor_task = submit_rescore_problem_for_student(request, course_id, module_state_key, student)
                    if instructor_task is None:
                        msg += '<font color="red">{text}</font>'.format(
                            text=_u('Failed to create a background task for rescoring "{key}" for student {id}.').format(
                                key=module_state_key, id=unique_student_identifier
                            )
                        )
                    else:
                        track.views.server_track(request, "rescore-student-submission", {"problem": module_state_key, "student": unique_student_identifier, "course": course_id}, page="idashboard")
                except Exception as err:
                    msg += '<font color="red">{text}</font>'.format(
                        text=_u('Failed to create a background task for rescoring "{key}": {id}.').format(
                            key=module_state_key, id=err.message
                        )
                    )
                    log.exception("Encountered exception from rescore: student '{0}' problem '{1}'".format(
                        unique_student_identifier, module_state_key
                    )
                    )

    elif "Get link to student's progress page" in action:
        unique_student_identifier = request.POST.get('unique_student_identifier', '')
        # try to uniquely id student by email address or username
        message, student = get_student_from_identifier(unique_student_identifier)
        msg += message
        if student is not None:
            progress_url = reverse('student_progress', kwargs={'course_id': course_id, 'student_id': student.id})
            track.views.server_track(request, "get-student-progress-page", {"student": unicode(student), "instructor": unicode(request.user), "course": course_id}, page="idashboard")
            msg += "<a href='{url}' target='_blank'>{text}</a>.".format(
                url=progress_url,
                text=_u("Progress page for username: {username} with email address: {email}").format(
                    username=student.username, email=student.email
                )
            )

    #----------------------------------------
    # export grades to remote gradebook

    elif action == 'List assignments available in remote gradebook':
        msg2, datatable = _do_remote_gradebook(request.user, course, 'get-assignments')
        msg += msg2

    elif action == 'List assignments available for this course':
        log.debug(action)
        allgrades = get_student_grade_summary_data(request, course, course_id, get_grades=True, use_offline=use_offline)

        assignments = [[x] for x in allgrades['assignments']]
        datatable = {'header': [_u('Assignment Name')]}
        datatable['data'] = assignments
        datatable['title'] = action

        msg += 'assignments=<pre>%s</pre>' % assignments

    elif action == 'List enrolled students matching remote gradebook':
        stud_data = get_student_grade_summary_data(request, course, course_id, get_grades=False, use_offline=use_offline)
        msg2, rg_stud_data = _do_remote_gradebook(request.user, course, 'get-membership')
        datatable = {'header': ['Student  email', 'Match?']}
        rg_students = [x['email'] for x in rg_stud_data['retdata']]

        def domatch(x):
            return 'yes' if x.email in rg_students else 'No'
        datatable['data'] = [[x.email, domatch(x)] for x in stud_data['students']]
        datatable['title'] = action

    elif action in ['Display grades for assignment', 'Export grades for assignment to remote gradebook',
                    'Export CSV file of grades for assignment']:

        log.debug(action)
        datatable = {}
        aname = request.POST.get('assignment_name', '')
        if not aname:
            msg += "<font color='red'>{text}</font>".format(text=_u("Please enter an assignment name"))
        else:
            allgrades = get_student_grade_summary_data(request, course, course_id, get_grades=True, use_offline=use_offline)
            if aname not in allgrades['assignments']:
                msg += "<font color='red'>{text}</font>".format(
                    text=_u("Invalid assignment name '{name}'").format(name=aname)
                )
            else:
                aidx = allgrades['assignments'].index(aname)
                datatable = {'header': [_u('External email'), aname]}
                ddata = []
                for x in allgrades['students']:	  # do one by one in case there is a student who has only partial grades
                    try:
                        ddata.append([x.email, x.grades[aidx]])
                    except IndexError:
                        log.debug('No grade for assignment {idx} ({name}) for student {email}'.format(
                            idx=aidx, name=aname, email=x.email)
                        )
                datatable['data'] = ddata

                datatable['title'] = _u('Grades for assignment "{name}"').format(name=aname)

                if 'Export CSV' in action:
                    # generate and return CSV file
                    return return_csv('grades {name}.csv'.format(name=aname), datatable)

                elif 'remote gradebook' in action:
                    file_pointer = StringIO()
                    return_csv('', datatable, file_pointer=file_pointer)
                    file_pointer.seek(0)
                    files = {'datafile': file_pointer}
                    msg2, _ = _do_remote_gradebook(request.user, course, 'post-grades', files=files)
                    msg += msg2

    #----------------------------------------
    # Admin

    elif 'List course staff' in action:
        role = CourseStaffRole(course.location)
        datatable = _role_members_table(role, _u("List of Staff"), course_id)
        track.views.server_track(request, "list-staff", {}, page="idashboard")

    elif 'List course instructors' in action and GlobalStaff().has_user(request.user):
        role = CourseInstructorRole(course.location)
        datatable = _role_members_table(role, _u("List of Instructors"), course_id)
        track.views.server_track(request, "list-instructors", {}, page="idashboard")

    elif action == 'Add course staff':
        uname = request.POST['staffuser']
        role = CourseStaffRole(course.location)
        msg += add_user_to_role(request, uname, role, 'staff', 'staff')

    elif action == 'Add instructor' and request.user.is_staff:
        uname = request.POST['instructor']
        role = CourseInstructorRole(course.location)
        msg += add_user_to_role(request, uname, role, 'instructor', 'instructor')

    elif action == 'Remove course staff':
        uname = request.POST['staffuser']
        role = CourseStaffRole(course.location)
        msg += remove_user_from_role(request, uname, role, 'staff', 'staff')

    elif action == 'Remove instructor' and request.user.is_staff:
        uname = request.POST['instructor']
        role = CourseInstructorRole(course.location)
        msg += remove_user_from_role(request, uname, role, 'instructor', 'instructor')

    #----------------------------------------
    # DataDump

    elif 'Download CSV of all student profile data' in action:
        enrolled_students = User.objects.filter(
            courseenrollment__course_id=course_id,
            courseenrollment__is_active=1,
        ).order_by('username').select_related("profile")
        profkeys = ['name', 'language', 'location', 'year_of_birth', 'gender', 'level_of_education',
                    'mailing_address', 'goals']
        datatable = {'header': ['username', 'email'] + profkeys}

        def getdat(u):
            p = u.profile
            return [u.username, u.email] + [getattr(p, x, '') for x in profkeys]

        datatable['data'] = [getdat(u) for u in enrolled_students]
        datatable['title'] = _u('Student profile data for course {course_id}').format(course_id = course_id)
        return return_csv('profiledata_{course_id}.csv'.format(course_id = course_id), datatable)

    elif 'Download CSV of all responses to problem' in action:
        problem_to_dump = request.POST.get('problem_to_dump', '')

        if problem_to_dump[-4:] == ".xml":
            problem_to_dump = problem_to_dump[:-4]
        try:
            course_id_dict = Location.parse_course_id(course_id)
            module_state_key = u"i4x://{org}/{course}/problem/{0}".format(problem_to_dump, **course_id_dict)
            smdat = StudentModule.objects.filter(
                course_id=course_id,
                module_state_key=module_state_key
            )
            smdat = smdat.order_by('student')
            msg += _u("Found {num} records to dump.").format(num=smdat)
        except Exception as err:
            msg += "<font color='red'>{text}</font><pre>{err}</pre>".format(
                text=_u("Couldn't find module with that urlname."),
                err=escape(err)
            )
            smdat = []

        if smdat:
            datatable = {'header': ['username', 'state']}
            datatable['data'] = [[x.student.username, x.state] for x in smdat]
            datatable['title'] = _u('Student state for problem {problem}').format(problem = problem_to_dump)
            return return_csv('student_state_from_{problem}.csv'.format(problem = problem_to_dump), datatable)

    elif 'Download CSV of all student anonymized IDs' in action:
        students = User.objects.filter(
            courseenrollment__course_id=course_id,
        ).order_by('id')

        datatable = {'header': ['User ID', 'Anonymized user ID']}
        datatable['data'] = [[s.id, unique_id_for_user(s)] for s in students]
        return return_csv(course_id.replace('/', '-') + '-anon-ids.csv', datatable)

    #----------------------------------------
    # Group management

    elif 'List beta testers' in action:
        role = CourseBetaTesterRole(course.location)
        datatable = _role_members_table(role, _u("List of Beta Testers"), course_id)
        track.views.server_track(request, "list-beta-testers", {}, page="idashboard")

    elif action == 'Add beta testers':
        users = request.POST['betausers']
        log.debug("users: {0!r}".format(users))
        role = CourseBetaTesterRole(course.location)
        for username_or_email in split_by_comma_and_whitespace(users):
            msg += "<p>{0}</p>".format(
                add_user_to_role(request, username_or_email, role, 'beta testers', 'beta-tester'))

    elif action == 'Remove beta testers':
        users = request.POST['betausers']
        role = CourseBetaTesterRole(course.location)
        for username_or_email in split_by_comma_and_whitespace(users):
            msg += "<p>{0}</p>".format(
                remove_user_from_role(request, username_or_email, role, 'beta testers', 'beta-tester'))

    #----------------------------------------
    # forum administration

    elif action == 'List course forum admins':
        rolename = FORUM_ROLE_ADMINISTRATOR
        datatable = {}
        msg += _list_course_forum_members(course_id, rolename, datatable)
        track.views.server_track(request, "list-forum-admins", {"course": course_id}, page="idashboard")

    elif action == 'Remove forum admin':
        uname = request.POST['forumadmin']
        msg += _update_forum_role_membership(uname, course, FORUM_ROLE_ADMINISTRATOR, FORUM_ROLE_REMOVE)
        track.views.server_track(request, "remove-forum-admin", {"username": uname, "course": course_id}, page="idashboard")

    elif action == 'Add forum admin':
        uname = request.POST['forumadmin']
        msg += _update_forum_role_membership(uname, course, FORUM_ROLE_ADMINISTRATOR, FORUM_ROLE_ADD)
        track.views.server_track(request, "add-forum-admin", {"username": uname, "course": course_id}, page="idashboard")

    elif action == 'List course forum moderators':
        rolename = FORUM_ROLE_MODERATOR
        datatable = {}
        msg += _list_course_forum_members(course_id, rolename, datatable)
        track.views.server_track(request, "list-forum-mods", {"course": course_id}, page="idashboard")

    elif action == 'Remove forum moderator':
        uname = request.POST['forummoderator']
        msg += _update_forum_role_membership(uname, course, FORUM_ROLE_MODERATOR, FORUM_ROLE_REMOVE)
        track.views.server_track(request, "remove-forum-mod", {"username": uname, "course": course_id}, page="idashboard")

    elif action == 'Add forum moderator':
        uname = request.POST['forummoderator']
        msg += _update_forum_role_membership(uname, course, FORUM_ROLE_MODERATOR, FORUM_ROLE_ADD)
        track.views.server_track(request, "add-forum-mod", {"username": uname, "course": course_id}, page="idashboard")

    elif action == 'List course forum community TAs':
        rolename = FORUM_ROLE_COMMUNITY_TA
        datatable = {}
        msg += _list_course_forum_members(course_id, rolename, datatable)
        track.views.server_track(request, "list-forum-community-TAs", {"course": course_id}, page="idashboard")

    elif action == 'Remove forum community TA':
        uname = request.POST['forummoderator']
        msg += _update_forum_role_membership(uname, course, FORUM_ROLE_COMMUNITY_TA, FORUM_ROLE_REMOVE)
        track.views.server_track(request, "remove-forum-community-TA", {"username": uname, "course": course_id}, page="idashboard")

    elif action == 'Add forum community TA':
        uname = request.POST['forummoderator']
        msg += _update_forum_role_membership(uname, course, FORUM_ROLE_COMMUNITY_TA, FORUM_ROLE_ADD)
        track.views.server_track(request, "add-forum-community-TA", {"username": uname, "course": course_id}, page="idashboard")

    #----------------------------------------
    # enrollment

    elif action == 'List students who may enroll but may not have yet signed up':
        ceaset = CourseEnrollmentAllowed.objects.filter(course_id=course_id)
        datatable = {'header': ['学生电子邮件']}
        datatable['data'] = [[x.email] for x in ceaset]
        datatable['title'] = action

    elif action == u'正在招收':

        is_shib_course = uses_shib(course)
        students = request.POST.get('multiple_students', '')
        auto_enroll = bool(request.POST.get('auto_enroll'))
        students_filter(students)
        email_students = bool(request.POST.get('email_students'))
        print email_students
        print request.POST
        ret = _do_enroll_students(course, course_id, students, auto_enroll=auto_enroll, email_students=email_students, is_shib_course=is_shib_course)
        datatable = ret['datatable']
        print '-----------------------finish-------------------------------------------------'

    elif action == u'正在取消':

        students = request.POST.get('multiple_students', '')
        email_students = bool(request.POST.get('email_students'))
        ret = _do_unenroll_students(course_id, students, email_students=email_students)
        datatable = ret['datatable']

    elif action == 'List sections available in remote gradebook':

        msg2, datatable = _do_remote_gradebook(request.user, course, 'get-sections')
        msg += msg2

    elif action in ['List students in section in remote gradebook',
                    'Overload enrollment list using remote gradebook',
                    'Merge enrollment list with remote gradebook']:

        section = request.POST.get('gradebook_section', '')
        msg2, datatable = _do_remote_gradebook(request.user, course, 'get-membership', dict(section=section))
        msg += msg2

        if not 'List' in action:
            students = ','.join([x['email'] for x in datatable['retdata']])
            overload = 'Overload' in action
            ret = _do_enroll_students(course, course_id, students, overload=overload)
            datatable = ret['datatable']

    #----------------------------------------
    # email

    elif action == 'Send email':
        print '----------------debug------------------------------'
        email_to_option = request.POST.get("to_option")
        email_subject = request.POST.get("subject")
        html_message = request.POST.get("message")

        try:
            # Create the CourseEmail object.  This is saved immediately, so that
            # any transaction that has been pending up to this point will also be
            # committed.
            email = CourseEmail.create(course_id, request.user, email_to_option, email_subject, html_message)

            # Submit the task, so that the correct InstructorTask object gets created (for monitoring purposes)
            submit_bulk_course_email(request, course_id, email.id)  # pylint: disable=E1101

        except Exception as err:
            # Catch any errors and deliver a message to the user
            error_msg = "Failed to send email! ({0})".format(err)
            msg += "<font color='red'>" + error_msg + "</font>"
            log.exception(error_msg)

        else:
            # If sending the task succeeds, deliver a success message to the user.
            if email_to_option == "all":
                text = _u(
                    "Your email was successfully queued for sending. "
                    "Please note that for large classes, it may take up to an hour "
                    "(or more, if other courses are simultaneously sending email) "
                    "to send all emails."
                )
            else:
                text = _u('你的电子邮件已成功加入发送队列.')
            email_msg = '<div class="msg msg-confirm"><p class="copy">{text}</p></div>'.format(text=text)

    elif "Show Background Email Task History" in action:
        message, datatable = get_background_task_table(course_id, task_type='bulk_course_email')
        msg += message

    elif "Show Background Email Task History" in action:
        message, datatable = get_background_task_table(course_id, task_type='bulk_course_email')
        msg += message


    #----------------------------------------
    # 发送添加邮箱邮件

    elif action == '发送添加邮箱邮件':
        email_to_option_select = request.POST.get("student")
        email_subject = request.POST.get("subject")
        html_message = request.POST.get("message")
        email_to_option_select = str(email_to_option_select)
        email_to_option_select_list = []

        for i in range(1, email_to_option_select.count(';')+2):
            email_to_option_select_list.append(email_to_option_select.split(';')[-i])


        queue = Queue.Queue()
        try:
            # update_content = json['content']
            # student_data_email_list = []
            for i in range(0, len(email_to_option_select_list)):
                queue.put(email_to_option_select_list[i])

            for k in range(2):
                threadname = 'Thread' + str(k)
                send_mail_update(threadname, queue, html_message, email_subject)
                print 'success'
            # queue.join()
        except:
            raise
            print 'failure'

    #----------------------------------------
    # psychometrics

    elif action == 'Generate Histogram and IRT Plot':
        problem = request.POST['Problem']
        nmsg, plots = psychoanalyze.generate_plots_for_problem(problem)
        msg += nmsg
        track.views.server_track(request, "psychometrics-histogram-generation", {"problem": unicode(problem)}, page="idashboard")

    if idash_mode == 'Psychometrics':
        problems = psychoanalyze.problems_with_psychometric_data(course_id)

    #----------------------------------------
    # analytics
    def get_analytics_result(analytics_name):
        """Return data for an Analytic piece, or None if it doesn't exist. It
        logs and swallows errors.
        """
        url = settings.ANALYTICS_SERVER_URL + \
            u"get?aname={}&course_id={}&apikey={}".format(analytics_name,
                                                         course_id,
                                                         settings.ANALYTICS_API_KEY)
        try:
            res = requests.get(url)
        except Exception:
            log.exception("Error trying to access analytics at %s", url)
            return None

        if res.status_code == codes.OK:
            # WARNING: do not use req.json because the preloaded json doesn't
            # preserve the order of the original record (hence OrderedDict).
            return json.loads(res.content, object_pairs_hook=OrderedDict)
        else:
            log.error("Error fetching %s, code: %s, msg: %s",
                      url, res.status_code, res.content)
        return None

    analytics_results = {}

    if idash_mode == 'Analytics':
        DASHBOARD_ANALYTICS = [
            # "StudentsAttemptedProblems",  # num students who tried given problem
            "StudentsDailyActivity",  # active students by day
            "StudentsDropoffPerDay",  # active students dropoff by day
            # "OverallGradeDistribution",  # overall point distribution for course
            "StudentsActive",  # num students active in time period (default = 1wk)
            "StudentsEnrolled",  # num students enrolled
            # "StudentsPerProblemCorrect",  # foreach problem, num students correct
            "ProblemGradeDistribution",  # foreach problem, grade distribution
        ]
        for analytic_name in DASHBOARD_ANALYTICS:
            analytics_results[analytic_name] = get_analytics_result(analytic_name)

    #----------------------------------------
    # Metrics

    metrics_results = {}
    if settings.FEATURES.get('CLASS_DASHBOARD') and idash_mode == 'Metrics':
        metrics_results['section_display_name'] = dashboard_data.get_section_display_name(course_id)
        metrics_results['section_has_problem'] = dashboard_data.get_array_section_has_problem(course_id)

    #----------------------------------------
    # offline grades?

    if use_offline:
        msg += "<br/><font color='orange'>{text}</font>".format(
            text=_u("Grades from {course_id}").format(
                course_id=offline_grades_available(course_id)
            )
        )

    # generate list of pending background tasks
    if settings.FEATURES.get('ENABLE_INSTRUCTOR_BACKGROUND_TASKS'):
        instructor_tasks = get_running_instructor_tasks(course_id)
    else:
        instructor_tasks = None

    # determine if this is a studio-backed course so we can provide a link to edit this course in studio
    is_studio_course = modulestore().get_modulestore_type(course_id) != XML_MODULESTORE_TYPE

    studio_url = None
    if is_studio_course:
        studio_url = get_cms_course_link(course)

    email_editor = None
    # HTML editor for email
    if idash_mode == 'Email' and is_studio_course:
        html_module = HtmlDescriptor(
            course.system,
            DictFieldData({'data': html_message}),
            ScopeIds(None, None, None, 'i4x://dummy_org/dummy_course/html/dummy_name')
        )
        fragment = html_module.render('studio_view')
        fragment = wrap_xblock('LmsRuntime', html_module, 'studio_view', fragment, None, extra_data={"course-id": course_id})
        email_editor = fragment.content

    if idash_mode == 'Email_free' and is_studio_course:
        html_module = HtmlDescriptor(
            course.system,
            DictFieldData({'data': html_message}),
            ScopeIds(None, None, None, 'i4x://dummy_org/dummy_course/html/dummy_name')
        )
        fragment = html_module.render('studio_view')
        fragment = wrap_xblock('LmsRuntime', html_module, 'studio_view', fragment, None, extra_data={"course-id": course_id})
        email_editor = fragment.content

    # Enable instructor email only if the following conditions are met:
    # 1. Feature flag is on
    # 2. We have explicitly enabled email for the given course via django-admin
    # 3. It is NOT an XML course
    if settings.FEATURES['ENABLE_INSTRUCTOR_EMAIL'] and \
       CourseAuthorization.instructor_email_enabled(course_id) and is_studio_course:
        show_email_tab = True

    if settings.FEATURES['ENABLE_INSTRUCTOR_EMAIL'] and \
       CourseAuthorization.instructor_email_enabled(course_id) and is_studio_course:
        show_email_tab_free = True

    # display course stats only if there is no other table to display:
    course_stats = None
    if not datatable:
        course_stats = get_course_stats_table()

    # disable buttons for large courses
    disable_buttons = False
    max_enrollment_for_buttons = settings.FEATURES.get("MAX_ENROLLMENT_INSTR_BUTTONS")
    if max_enrollment_for_buttons is not None:
        disable_buttons = enrollment_number > max_enrollment_for_buttons

    #----------------------------------------
    # context for rendering

    context = {
        'course': course,
        'staff_access': True,
        'admin_access': request.user.is_staff,
        'instructor_access': instructor_access,
        'forum_admin_access': forum_admin_access,
        'datatable': datatable,
        'course_stats': course_stats,
        'msg': msg,
        'modeflag': {idash_mode: 'selectedmode'},
        'studio_url': studio_url,

        'to_option': email_to_option,      # email
        'subject': email_subject,          # email
        'editor': email_editor,            # email
        'email_msg': email_msg,            # email
        'show_email_tab': show_email_tab,  # email
        'show_email_tab_free': show_email_tab_free,  # free-email

        'problems': problems,		# psychometrics
        'plots': plots,			# psychometrics
        'course_errors': modulestore().get_item_errors(course.location),
        'instructor_tasks': instructor_tasks,
        'offline_grade_log': offline_grades_available(course_id),
        'cohorts_ajax_url': reverse('cohorts', kwargs={'course_id': course_id}),

        'analytics_results': analytics_results,
        'disable_buttons': disable_buttons,
        'metrics_results': metrics_results,
    }

    if settings.FEATURES.get('ENABLE_INSTRUCTOR_BETA_DASHBOARD'):
        context['beta_dashboard_url'] = reverse('instructor_dashboard_2', kwargs={'course_id': course_id})

    return render_to_response('courseware/instructor_dashboard.html', context)



def _do_create_student(post_vars):
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

        if len(User.objects.filter(email=post_vars['email'])) > 0:
            js['value'] = _("An account with the Email '{email}' already exists.").format(email=post_vars['email'])
            js['field'] = 'email'

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

def rand_list(username):
    import random
    rand_list_number=[str(i) for i in range(0,10) ]
    rand_list_Letter=[chr(i) for i in range(97, 122) ]
    rand_list = rand_list_number+rand_list_Letter
    name=username
    for i in range(0,4):
        name = name + random.choice(rand_list)
    flag_email = User.objects.filter(username=name).exists()
    if flag_email:
        rand_list(username)
    return name


def students_filter(students):
    new_students, new_students_lc = get_and_clean_student_list(students)
    for student in new_students:
        post_vars = {}
        flag_email = User.objects.filter(email=student).exists()
        username =  str(re.split(r'[@]', student)[0])

        if not flag_email :
            post_vars['email']= student
            post_vars['username']= rand_list(username)
            post_vars['name']= str(re.split(r'[@]', student)[0])
            post_vars['password']='mooc'+str(re.split(r'[@]', student)[0])
            post_vars['gender']= ''
            post_vars['terms_of_service']= 'true'
            post_vars['year_of_birth']= ''
            post_vars['level_of_education']= ''
            post_vars['goals']= ''
            post_vars['honor_code']= 'true'
            post_vars['mailing_address']= ''

            try:
                validate_email(post_vars['email'])
            except ValidationError:
                js = {'success':False}
                js['no_register_email'] =_(" '{email}' email  format error").format(email=post_vars['email'])
                continue
            try:
                validate_slug(post_vars['username'])
            except ValidationError:
                js = {'success':False}
                js['no_register_email'] =_(" '{username}' format error.").format(username=post_vars['username'])
                continue
            ret=_do_create_student(post_vars)

            (user, profile, registration) = ret

            context = {
                'name': post_vars['name'],
                'key': registration.activation_key,
                'username': user.username,
                }

            print '----------------------debug-------------------------'
            print  context
            print  '----------------------finish--------------------------'
            # composes activation email
            subject = render_to_string('emails/activation_email_subject.txt', context)
            # Email subject *must not* contain newlines
            subject = ''.join(subject.splitlines())


            message = render_to_string('emails/activation_email.txt', context)

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
#                        send_mail(subject, message, from_address, [dest_addr], fail_silently=False)
                        send_mails(subject, "", from_address, [dest_addr], fail_silently=False, html=message)
                    else:
#                        user.email_user(subject, message, from_address)
                        send_mails(subject, "", from_address, [user.email], fail_silently=False, html=message)
                except Exception:  # pylint: disable=broad-except
                    log.warning('Unable to send activation email to user', exc_info=True)
                    js['value'] = _('Could not send activation e-mail.')
                    # What is the correct status code to use here? I think it's 500, because
                    # the problem is on the server's end -- but also, the account was created.
                    # Seems like the core part of the request was successful.
                    return JsonResponse(js, status=500)





def _do_remote_gradebook(user, course, action, args=None, files=None):
    '''
    Perform remote gradebook action.  Returns msg, datatable.
    '''
    rg = course.remote_gradebook
    if not rg:
        msg = _u("No remote gradebook defined in course metadata")
        return msg, {}

    rgurl = settings.FEATURES.get('REMOTE_GRADEBOOK_URL', '')
    if not rgurl:
        msg = _u("No remote gradebook url defined in settings.FEATURES")
        return msg, {}

    rgname = rg.get('name', '')
    if not rgname:
        msg = _u("No gradebook name defined in course remote_gradebook metadata")
        return msg, {}

    if args is None:
        args = {}
    data = dict(submit=action, gradebook=rgname, user=user.email)
    data.update(args)

    try:
        resp = requests.post(rgurl, data=data, verify=False, files=files)
        retdict = json.loads(resp.content)
    except Exception as err:
        msg = _u("Failed to communicate with gradebook server at {url}").format(url = rgurl) + "<br/>"
        msg += _u("Error: {err}").format(err = err)
        msg += "<br/>resp={resp}".format(resp = resp.content)
        msg += "<br/>data={data}".format(data = data)
        return msg, {}

    msg = '<pre>{msg}</pre>'.format(msg = retdict['msg'].replace('\n', '<br/>'))
    retdata = retdict['data']  	# a list of dicts

    if retdata:
        datatable = {'header': retdata[0].keys()}
        datatable['data'] = [x.values() for x in retdata]
        datatable['title'] = _u('Remote gradebook response for {action}').format(action = action)
        datatable['retdata'] = retdata
    else:
        datatable = {}

    return msg, datatable


def _list_course_forum_members(course_id, rolename, datatable):
    """
    Fills in datatable with forum membership information, for a given role,
    so that it will be displayed on instructor dashboard.

      course_ID = the ID string for a course
      rolename = one of "Administrator", "Moderator", "Community TA"

    Returns message status string to append to displayed message, if role is unknown.
    """
    # make sure datatable is set up properly for display first, before checking for errors
    datatable['header'] = [_u('Username'), _u('Full name'), _u('Roles')]
    datatable['title'] = _u('List of Forum {name}s in course {id}').format(name = rolename, id = course_id)
    datatable['data'] = []
    try:
        role = Role.objects.get(name=rolename, course_id=course_id)
    except Role.DoesNotExist:
        return '<font color="red">' + _u('Error: unknown rolename "{0}"').format(rolename) + '</font>'
    uset = role.users.all().order_by('username')
    msg = 'Role = {0}'.format(rolename)
    log.debug('role={0}'.format(rolename))
    datatable['data'] = [[x.username, x.profile.name, ', '.join([r.name for r in x.roles.filter(course_id=course_id).order_by('name')])] for x in uset]
    return msg


def _update_forum_role_membership(uname, course, rolename, add_or_remove):
    '''
    Supports adding a user to a course's forum role

      uname = username string for user
      course = course object
      rolename = one of "Administrator", "Moderator", "Community TA"
      add_or_remove = one of "add" or "remove"

    Returns message status string to append to displayed message,  Status is returned if user
    or role is unknown, or if entry already exists when adding, or if entry doesn't exist when removing.
    '''
    # check that username and rolename are valid:
    try:
        user = User.objects.get(username=uname)
    except User.DoesNotExist:
        return '<font color="red">' + _u('Error: unknown username "{0}"').format(uname) + '</font>'
    try:
        role = Role.objects.get(name=rolename, course_id=course.id)
    except Role.DoesNotExist:
        return '<font color="red">' + _u('Error: unknown rolename "{0}"').format(rolename) + '</font>'

    # check whether role already has the specified user:
    alreadyexists = role.users.filter(username=uname).exists()
    msg = ''
    log.debug('rolename={0}'.format(rolename))
    if add_or_remove == FORUM_ROLE_REMOVE:
        if not alreadyexists:
            msg = '<font color="red">' + _u('Error: user "{0}" does not have rolename "{1}", cannot remove').format(uname, rolename) + '</font>'
        else:
            user.roles.remove(role)
            msg = '<font color="green">' + _u('Removed "{0}" from "{1}" forum role = "{2}"').format(user, course.id, rolename) + '</font>'
    else:
        if alreadyexists:
            msg = '<font color="red">' + _u('Error: user "{0}" already has rolename "{1}", cannot add').format(uname, rolename) + '</font>'
        else:
            if (rolename == FORUM_ROLE_ADMINISTRATOR and not has_access(user, course, 'staff')):
                msg = '<font color="red">' + _u('Error: user "{0}" should first be added as staff before adding as a forum administrator, cannot add').format(uname) + '</font>'
            else:
                user.roles.add(role)
                msg = '<font color="green">' + _u('Added "{0}" to "{1}" forum role = "{2}"').format(user, course.id, rolename) + '</font>'

    return msg


def _role_members_table(role, title, course_id):
    """
    Return a data table of usernames and names of users in group_name.

    Arguments:
        role -- a student.roles.AccessRole
        title -- a descriptive title to show the user

    Returns:
        a dictionary with keys
        'header': ['Username', 'Full name'],
        'data': [[username, name] for all users]
        'title': "{title} in course {course}"
    """
    uset = role.users_with_role()
    datatable = {'header': [_u('Username'), _u('Full name')]}
    datatable['data'] = [[x.username, x.profile.name] for x in uset]
    datatable['title'] = _u('{0} in course {1}').format(title, course_id)
    return datatable


def _user_from_name_or_email(username_or_email):
    """
    Return the `django.contrib.auth.User` with the supplied username or email.

    If `username_or_email` contains an `@` it is treated as an email, otherwise
    it is treated as the username
    """
    username_or_email = strip_if_string(username_or_email)

    if '@' in username_or_email:
        return User.objects.get(email=username_or_email)
    else:
        return User.objects.get(username=username_or_email)


def add_user_to_role(request, username_or_email, role, group_title, event_name):
    """
    Look up the given user by username (if no '@') or email (otherwise), and add them to group.

    Arguments:
       request: django request--used for tracking log
       username_or_email: who to add.  Decide if it's an email by presense of an '@'
       group: A group name
       group_title: what to call this group in messages to user--e.g. "beta-testers".
       event_name: what to call this event when logging to tracking logs.

    Returns:
       html to insert in the message field
    """
    username_or_email = strip_if_string(username_or_email)
    try:
        user = _user_from_name_or_email(username_or_email)
    except User.DoesNotExist:
        return u'<font color="red">Error: unknown username or email "{0}"</font>'.format(username_or_email)

    role.add_users(user)

    # Deal with historical event names
    if event_name in ('staff', 'beta-tester'):
        track.views.server_track(
            request,
            "add-or-remove-user-group",
            {
                "event_name": event_name,
                "user": unicode(user),
                "event": "add"
            },
            page="idashboard"
        )
    else:
        track.views.server_track(request, "add-instructor", {"instructor": unicode(user)}, page="idashboard")

    return '<font color="green">Added {0} to {1}</font>'.format(user, group_title)


def remove_user_from_role(request, username_or_email, role, group_title, event_name):
    """
    Look up the given user by username (if no '@') or email (otherwise), and remove them from the supplied role.

    Arguments:
       request: django request--used for tracking log
       username_or_email: who to remove.  Decide if it's an email by presense of an '@'
       role: A student.roles.AccessRole
       group_title: what to call this group in messages to user--e.g. "beta-testers".
       event_name: what to call this event when logging to tracking logs.

    Returns:
       html to insert in the message field
    """

    username_or_email = strip_if_string(username_or_email)
    try:
        user = _user_from_name_or_email(username_or_email)
    except User.DoesNotExist:
        return u'<font color="red">Error: unknown username or email "{0}"</font>'.format(username_or_email)

    role.remove_users(user)

    # Deal with historical event names
    if event_name in ('staff', 'beta-tester'):
        track.views.server_track(
            request,
            "add-or-remove-user-group",
            {
                "event_name": event_name,
                "user": unicode(user),
                "event": "remove"
            },
            page="idashboard"
        )
    else:
        track.views.server_track(request, "remove-instructor", {"instructor": unicode(user)}, page="idashboard")

    return '<font color="green">Removed {0} from {1}</font>'.format(user, group_title)


def get_student_grade_summary_data(request, course, course_id, get_grades=True, get_raw_scores=False, use_offline=False):
    '''
    Return data arrays with student identity and grades for specified course.

    course = CourseDescriptor
    course_id = course ID

    Note: both are passed in, only because instructor_dashboard already has them already.

    returns datatable = dict(header=header, data=data)
    where

    header = list of strings labeling the data fields
    data = list (one per student) of lists of data corresponding to the fields

    If get_raw_scores=True, then instead of grade summaries, the raw grades for all graded modules are returned.

    '''
    enrolled_students = User.objects.filter(
        courseenrollment__course_id=course_id,
        courseenrollment__is_active=1,
    ).prefetch_related("groups").order_by('username')

    header = [_u('ID'), _u('Username'), _u('Full Name'), _u('edX email'), _u('External email')]
    assignments = []
    if get_grades and enrolled_students.count() > 0:
        # just to construct the header
        gradeset = student_grades(enrolled_students[0], request, course, keep_raw_scores=get_raw_scores, use_offline=use_offline)
        # log.debug('student {0} gradeset {1}'.format(enrolled_students[0], gradeset))
        if get_raw_scores:
            assignments += [score.section for score in gradeset['raw_scores']]
        else:
            assignments += [x['label'] for x in gradeset['section_breakdown']]
    header += assignments

    datatable = {'header': header, 'assignments': assignments, 'students': enrolled_students}
    data = []

    for student in enrolled_students:
        datarow = [student.id, student.username, student.profile.name, student.email]
        try:
            datarow.append(student.externalauthmap.external_email)
        except:  # ExternalAuthMap.DoesNotExist
            datarow.append('')

        if get_grades:
            gradeset = student_grades(student, request, course, keep_raw_scores=get_raw_scores, use_offline=use_offline)
            log.debug('student={0}, gradeset={1}'.format(student, gradeset))
            if get_raw_scores:
                # TODO (ichuang) encode Score as dict instead of as list, so score[0] -> score['earned']
                sgrades = [(getattr(score, 'earned', '') or score[0]) for score in gradeset['raw_scores']]
            else:
                sgrades = [x['percent'] for x in gradeset['section_breakdown']]
            datarow += sgrades
            student.grades = sgrades  	# store in student object

        data.append(datarow)
    datatable['data'] = data
    return datatable

#-----------------------------------------------------------------------------


@cache_control(no_cache=True, no_store=True, must_revalidate=True)
def gradebook(request, course_id):
    """
    Show the gradebook for this course:
    - only displayed to course staff
    - shows students who are enrolled.
    """
    course = get_course_with_access(request.user, course_id, 'staff', depth=None)

    enrolled_students = User.objects.filter(
        courseenrollment__course_id=course_id,
        courseenrollment__is_active=1
    ).order_by('username').select_related("profile")

    # TODO (vshnayder): implement pagination.
    enrolled_students = enrolled_students[:1000]   # HACK!

    student_info = [{'username': student.username,
                     'id': student.id,
                     'email': student.email,
                     'grade_summary': student_grades(student, request, course),
                     'realname': student.profile.name,
                     }
                    for student in enrolled_students]

    return render_to_response('courseware/gradebook.html', {
        'students': student_info,
        'course': course,
        'course_id': course_id,
        # Checked above
        'staff_access': True,
        'ordered_grades': sorted(course.grade_cutoffs.items(), key=lambda i: i[1], reverse=True),
    })


@cache_control(no_cache=True, no_store=True, must_revalidate=True)
def grade_summary(request, course_id):
    """Display the grade summary for a course."""
    course = get_course_with_access(request.user, course_id, 'staff')

    # For now, just a static page
    context = {'course': course,
               'staff_access': True, }
    return render_to_response('courseware/grade_summary.html', context)


#-----------------------------------------------------------------------------
# enrollment

def _do_enroll_students(course, course_id, students, overload=False, auto_enroll=False, email_students=False, is_shib_course=False):
    """
    Do the actual work of enrolling multiple students, presented as a string
    of emails separated by commas or returns
    `course` is course object
    `course_id` id of course (a `str`)
    `students` string of student emails separated by commas or returns (a `str`)
    `overload` un-enrolls all existing students (a `boolean`)
    `auto_enroll` is user input preference (a `boolean`)
    `email_students` is user input preference (a `boolean`)
    """

    new_students, new_students_lc = get_and_clean_student_list(students)
    status = dict([x, 'unprocessed'] for x in new_students)

    if overload:  	# delete all but staff
        todelete = CourseEnrollment.objects.filter(course_id=course_id)
        for ce in todelete:
            if not has_access(ce.user, course, 'staff') and ce.user.email.lower() not in new_students_lc:
                status[ce.user.email] = 'deleted'
                ce.deactivate()
            else:
                status[ce.user.email] = 'is staff'
        ceaset = CourseEnrollmentAllowed.objects.filter(course_id=course_id)
        for cea in ceaset:
            status[cea.email] = 'removed from pending enrollment list'
        ceaset.delete()

    if email_students:
        stripped_site_name = microsite.get_value(
            'SITE_NAME',
            settings.SITE_NAME
        )
        registration_url = 'https://' + stripped_site_name + reverse('student.views.register_user')
        #Composition of email
        d = {'site_name': stripped_site_name,
             'registration_url': registration_url,
             'course': course,
             'auto_enroll': auto_enroll,
             'course_url': 'https://' + stripped_site_name + '/courses/' + course_id,
             'course_about_url': 'https://' + stripped_site_name + '/courses/' + course_id + '/about',
             'is_shib_course': is_shib_course
             }

    for student in new_students:
        try:
            user = User.objects.get(email=student)
        except User.DoesNotExist:

            #Student not signed up yet, put in pending enrollment allowed table
            cea = CourseEnrollmentAllowed.objects.filter(email=student, course_id=course_id)

            #If enrollmentallowed already exists, update auto_enroll flag to however it was set in UI
            #Will be 0 or 1 records as there is a unique key on email + course_id
            if cea:
                cea[0].auto_enroll = auto_enroll
                cea[0].save()
                status[student] = 'user does not exist, enrollment already allowed, pending with auto enrollment ' \
                    + ('on' if auto_enroll else 'off')
                continue

            #EnrollmentAllowed doesn't exist so create it
            cea = CourseEnrollmentAllowed(email=student, course_id=course_id, auto_enroll=auto_enroll)
            cea.save()

            status[student] = 'user does not exist, enrollment allowed, pending with auto enrollment ' \
                + ('on' if auto_enroll else 'off')

            if email_students:
                #User is allowed to enroll but has not signed up yet
                d['email_addre  ss'] = student
                d['message'] = 'allowed_enroll'
                send_mail_ret = send_mail_to_student(student, d)
                status[student] += (', email sent' if send_mail_ret else '')
            continue

        #Student has already registered
        if CourseEnrollment.is_enrolled(user, course_id):
            status[student] = 'already enrolled'
            continue

        try:
            #Not enrolled yet
            ce = CourseEnrollment.enroll(user, course_id)
            status[student] = 'added'

            if email_students:
                #User enrolled for first time, populate dict with user specific info
                d['email_address'] = student
                d['full_name'] = user.profile.name
                d['message'] = 'enrolled_enroll'
                send_mail_ret = send_mail_to_student(student, d)
                status[student] += (', email sent' if send_mail_ret else '')

        except:
            status[student] = 'rejected'

    datatable = {'header': ['学生电子邮件', '活动']}
    datatable['data'] = [[x, status[x]] for x in sorted(status)]
    datatable['title'] = _u('学生注册情况')

    def sf(stat):
        return [x for x in status if status[x] == stat]

    data = dict(added=sf('added'), rejected=sf('rejected') + sf('exists'),
                deleted=sf('deleted'), datatable=datatable)

    return data


#Unenrollment
def _do_unenroll_students(course_id, students, email_students=False):
    """
    Do the actual work of un-enrolling multiple students, presented as a string
    of emails separated by commas or returns
    `course_id` is id of course (a `str`)
    `students` is string of student emails separated by commas or returns (a `str`)
    `email_students` is user input preference (a `boolean`)
    """

    old_students, _ = get_and_clean_student_list(students)
    status = dict([x, 'unprocessed'] for x in old_students)

    stripped_site_name = microsite.get_value(
        'SITE_NAME',
        settings.SITE_NAME
    )
    if email_students:
        course = course_from_id(course_id)
        #Composition of email
        d = {'site_name': stripped_site_name,
             'course': course}

    for student in old_students:

        isok = False
        cea = CourseEnrollmentAllowed.objects.filter(course_id=course_id, email=student)
        #Will be 0 or 1 records as there is a unique key on email + course_id
        if cea:
            cea[0].delete()
            status[student] = "un-enrolled"
            isok = True

        try:
            user = User.objects.get(email=student)
        except User.DoesNotExist:

            if isok and email_students:
                #User was allowed to join but had not signed up yet
                d['email_address'] = student
                d['message'] = 'allowed_unenroll'
                send_mail_ret = send_mail_to_student(student, d)
                status[student] += (', email sent' if send_mail_ret else '')

            continue

        #Will be 0 or 1 records as there is a unique key on user + course_id
        if CourseEnrollment.is_enrolled(user, course_id):
            try:
                CourseEnrollment.unenroll(user, course_id)
                status[student] = "un-enrolled"
                if email_students:
                    #User was enrolled
                    d['email_address'] = student
                    d['full_name'] = user.profile.name
                    d['message'] = 'enrolled_unenroll'
                    send_mail_ret = send_mail_to_student(student, d)
                    status[student] += (', email sent' if send_mail_ret else '')

            except Exception:
                if not isok:
                    status[student] = "Error!  Failed to un-enroll"

    datatable = {'header': ['学生电子邮件', '活动']}
    datatable['data'] = [[x, status[x]] for x in sorted(status)]
    datatable['title'] = _u('学生取消注册情况')

    data = dict(datatable=datatable)
    return data


def send_mail_to_student(student, param_dict):
    """
    Construct the email using templates and then send it.
    `student` is the student's email address (a `str`),

    `param_dict` is a `dict` with keys [
    `site_name`: name given to edX instance (a `str`)
    `registration_url`: url for registration (a `str`)
    `course_id`: id of course (a `str`)
    `auto_enroll`: user input option (a `str`)
    `course_url`: url of course (a `str`)
    `email_address`: email of student (a `str`)
    `full_name`: student full name (a `str`)
    `message`: type of email to send and template to use (a `str`)
    `is_shib_course`: (a `boolean`)
                                        ]
    Returns a boolean indicating whether the email was sent successfully.
    """

    # add some helpers and microconfig subsitutions
    if 'course' in param_dict:
        param_dict['course_name'] = param_dict['course'].display_name_with_default
    param_dict['site_name'] = microsite.get_value(
        'SITE_NAME',
        param_dict.get('site_name', '')
    )

    subject = None
    message = None

    message_type = param_dict['message']

    email_template_dict = {
        'allowed_enroll': ('emails/enroll_email_allowedsubject.txt', 'emails/enroll_email_allowedmessage.txt'),
        'enrolled_enroll': ('emails/enroll_email_enrolledsubject.txt', 'emails/enroll_email_enrolledmessage.txt'),
        'allowed_unenroll': ('emails/unenroll_email_subject.txt', 'emails/unenroll_email_allowedmessage.txt'),
        'enrolled_unenroll': ('emails/unenroll_email_subject.txt', 'emails/unenroll_email_enrolledmessage.txt'),
    }
    if  message_type=='enrolled_enroll':
        param_dict['course_url'] = param_dict['course_url'].replace('https','http')
    subject_template, message_template = email_template_dict.get(message_type, (None, None))

    if subject_template is not None and message_template is not None:
        subject = render_to_string(subject_template, param_dict)
        message = render_to_string(message_template, param_dict)

    if subject and message:
        # Remove leading and trailing whitespace from body
        message = message.strip()

        # Email subject *must not* contain newlines
        subject = ''.join(subject.splitlines())
        from_address = microsite.get_value(
            'email_from_address',
            settings.DEFAULT_FROM_EMAIL
        )

        send_mail(subject, message, from_address, [student], fail_silently=False)

        return True
    else:
        return False


def get_and_clean_student_list(students):
    """
    Separate out individual student email from the comma, or space separated string.
    `students` is string of student emails separated by commas or returns (a `str`)
    Returns:
    students: list of cleaned student emails
    students_lc: list of lower case cleaned student emails
    """

    students = split_by_comma_and_whitespace(students)
    students = [str(s.strip()) for s in students]
    students = [s for s in students if s != '']
    students_lc = [x.lower() for x in students]

    return students, students_lc

#-----------------------------------------------------------------------------
# answer distribution


def get_answers_distribution(request, course_id):
    """
    Get the distribution of answers for all graded problems in the course.

    Return a dict with two keys:
    'header': a header row
    'data': a list of rows
    """
    course = get_course_with_access(request.user, course_id, 'staff')

    dist = grades.answer_distributions(course.id)

    d = {}
    d['header'] = ['url_name', 'display name', 'answer id', 'answer', 'count']

    d['data'] = [
        [url_name, display_name, answer_id, a, answers[a]]
        for (url_name, display_name, answer_id), answers in sorted(dist.items())
        for a in answers
    ]
    return d


#-----------------------------------------------------------------------------


def compute_course_stats(course):
    """
    Compute course statistics, including number of problems, videos, html.

    course is a CourseDescriptor from the xmodule system.
    """

    # walk the course by using get_children() until we come to the leaves; count the
    # number of different leaf types

    counts = defaultdict(int)

    def walk(module):
        children = module.get_children()
        category = module.__class__.__name__ 	# HtmlDescriptor, CapaDescriptor, ...
        counts[category] += 1
        for c in children:
            walk(c)

    walk(course)
    stats = dict(counts)  	# number of each kind of module
    return stats


def dump_grading_context(course):
    """
    Dump information about course grading context (eg which problems are graded in what assignments)
    Very useful for debugging grading_policy.json and policy.json
    """
    msg = "-----------------------------------------------------------------------------\n"
    msg += "Course grader:\n"

    msg += '%s\n' % course.grader.__class__
    graders = {}
    if isinstance(course.grader, xmgraders.WeightedSubsectionsGrader):
        msg += '\n'
        msg += "Graded sections:\n"
        for subgrader, category, weight in course.grader.sections:
            msg += "  subgrader=%s, type=%s, category=%s, weight=%s\n" % (subgrader.__class__, subgrader.type, category, weight)
            subgrader.index = 1
            graders[subgrader.type] = subgrader
    msg += "-----------------------------------------------------------------------------\n"
    msg += "Listing grading context for course %s\n" % course.id

    gc = course.grading_context
    msg += "graded sections:\n"

    msg += '%s\n' % gc['graded_sections'].keys()
    for (gs, gsvals) in gc['graded_sections'].items():
        msg += "--> Section %s:\n" % (gs)
        for sec in gsvals:
            s = sec['section_descriptor']
            grade_format = getattr(s, 'grade_format', None)
            aname = ''
            if grade_format in graders:
                g = graders[grade_format]
                aname = '%s %02d' % (g.short_label, g.index)
                g.index += 1
            elif s.display_name in graders:
                g = graders[s.display_name]
                aname = '%s' % g.short_label
            notes = ''
            if getattr(s, 'score_by_attempt', False):
                notes = ', score by attempt!'
            msg += "      %s (grade_format=%s, Assignment=%s%s)\n" % (s.display_name, grade_format, aname, notes)
    msg += "all descriptors:\n"
    msg += "length=%d\n" % len(gc['all_descriptors'])
    msg = '<pre>%s</pre>' % msg.replace('<', '&lt;')
    return msg


def get_background_task_table(course_id, problem_url=None, student=None, task_type=None):
    """
    Construct the "datatable" structure to represent background task history.

    Filters the background task history to the specified course and problem.
    If a student is provided, filters to only those tasks for which that student
    was specified.

    Returns a tuple of (msg, datatable), where the msg is a possible error message,
    and the datatable is the datatable to be used for display.
    """
    history_entries = get_instructor_task_history(course_id, problem_url, student, task_type)
    datatable = {}
    msg = ""
    # first check to see if there is any history at all
    # (note that we don't have to check that the arguments are valid; it
    # just won't find any entries.)
    if (history_entries.count()) == 0:
        if problem_url is None:
            msg += '<font color="red">Failed to find any background tasks for course "{course}".</font>'.format(course=course_id)
        elif student is not None:
            template = '<font color="red">' + _u('Failed to find any background tasks for course "{course}", module "{problem}" and student "{student}".') + '</font>'
            msg += template.format(course=course_id, problem=problem_url, student=student.username)
        else:
            msg += '<font color="red">' + _u('Failed to find any background tasks for course "{course}" and module "{problem}".').format(course=course_id, problem=problem_url) + '</font>'
    else:
        datatable['header'] = ["Task Type",
                               "Task Id",
                               "Requester",
                               "Submitted",
                               "Duration (sec)",
                               "Task State",
                               "Task Status",
                               "Task Output"]

        datatable['data'] = []
        for instructor_task in history_entries:
            # get duration info, if known:
            duration_sec = 'unknown'
            if hasattr(instructor_task, 'task_output') and instructor_task.task_output is not None:
                task_output = json.loads(instructor_task.task_output)
                if 'duration_ms' in task_output:
                    duration_sec = int(task_output['duration_ms'] / 1000.0)
            # get progress status message:
            success, task_message = get_task_completion_info(instructor_task)
            status = "Complete" if success else "Incomplete"
            # generate row for this task:
            row = [
                str(instructor_task.task_type),
                str(instructor_task.task_id),
                str(instructor_task.requester),
                instructor_task.created.isoformat(' '),
                duration_sec,
                str(instructor_task.task_state),
                status,
                task_message
            ]
            datatable['data'].append(row)

        if problem_url is None:
            datatable['title'] = "{course_id}".format(course_id=course_id)
        elif student is not None:
            datatable['title'] = "{course_id} > {location} > {student}".format(course_id=course_id,
                                                                               location=problem_url,
                                                                               student=student.username)
        else:
            datatable['title'] = "{course_id} > {location}".format(course_id=course_id, location=problem_url)

    return msg, datatable


def uses_shib(course):
    """
    Used to return whether course has Shibboleth as the enrollment domain

    Returns a boolean indicating if Shibboleth authentication is set for this course.
    """
    return course.enrollment_domain and course.enrollment_domain.startswith(SHIBBOLETH_DOMAIN_PREFIX)
