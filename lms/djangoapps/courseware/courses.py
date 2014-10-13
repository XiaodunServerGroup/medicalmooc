from collections import defaultdict
from fs.errors import ResourceNotFoundError
import logging
import inspect

from path import path
from django.http import Http404
from django.conf import settings
from .module_render import get_module
from xmodule.course_module import CourseDescriptor
from xmodule.modulestore import Location, XML_MODULESTORE_TYPE
from xmodule.modulestore.django import modulestore, loc_mapper
from xmodule.contentstore.content import StaticContent
from xmodule.modulestore.exceptions import ItemNotFoundError, InvalidLocationError
from courseware.model_data import FieldDataCache
from static_replace import replace_static_urls
from courseware.access import has_access
import branding

log = logging.getLogger(__name__)


def get_request_for_thread():
    """Walk up the stack, return the nearest first argument named "request"."""
    frame = None
    try:
        for f in inspect.stack()[1:]:
            frame = f[0]
            code = frame.f_code
            if code.co_varnames[:1] == ("request",):
                return frame.f_locals["request"]
            elif code.co_varnames[:2] == ("self", "request",):
                return frame.f_locals["request"]
    finally:
        del frame


def get_course(course_id, depth=0):
    """
    Given a course id, return the corresponding course descriptor.

    If course_id is not valid, raises a ValueError.  This is appropriate
    for internal use.

    depth: The number of levels of children for the modulestore to cache.
    None means infinite depth.  Default is to fetch no children.
    """
    try:
        course_loc = CourseDescriptor.id_to_location(course_id)
        return modulestore().get_instance(course_id, course_loc, depth=depth)
    except (KeyError, ItemNotFoundError):
        raise ValueError("Course not found: {}".format(course_id))
    except InvalidLocationError:
        raise ValueError("Invalid location: {}".format(course_id))


def get_course_by_id(course_id, depth=0):
    """
    Given a course id, return the corresponding course descriptor.

    If course_id is not valid, raises a 404.

    depth: The number of levels of children for the modulestore to cache. None means infinite depth
    """
    try:
        course_loc = CourseDescriptor.id_to_location(course_id)
        return modulestore().get_instance(course_id, course_loc, depth=depth)
    except (KeyError, ItemNotFoundError):
        raise Http404("Course not found.")
    except InvalidLocationError:
        raise Http404("Invalid location")


def get_course_with_access(user, course_id, action, depth=0):
    """
    Given a course_id, look up the corresponding course descriptor,
    check that the user has the access to perform the specified action
    on the course, and return the descriptor.

    Raises a 404 if the course_id is invalid, or the user doesn't have access.

    depth: The number of levels of children for the modulestore to cache. None means infinite depth
    """
    course = get_course_by_id(course_id, depth=depth)
    if not has_access(user, course, action):
        # Deliberately return a non-specific error message to avoid
        # leaking info about access control settings
        raise Http404("Course not found.")
    return course


def get_opt_course_with_access(user, course_id, action):
    """
    Same as get_course_with_access, except that if course_id is None,
    return None without performing any access checks.
    """
    if course_id is None:
        return None
    return get_course_with_access(user, course_id, action)


def course_image_url(course):
    """Try to look up the image url for the course.  If it's not found,
    log an error and return the dead link"""
    if course.static_asset_path or modulestore().get_modulestore_type(course.location.course_id) == XML_MODULESTORE_TYPE:
        return '/static/' + (course.static_asset_path or getattr(course, 'data_dir', '')) + "/images/course_image.jpg"
    else:
        loc = StaticContent.compute_location(course.location.org, course.location.course, course.course_image)
        _path = StaticContent.get_url_path_from_location(loc)
        return _path


def find_file(filesystem, dirs, filename):
    """
    Looks for a filename in a list of dirs on a filesystem, in the specified order.

    filesystem: an OSFS filesystem
    dirs: a list of path objects
    filename: a string

    Returns d / filename if found in dir d, else raises ResourceNotFoundError.
    """
    for directory in dirs:
        filepath = path(directory) / filename
        if filesystem.exists(filepath):
            return filepath
    raise ResourceNotFoundError("Could not find {0}".format(filename))


def get_course_about_section(course, section_key):
    """
    This returns the snippet of html to be rendered on the course about page,
    given the key for the section.

    Valid keys:
    - overview
    - title
    - university
    - number
    - short_description
    - description
    - key_dates (includes start, end, exams, etc)
    - video
    - course_staff_short
    - course_staff_extended
    - requirements
    - syllabus
    - textbook
    - faq
    - more_info
    - ocw_links
    """

    # Many of these are stored as html files instead of some semantic
    # markup. This can change without effecting this interface when we find a
    # good format for defining so many snippets of text/html.

# TODO: Remove number, instructors from this list
    if section_key in ['short_description', 'description', 'key_dates', 'video',
                       'course_staff_short', 'course_staff_extended',
                       'requirements', 'syllabus', 'textbook', 'faq', 'more_info',
                       'number', 'instructors', 'overview',
                       'effort', 'end_date', 'prerequisites', 'ocw_links']:

        try:

            request = get_request_for_thread()

            loc = course.location.replace(category='about', name=section_key)

            # Use an empty cache
            field_data_cache = FieldDataCache([], course.id, request.user)
            about_module = get_module(
                request.user,
                request,
                loc,
                field_data_cache,
                course.id,
                not_found_ok=True,
                wrap_xmodule_display=False,
                static_asset_path=course.static_asset_path
            )

            html = ''

            if about_module is not None:
                html = about_module.render('student_view').content

            return html

        except ItemNotFoundError:
            log.warning("Missing about section {key} in course {url}".format(
                key=section_key, url=course.location.url()))
            return None
    elif section_key == "title":
        return course.display_name_with_default
    elif section_key == "university":
        return course.display_org_with_default
    elif section_key == "number":
        return course.display_number_with_default

    raise KeyError("Invalid about key " + str(section_key))


def get_course_info_section(request, course, section_key):
    """
    This returns the snippet of html to be rendered on the course info page,
    given the key for the section.

    Valid keys:
    - handouts
    - guest_handouts
    - updates
    - guest_updates
    """
    loc = Location(course.location.tag, course.location.org, course.location.course, 'course_info', section_key)

    # Use an empty cache
    field_data_cache = FieldDataCache([], course.id, request.user)
    info_module = get_module(
        request.user,
        request,
        loc,
        field_data_cache,
        course.id,
        wrap_xmodule_display=False,
        static_asset_path=course.static_asset_path
    )

    html = ''

    if info_module is not None:
        html = info_module.render('student_view').content

    return html


# TODO: Fix this such that these are pulled in as extra course-specific tabs.
#       arjun will address this by the end of October if no one does so prior to
#       then.
def get_course_syllabus_section(course, section_key):
    """
    This returns the snippet of html to be rendered on the syllabus page,
    given the key for the section.

    Valid keys:
    - syllabus
    - guest_syllabus
    """

    # Many of these are stored as html files instead of some semantic
    # markup. This can change without effecting this interface when we find a
    # good format for defining so many snippets of text/html.

    if section_key in ['syllabus', 'guest_syllabus']:
        try:
            filesys = course.system.resources_fs
            # first look for a run-specific version
            dirs = [path("syllabus") / course.url_name, path("syllabus")]
            filepath = find_file(filesys, dirs, section_key + ".html")
            with filesys.open(filepath) as html_file:
                return replace_static_urls(
                    html_file.read().decode('utf-8'),
                    getattr(course, 'data_dir', None),
                    course_id=course.location.course_id,
                    static_asset_path=course.static_asset_path,
                )
        except ResourceNotFoundError:
            log.exception("Missing syllabus section {key} in course {url}".format(
                key=section_key, url=course.location.url()))
            return "! Syllabus missing !"

    raise KeyError("Invalid about key " + str(section_key))


def get_courses_by_university(user, domain=None):
    '''
    Returns dict of lists of courses available, keyed by course.org (ie university).
    Courses are sorted by course.number.
    '''
    # TODO: Clean up how 'error' is done.
    # filter out any courses that errored.
    visible_courses = get_courses(user, domain)

    universities = defaultdict(list)
    for course in visible_courses:
        universities[course.org].append(course)

    return universities


def get_courses(user, domain=None):
    '''
    Returns a list of courses available, sorted by course.number
    '''
    courses = branding.get_visible_courses()
    courses = [c for c in courses if has_access(user, c, 'see_exists')]

    courses = sorted(courses, key=lambda course: course.number)

    return courses

def get_courses_by_search(domain=None):
    '''
    Returns a list of courses available, sorted by course.number
    '''
    courses = branding.get_visible_courses()
   # courses = [c for c in courses if has_access(user, c, 'see_exists')]

    courses = sorted(courses, key=lambda course: course.number)

    return courses


def sort_by_announcement(courses):
    """
    Sorts a list of courses by their announcement date. If the date is
    not available, sort them by their start date.
    """

    # Sort courses by how far are they from they start day
    key = lambda course: course.sorting_score
    courses = sorted(courses, key=key)

    return courses


def filter_audited_items(courses):
    """
    get courses audited
    """

    courses_list = []
    for course in courses:
        if course.course_audit == 1:
            courses_list.append(course)

    return courses_list


def sort_and_audited_items(courses):
    """
    sort and audited courses
    """
    return filter_audited_items(sort_by_announcement(courses))


def get_cms_course_link(course):
    """
    Returns a link to course_index for editing the course in cms,
    assuming that the course is actually cms-backed.
    """
    locator = loc_mapper().translate_location(
        course.location.course_id, course.location, False, True
    )
    return "//" + settings.CMS_BASE + locator.url_reverse('course/', '')

