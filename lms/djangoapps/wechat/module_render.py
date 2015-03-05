import json
import logging
import mimetypes

import static_replace

from functools import partial
from requests.auth import HTTPBasicAuth
from dogapi import dog_stats_api

from django.conf import settings
from django.contrib.auth.models import User
from django.core.cache import cache
from django.core.exceptions import PermissionDenied
from django.core.urlresolvers import reverse
from django.http import Http404, HttpResponse
from django.views.decorators.csrf import csrf_exempt

from capa.xqueue_interface import XQueueInterface
from courseware.access import has_access, get_user_role
from courseware.masquerade import setup_masquerade
from courseware.model_data import FieldDataCache, DjangoKeyValueStore
from lms.lib.xblock.field_data import LmsFieldData
from lms.lib.xblock.runtime import LmsModuleSystem, unquote_slashes
from edxmako.shortcuts import render_to_string
from eventtracking import tracker
from psychometrics.psychoanalyze import make_psychometrics_data_update_handler
from student.models import anonymous_id_for_user, user_by_anonymous_id
from xblock.core import XBlock
from xblock.fields import Scope
from xblock.runtime import KvsFieldData, KeyValueStore
from xblock.exceptions import NoSuchHandlerError
from xblock.django.request import django_to_webob_request, webob_to_django_response
from xmodule.error_module import ErrorDescriptor, NonStaffErrorDescriptor
from xmodule.exceptions import NotFoundError, ProcessingError
from xmodule.modulestore import Location
from xmodule.modulestore.django import modulestore, ModuleI18nService
from xmodule.modulestore.exceptions import ItemNotFoundError
from xmodule.util.duedate import get_extended_due_date
from xmodule_modifiers import replace_course_urls, replace_jump_to_id_urls, replace_static_urls, add_staff_debug_info, wrap_xblock
from xmodule.lti_module import LTIModule
from xmodule.x_module import XModuleDescriptor

from util.json_request import JsonResponse
from util.sandboxing import can_execute_unsafe_code


log = logging.getLogger(__name__)


if settings.XQUEUE_INTERFACE.get('basic_auth') is not None:
    requests_auth = HTTPBasicAuth(*settings.XQUEUE_INTERFACE['basic_auth'])
else:
    requests_auth = None

xqueue_interface = XQueueInterface(
    settings.XQUEUE_INTERFACE['url'],
    settings.XQUEUE_INTERFACE['django_auth'],
    requests_auth,
)


def make_track_function(request):
    '''
    Make a tracking function that logs what happened.
    For use in ModuleSystem.
    '''
    import track.views

    def function(event_type, event):
        return track.views.server_track(request, event_type, event, page='x_module')
    return function


def toc_for_course(user, request, course, active_chapter, active_section, field_data_cache):
    '''
    Create a table of contents from the module store

    Return format:
    [ {'display_name': name, 'url_name': url_name,
       'sections': SECTIONS, 'active': bool}, ... ]

    where SECTIONS is a list
    [ {'display_name': name, 'url_name': url_name,
       'format': format, 'due': due, 'active' : bool, 'graded': bool}, ...]

    active is set for the section and chapter corresponding to the passed
    parameters, which are expected to be url_names of the chapter+section.
    Everything else comes from the xml, or defaults to "".

    chapters with name 'hidden' are skipped.

    NOTE: assumes that if we got this far, user has access to course.  Returns
    None if this is not the case.

    field_data_cache must include data from the course module and 2 levels of its descendents
    '''

    course_module = get_module_for_descriptor(user, request, course, field_data_cache, course.id)
    if course_module is None:
        return None

    chapters = list()
    for chapter in course_module.get_display_items():
        if chapter.hide_from_toc:
            continue

        sections = list()
        for section in chapter.get_display_items():

            active = (chapter.url_name == active_chapter and
                      section.url_name == active_section)

            if not section.hide_from_toc:
                sections.append({'display_name': section.display_name_with_default,
                                 'url_name': section.url_name,
                                 'format': section.format if section.format is not None else '',
                                 'due': get_extended_due_date(section),
                                 'active': active,
                                 'graded': section.graded,
                                 })

        chapters.append({'display_name': chapter.display_name_with_default,
                         'url_name': chapter.url_name,
                         'sections': sections,
                         'active': chapter.url_name == active_chapter})
    return chapters

def mobi_toc_for_course(user, request, course, active_chapter=None, active_section=None, field_data_cache=None):

    course_module = get_module_for_descriptor(user, request, course, field_data_cache, course.id)
    if course_module is None:
        return None
    show_url = list()
    chapters = list()
    for chapter in course_module.get_display_items():
        chapter_descriptor = course.get_child_by(lambda m: m.url_name == chapter.url_name)
        chapter_module = course_module.get_child_by(lambda m: m.url_name == chapter.url_name)
        sections = list()
        for section in chapter_module.get_display_items():
            i = 0
            section_descriptor = chapter_descriptor.get_child_by(lambda m: m.url_name == section.url_name)

            section_descriptor = modulestore().get_instance(course.id, section_descriptor.location, depth=None)

            section_field_data_cache = FieldDataCache.cache_for_descriptor_descendents(
                course.id, user, section_descriptor, depth=None)

            section_module = get_module_for_descriptor(request.user,
                request,
                section_descriptor,
                section_field_data_cache,
                course.id,
                i
            )

            units = list()
            j = len(section_module.get_display_items())-1
            for unit in section_module.get_display_items():
                for child in unit.get_display_items():
                    if child.get_icon_class()=='video':
                        if child.source:
                            show_url.append(child.source)
                        elif child.html5_sources:
                            show_url.append(child.html5_sources[0])
                units.append({'display_name': unit.display_name_with_default,
                              'location': j,
                              'type': unit.get_icon_class()})
                j = j-1
            sections.append({'display_name': section.display_name_with_default,
                             'url_name': section.url_name,
                             'format': section.format if section.format is not None else '',
                             'due': get_extended_due_date(section),
                             'active': False,
                             'graded': section.graded,
                             'units': units
                            })
        chapters.append({'display_name': chapter.display_name_with_default,
                         'url_name': chapter.url_name,
                         'sections': sections,
                         'show_url': show_url})
    return chapters



def get_module(user, request, location, field_data_cache, course_id,
               position=None, not_found_ok=False, wrap_xmodule_display=True,
               grade_bucket_type=None, depth=0,
               static_asset_path=''):
    """
    Get an instance of the xmodule class identified by location,
    setting the state based on an existing StudentModule, or creating one if none
    exists.

    Arguments:
      - user                  : User for whom we're getting the module
      - request               : current django HTTPrequest.  Note: request.user isn't used for anything--all auth
                                and such works based on user.
      - location              : A Location-like object identifying the module to load
      - field_data_cache      : a FieldDataCache
      - course_id             : the course_id in the context of which to load module
      - position              : extra information from URL for user-specified
                                position within module
      - depth                 : number of levels of descendents to cache when loading this module.
                                None means cache all descendents
      - static_asset_path     : static asset path to use (overrides descriptor's value); needed
                                by get_course_info_section, because info section modules
                                do not have a course as the parent module, and thus do not
                                inherit this lms key value.

    Returns: xmodule instance, or None if the user does not have access to the
    module.  If there's an error, will try to return an instance of ErrorModule
    if possible.  If not possible, return None.
    """
    try:
        location = Location(location)
        descriptor = modulestore().get_instance(course_id, location, depth=depth)
        return get_module_for_descriptor(user, request, descriptor, field_data_cache, course_id,
                                         position=position,
                                         wrap_xmodule_display=wrap_xmodule_display,
                                         grade_bucket_type=grade_bucket_type,
                                         static_asset_path=static_asset_path)
    except ItemNotFoundError:
        if not not_found_ok:
            log.exception("Error in get_module")
        return None
    except:
        # Something has gone terribly wrong, but still not letting it turn into a 500.
        log.exception("Error in get_module")
        return None


def get_xqueue_callback_url_prefix(request):
    """
    Calculates default prefix based on request, but allows override via settings

    This is separated from get_module_for_descriptor so that it can be called
    by the LMS before submitting background tasks to run.  The xqueue callbacks
    should go back to the LMS, not to the worker.
    """
    prefix = '{proto}://{host}'.format(
        proto=request.META.get('HTTP_X_FORWARDED_PROTO', 'https' if request.is_secure() else 'http'),
        host=request.get_host()
    )
    return settings.XQUEUE_INTERFACE.get('callback_url', prefix)


def get_module_for_descriptor(user, request, descriptor, field_data_cache, course_id,
                              position=None, wrap_xmodule_display=True, grade_bucket_type=None,
                              static_asset_path=''):
    """
    Implements get_module, extracting out the request-specific functionality.

    See get_module() docstring for further details.
    """
    # allow course staff to masquerade as student
    if has_access(user, descriptor, 'staff', course_id):
        setup_masquerade(request, True)

    track_function = make_track_function(request)
    xqueue_callback_url_prefix = get_xqueue_callback_url_prefix(request)

    return get_module_for_descriptor_internal(user, descriptor, field_data_cache, course_id,
                                              track_function, xqueue_callback_url_prefix,
                                              position, wrap_xmodule_display, grade_bucket_type,
                                              static_asset_path)


def get_module_for_descriptor_internal(user, descriptor, field_data_cache, course_id,
                                       track_function, xqueue_callback_url_prefix,
                                       position=None, wrap_xmodule_display=True, grade_bucket_type=None,
                                       static_asset_path=''):
    """
    Actually implement get_module, without requiring a request.

    See get_module() docstring for further details.
    """

    # Do not check access when it's a noauth request.
    if getattr(user, 'known', True):
        # Short circuit--if the user shouldn't have access, bail without doing any work
        if not has_access(user, descriptor, 'load', course_id):
            return None

    student_data = KvsFieldData(DjangoKeyValueStore(field_data_cache))


    def make_xqueue_callback(dispatch='score_update'):
        # Fully qualified callback URL for external queueing system
        relative_xqueue_callback_url = reverse(
            'xqueue_callback',
            kwargs=dict(
                course_id=course_id,
                userid=str(user.id),
                mod_id=descriptor.location.url(),
                dispatch=dispatch
            ),
        )
        return xqueue_callback_url_prefix + relative_xqueue_callback_url

    # Default queuename is course-specific and is derived from the course that
    #   contains the current module.
    # TODO: Queuename should be derived from 'course_settings.json' of each course
    xqueue_default_queuename = descriptor.location.org + '-' + descriptor.location.course

    xqueue = {
        'interface': xqueue_interface,
        'construct_callback': make_xqueue_callback,
        'default_queuename': xqueue_default_queuename.replace(' ', '_'),
        'waittime': settings.XQUEUE_WAITTIME_BETWEEN_REQUESTS
    }

    # This is a hacky way to pass settings to the combined open ended xmodule
    # It needs an S3 interface to upload images to S3
    # It needs the open ended grading interface in order to get peer grading to be done
    # this first checks to see if the descriptor is the correct one, and only sends settings if it is

    # Get descriptor metadata fields indicating needs for various settings
    needs_open_ended_interface = getattr(descriptor, "needs_open_ended_interface", False)
    needs_s3_interface = getattr(descriptor, "needs_s3_interface", False)

    # Initialize interfaces to None
    open_ended_grading_interface = None
    s3_interface = None

    # Create interfaces if needed
    if needs_open_ended_interface:
        open_ended_grading_interface = settings.OPEN_ENDED_GRADING_INTERFACE
        open_ended_grading_interface['mock_peer_grading'] = settings.MOCK_PEER_GRADING
        open_ended_grading_interface['mock_staff_grading'] = settings.MOCK_STAFF_GRADING
    if needs_s3_interface:
        s3_interface = {
            'access_key': getattr(settings, 'AWS_ACCESS_KEY_ID', ''),
            'secret_access_key': getattr(settings, 'AWS_SECRET_ACCESS_KEY', ''),
            'storage_bucket_name': getattr(settings, 'AWS_STORAGE_BUCKET_NAME', 'openended')
        }

    def inner_get_module(descriptor):
        """
        Delegate to get_module_for_descriptor_internal() with all values except `descriptor` set.

        Because it does an access check, it may return None.
        """
        # TODO: fix this so that make_xqueue_callback uses the descriptor passed into
        # inner_get_module, not the parent's callback.  Add it as an argument....
        return get_module_for_descriptor_internal(user, descriptor, field_data_cache, course_id,
                                                  track_function, make_xqueue_callback,
                                                  position, wrap_xmodule_display, grade_bucket_type,
                                                  static_asset_path)

    def publish(block, event, custom_user=None):
        """A function that allows XModules to publish events. This only supports grade changes right now."""
        if event.get('event_name') != 'grade':
            return

        if custom_user:
            user_id = custom_user.id
        else:
            user_id = user.id

        # Construct the key for the module
        key = KeyValueStore.Key(
            scope=Scope.user_state,
            user_id=user_id,
            block_scope_id=descriptor.location,
            field_name='grade'
        )

        student_module = field_data_cache.find_or_create(key)
        # Update the grades
        student_module.grade = event.get('value')
        student_module.max_grade = event.get('max_value')
        # Save all changes to the underlying KeyValueStore
        student_module.save()

        # Bin score into range and increment stats
        score_bucket = get_score_bucket(student_module.grade, student_module.max_grade)
        course_id_dict = Location.parse_course_id(course_id)

        tags = [
            u"org:{org}".format(**course_id_dict),
            u"course:{course}".format(**course_id_dict),
            u"run:{name}".format(**course_id_dict),
            u"score_bucket:{0}".format(score_bucket)
        ]

        if grade_bucket_type is not None:
            tags.append('type:%s' % grade_bucket_type)

        dog_stats_api.increment("lms.courseware.question_answered", tags=tags)

    # Build a list of wrapping functions that will be applied in order
    # to the Fragment content coming out of the xblocks that are about to be rendered.
    block_wrappers = []

    # Wrap the output display in a single div to allow for the XModule
    # javascript to be bound correctly
    if wrap_xmodule_display is True:
        block_wrappers.append(partial(wrap_xblock, 'LmsRuntime', extra_data={'course-id': course_id}))

    # TODO (cpennington): When modules are shared between courses, the static
    # prefix is going to have to be specific to the module, not the directory
    # that the xml was loaded from

    # Rewrite urls beginning in /static to point to course-specific content
    block_wrappers.append(partial(
        replace_static_urls,
        getattr(descriptor, 'data_dir', None),
        course_id=course_id,
        static_asset_path=static_asset_path or descriptor.static_asset_path
    ))

    # Allow URLs of the form '/course/' refer to the root of multicourse directory
    #   hierarchy of this course
    block_wrappers.append(partial(replace_course_urls, course_id))

    # this will rewrite intra-courseware links (/jump_to_id/<id>). This format
    # is an improvement over the /course/... format for studio authored courses,
    # because it is agnostic to course-hierarchy.
    # NOTE: module_id is empty string here. The 'module_id' will get assigned in the replacement
    # function, we just need to specify something to get the reverse() to work.
    block_wrappers.append(partial(
        replace_jump_to_id_urls,
        course_id,
        reverse('jump_to_id', kwargs={'course_id': course_id, 'module_id': ''}),
    ))

    if settings.FEATURES.get('DISPLAY_DEBUG_INFO_TO_STAFF'):
        if has_access(user, descriptor, 'staff', course_id):
            block_wrappers.append(partial(add_staff_debug_info, user))

    # These modules store data using the anonymous_student_id as a key.
    # To prevent loss of data, we will continue to provide old modules with
    # the per-student anonymized id (as we have in the past),
    # while giving selected modules a per-course anonymized id.
    # As we have the time to manually test more modules, we can add to the list
    # of modules that get the per-course anonymized id.
    is_pure_xblock = isinstance(descriptor, XBlock) and not isinstance(descriptor, XModuleDescriptor)
    module_class = getattr(descriptor, 'module_class', None)
    is_lti_module = not is_pure_xblock and issubclass(module_class, LTIModule)
    if is_pure_xblock or is_lti_module:
        anonymous_student_id = anonymous_id_for_user(user, course_id)
    else:
        anonymous_student_id = anonymous_id_for_user(user, '')

    system = LmsModuleSystem(
        track_function=track_function,
        render_template=render_to_string,
        static_url=settings.STATIC_URL,
        xqueue=xqueue,
        # TODO (cpennington): Figure out how to share info between systems
        filestore=descriptor.runtime.resources_fs,
        get_module=inner_get_module,
        user=user,
        debug=settings.DEBUG,
        hostname=settings.SITE_NAME,
        # TODO (cpennington): This should be removed when all html from
        # a module is coming through get_html and is therefore covered
        # by the replace_static_urls code below
        replace_urls=partial(
            static_replace.replace_static_urls,
            data_directory=getattr(descriptor, 'data_dir', None),
            course_id=course_id,
            static_asset_path=static_asset_path or descriptor.static_asset_path,
        ),
        replace_course_urls=partial(
            static_replace.replace_course_urls,
            course_id=course_id
        ),
        replace_jump_to_id_urls=partial(
            static_replace.replace_jump_to_id_urls,
            course_id=course_id,
            jump_to_id_base_url=reverse('jump_to_id', kwargs={'course_id': course_id, 'module_id': ''})
        ),
        node_path=settings.NODE_PATH,
        publish=publish,
        anonymous_student_id=anonymous_student_id,
        course_id=course_id,
        open_ended_grading_interface=open_ended_grading_interface,
        s3_interface=s3_interface,
        cache=cache,
        can_execute_unsafe_code=(lambda: can_execute_unsafe_code(course_id)),
        # TODO: When we merge the descriptor and module systems, we can stop reaching into the mixologist (cpennington)
        mixins=descriptor.runtime.mixologist._mixins,  # pylint: disable=protected-access
        wrappers=block_wrappers,
        get_real_user=user_by_anonymous_id,
        services={
            'i18n': ModuleI18nService(),
        },
        get_user_role=lambda: get_user_role(user, course_id),
        descriptor_runtime=descriptor.runtime,
    )

    # pass position specified in URL to module through ModuleSystem
    system.set('position', position)
    if settings.FEATURES.get('ENABLE_PSYCHOMETRICS'):
        system.set(
            'psychometrics_handler',  # set callback for updating PsychometricsData
            make_psychometrics_data_update_handler(course_id, user, descriptor.location.url())
        )

    system.set(u'user_is_staff', has_access(user, descriptor.location, u'staff', course_id))

    # make an ErrorDescriptor -- assuming that the descriptor's system is ok
    if has_access(user, descriptor.location, 'staff', course_id):
        system.error_descriptor_class = ErrorDescriptor
    else:
        system.error_descriptor_class = NonStaffErrorDescriptor

    descriptor.bind_for_student(system, LmsFieldData(descriptor._field_data, student_data))  # pylint: disable=protected-access
    descriptor.scope_ids = descriptor.scope_ids._replace(user_id=user.id)  # pylint: disable=protected-access
    return descriptor


def find_target_student_module(request, user_id, course_id, mod_id):
    """
    Retrieve target StudentModule
    """
    user = User.objects.get(id=user_id)
    field_data_cache = FieldDataCache.cache_for_descriptor_descendents(
        course_id,
        user,
        modulestore().get_instance(course_id, mod_id),
        depth=0,
        select_for_update=True
    )
    instance = get_module(user, request, mod_id, field_data_cache, course_id, grade_bucket_type='xqueue')
    if instance is None:
        msg = "No module {0} for user {1}--access denied?".format(mod_id, user)
        log.debug(msg)
        raise Http404
    return instance


@csrf_exempt
def xqueue_callback(request, course_id, userid, mod_id, dispatch):
    '''
    Entry point for graded results from the queueing system.
    '''
    data = request.POST.copy()

    # Test xqueue package, which we expect to be:
    #   xpackage = {'xqueue_header': json.dumps({'lms_key':'secretkey',...}),
    #               'xqueue_body'  : 'Message from grader'}
    for key in ['xqueue_header', 'xqueue_body']:
        if key not in data:
            raise Http404

    header = json.loads(data['xqueue_header'])
    if not isinstance(header, dict) or 'lms_key' not in header:
        raise Http404

    instance = find_target_student_module(request, userid, course_id, mod_id)

    # Transfer 'queuekey' from xqueue response header to the data.
    # This is required to use the interface defined by 'handle_ajax'
    data.update({'queuekey': header['lms_key']})

    # We go through the "AJAX" path
    # So far, the only dispatch from xqueue will be 'score_update'
    try:
        # Can ignore the return value--not used for xqueue_callback
        instance.handle_ajax(dispatch, data)
        # Save any state that has changed to the underlying KeyValueStore
        instance.save()
    except:
        log.exception("error processing ajax call")
        raise

    return HttpResponse("")


@csrf_exempt
def handle_xblock_callback_noauth(request, course_id, usage_id, handler, suffix=None):
    """
    Entry point for unauthenticated XBlock handlers.
    """
    request.user.known = False

    return _invoke_xblock_handler(request, course_id, usage_id, handler, suffix, request.user)


def handle_xblock_callback(request, course_id, usage_id, handler, suffix=None):
    """
    Generic view for extensions. This is where AJAX calls go.

    Arguments:

      - request -- the django request.
      - location -- the module location. Used to look up the XModule instance
      - course_id -- defines the course context for this request.

    Raises PermissionDenied if the user is not logged in. Raises Http404 if
    the location and course_id do not identify a valid module, the module is
    not accessible by the user, or the module raises NotFoundError. If the
    module raises any other error, it will escape this function.
    """
    if not request.user.is_authenticated():
        raise PermissionDenied

    return _invoke_xblock_handler(request, course_id, usage_id, handler, suffix, request.user)


def xblock_resource(request, block_type, uri):  # pylint: disable=unused-argument
    """
    Return a package resource for the specified XBlock.
    """
    try:
        xblock_class = XBlock.load_class(block_type, select=settings.XBLOCK_SELECT_FUNCTION)
        content = xblock_class.open_local_resource(uri)
    except IOError:
        log.info('Failed to load xblock resource', exc_info=True)
        raise Http404
    except Exception:  # pylint: disable-msg=broad-except
        log.error('Failed to load xblock resource', exc_info=True)
        raise Http404
    mimetype, _ = mimetypes.guess_type(uri)
    return HttpResponse(content, mimetype=mimetype)


def _invoke_xblock_handler(request, course_id, usage_id, handler, suffix, user):
    """
    Invoke an XBlock handler, either authenticated or not.

    """
    location = unquote_slashes(usage_id)

    # Check parameters and fail fast if there's a problem
    if not Location.is_valid(location):
        raise Http404("Invalid location")

    # Check submitted files
    files = request.FILES or {}
    error_msg = _check_files_limits(files)
    if error_msg:
        return HttpResponse(json.dumps({'success': error_msg}))

    try:
        descriptor = modulestore().get_instance(course_id, location)
    except ItemNotFoundError:
        log.warn(
            "Invalid location for course id {course_id}: {location}".format(
                course_id=course_id,
                location=location
            )
        )
        raise Http404

    tracking_context_name = 'module_callback_handler'
    tracking_context = {
        'module': {
            'display_name': descriptor.display_name_with_default,
        }
    }

    field_data_cache = FieldDataCache.cache_for_descriptor_descendents(
        course_id,
        user,
        descriptor
    )
    instance = get_module(user, request, location, field_data_cache, course_id, grade_bucket_type='ajax')
    if instance is None:
        # Either permissions just changed, or someone is trying to be clever
        # and load something they shouldn't have access to.
        log.debug("No module %s for user %s -- access denied?", location, user)
        raise Http404

    req = django_to_webob_request(request)
    try:
        with tracker.get_tracker().context(tracking_context_name, tracking_context):
            resp = instance.handle(handler, req, suffix)

    except NoSuchHandlerError:
        log.exception("XBlock %s attempted to access missing handler %r", instance, handler)
        raise Http404

    # If we can't find the module, respond with a 404
    except NotFoundError:
        log.exception("Module indicating to user that request doesn't exist")
        raise Http404

    # For XModule-specific errors, we log the error and respond with an error message
    except ProcessingError as err:
        log.warning("Module encountered an error while processing AJAX call",
                    exc_info=True)
        return JsonResponse(object={'success': err.args[0]}, status=200)

    # If any other error occurred, re-raise it to trigger a 500 response
    except Exception:
        log.exception("error executing xblock handler")
        raise

    return webob_to_django_response(resp)


def get_score_bucket(grade, max_grade):
    """
    Function to split arbitrary score ranges into 3 buckets.
    Used with statsd tracking.
    """
    score_bucket = "incorrect"
    if(grade > 0 and grade < max_grade):
        score_bucket = "partial"
    elif(grade == max_grade):
        score_bucket = "correct"

    return score_bucket


def _check_files_limits(files):
    """
    Check if the files in a request are under the limits defined by
    `settings.MAX_FILEUPLOADS_PER_INPUT` and
    `settings.STUDENT_FILEUPLOAD_MAX_SIZE`.

    Returns None if files are correct or an error messages otherwise.
    """
    for fileinput_id in files.keys():
        inputfiles = files.getlist(fileinput_id)

        # Check number of files submitted
        if len(inputfiles) > settings.MAX_FILEUPLOADS_PER_INPUT:
            msg = 'Submission aborted! Maximum %d files may be submitted at once' % \
                  settings.MAX_FILEUPLOADS_PER_INPUT
            return msg

        # Check file sizes
        for inputfile in inputfiles:
            if inputfile.size > settings.STUDENT_FILEUPLOAD_MAX_SIZE:  # Bytes
                msg = 'Submission aborted! Your file "%s" is too large (max size: %d MB)' % \
                      (inputfile.name, settings.STUDENT_FILEUPLOAD_MAX_SIZE / (1000 ** 2))
                return msg

    return None
