from django.conf import settings
from django.conf.urls import patterns, include, url
from xmodule.modulestore import parsers

# There is a course creators admin table.
from ratelimitbackend import admin
admin.autodiscover()

urlpatterns = patterns('',  # nopep8

    url(r'^transcripts/upload$', 'contentstore.views.upload_transcripts', name='upload_transcripts'),
    url(r'^transcripts/download$', 'contentstore.views.download_transcripts', name='download_transcripts'),
    url(r'^transcripts/check$', 'contentstore.views.check_transcripts', name='check_transcripts'),
    url(r'^transcripts/choose$', 'contentstore.views.choose_transcripts', name='choose_transcripts'),
    url(r'^transcripts/replace$', 'contentstore.views.replace_transcripts', name='replace_transcripts'),
    url(r'^transcripts/rename$', 'contentstore.views.rename_transcripts', name='rename_transcripts'),
    url(r'^transcripts/save$', 'contentstore.views.save_transcripts', name='save_transcripts'),

    url(r'^preview/xblock/(?P<usage_id>.*?)/handler/(?P<handler>[^/]*)(?:/(?P<suffix>.*))?$',
        'contentstore.views.preview_handler', name='preview_handler'),

    url(r'^xblock/(?P<usage_id>.*?)/handler/(?P<handler>[^/]*)(?:/(?P<suffix>.*))?$',
        'contentstore.views.component_handler', name='component_handler'),

    url(r'^xblock/resource/(?P<block_type>[^/]*)/(?P<uri>.*)$',
        'contentstore.views.xblock.xblock_resource', name='xblock_resource_url'),

    # temporary landing page for a course
    url(r'^edge/(?P<org>[^/]+)/(?P<course>[^/]+)/course/(?P<coursename>[^/]+)$',
        'contentstore.views.landing', name='landing'),

    url(r'^not_found$', 'contentstore.views.not_found', name='not_found'),
    url(r'^server_error$', 'contentstore.views.server_error', name='server_error'),

    # temporary landing page for edge
    url(r'^edge$', 'contentstore.views.edge', name='edge'),
    # noop to squelch ajax errors
    url(r'^event$', 'contentstore.views.event', name='event'),

    url(r'^xmodule/', include('pipeline_js.urls')),
    url(r'^heartbeat$', include('heartbeat.urls')),

    url(r'^user_api/', include('user_api.urls')),
    url(r'^lang_pref/', include('lang_pref.urls')),
)

# captcha
urlpatterns += (
    url(r'^captcha/', include('captcha.urls')),
)

# User creation and updating views
urlpatterns += patterns(
    '',

    url(r'^create_account$', 'student.views.create_account', name='create_account'),
    url(r'^activate/(?P<key>[^/]*)$', 'student.views.activate_account', name='activate'),

    # ajax view that actually does the work
    url(r'^login_post$', 'student.views.login_user', name='login_post'),
    url(r'^login_failure_count$', 'student.views.login_failure_count', name='login_failure_count'),
    url(r'^logout$', 'student.views.logout_user', name='logout'),
    url(r'^embargo$', 'student.views.embargo', name="embargo"),
)

# restful api
urlpatterns += patterns(
    'contentstore.views',

    url(r'^$', 'howitworks', name='homepage'),
    url(r'^howitworks$', 'howitworks'),
    url(r'^signup$', 'signup', name='signup'),
    url(r'^signup_institution', 'signup_institution', name='signup_institution'),
    url(r'^signin$', 'login_page', name='login'),
    url(r'^request_course_creator$', 'request_course_creator'),
    url(r'^institution_upload_teacher$', 'institution_upload_teacher'),
    url(r'^remove_institute_teacher$', 'remove_institute_teacher'),
    # (?ix) == ignore case and verbose (multiline regex)
    url(r'(?ix)^course_team/{}(/)?(?P<email>.+)?$'.format(parsers.URL_RE_SOURCE), 'course_team_handler'),
    url(r'(?ix)^course_info/{}$'.format(parsers.URL_RE_SOURCE), 'course_info_handler'),
    url(
        r'(?ix)^course_info_update/{}(/)?(?P<provided_id>\d+)?$'.format(parsers.URL_RE_SOURCE),
        'course_info_update_handler'
        ),
    url(r'(?ix)^course($|/){}$'.format(parsers.URL_RE_SOURCE), 'course_handler'),
    url(r'(?ix)^subsection($|/){}$'.format(parsers.URL_RE_SOURCE), 'subsection_handler'),
    url(r'(?ix)^unit($|/){}$'.format(parsers.URL_RE_SOURCE), 'unit_handler'),
    url(r'(?ix)^container($|/){}$'.format(parsers.URL_RE_SOURCE), 'container_handler'),
    url(r'(?ix)^checklists/{}(/)?(?P<checklist_index>\d+)?$'.format(parsers.URL_RE_SOURCE), 'checklists_handler'),
    url(r'(?ix)^orphan/{}$'.format(parsers.URL_RE_SOURCE), 'orphan_handler'),
    url(r'(?ix)^assets/{}(/)?(?P<asset_id>.+)?$'.format(parsers.URL_RE_SOURCE), 'assets_handler'),
    url(r'(?ix)^import/{}$'.format(parsers.URL_RE_SOURCE), 'import_handler'),
    url(r'(?ix)^import_status/{}/(?P<filename>.+)$'.format(parsers.URL_RE_SOURCE), 'import_status_handler'),
    url(r'(?ix)^export/{}$'.format(parsers.URL_RE_SOURCE), 'export_handler'),
    url(r'(?ix)^xblock/{}/(?P<view_name>[^/]+)$'.format(parsers.URL_RE_SOURCE), 'xblock_view_handler'),
    url(r'(?ix)^xblock($|/){}$'.format(parsers.URL_RE_SOURCE), 'xblock_handler'),
    url(r'(?ix)^tabs/{}$'.format(parsers.URL_RE_SOURCE), 'tabs_handler'),
    url(r'(?ix)^settings/details/{}$'.format(parsers.URL_RE_SOURCE), 'settings_handler'),
    url(r'(?ix)^settings/grading/{}(/)?(?P<grader_index>\d+)?$'.format(parsers.URL_RE_SOURCE), 'grading_handler'),
    url(r'(?ix)^settings/advanced/{}$'.format(parsers.URL_RE_SOURCE), 'advanced_settings_handler'),
    url(r'(?ix)^settings/calendar/{}$'.format(parsers.URL_RE_SOURCE), 'calendar_settings_handler'),
    url(r'(?ix)^settings/calendar/(?P<course_id>[\w\-~.:]+)/get-events'.format(parsers.URL_RE_SOURCE), 'calendar_settings_getevents'),
    url(r'(?ix)^common/calendar/(?P<course_id>[\w\-~.:]+)$'.format(parsers.URL_RE_SOURCE), 'calendar_common'),
    url(r'(?ix)^common/calendar/(?P<course_id>[\w\-~.:]+)/get-events'.format(parsers.URL_RE_SOURCE), 'calendar_settings_getevents'),
    url(r'(?ix)^common/calendar/(?P<course_id>[\w\-~.:]+)/addEvent'.format(parsers.URL_RE_SOURCE), 'calendar_common_addevent'),
    url(r'(?ix)^common/calendar/(?P<course_id>[\w\-~.:]+)/deleteEvent'.format(parsers.URL_RE_SOURCE), 'calendar_common_deleteevent'),
    url(r'(?ix)^common/calendar/(?P<course_id>[\w\-~.:]+)/updateEvent'.format(parsers.URL_RE_SOURCE), 'calendar_common_updateevent'),
    url(r'(?ix)^textbooks/{}$'.format(parsers.URL_RE_SOURCE), 'textbooks_list_handler'),
    url(r'(?ix)^textbooks/{}/(?P<tid>\d[^/]*)$'.format(parsers.URL_RE_SOURCE), 'textbooks_detail_handler'),

    # student learn information
    url(r'(?ix)^students/learn/course/(?P<course_id>[\w\-~.:]+)/info$', 'students_course_learn_info'),
    url(r'(?ix)^student/(?P<user_id>[^/]*)/course/(?P<course_id>[\w\-~.:]+)/progress$', 'student_process'),

    # course check api
    url(r'(?ix)^bs/course/(?P<course_id>[\w\-~.:]+)/audit/(?P<operation>(pass|offline))$', 'course_audit_api'),
    # mobile restfull api
    url(r'(?ix)^mobi/course-list/search/(?P<keyword>[^/]+)$', 'mobi_search'),
    url(r'(?ix)^mobi/course-list/(?P<datatype>(homefalls|hot|latest|all|my))($|/version$)', 'mobi_course_handler'),
    url(r'(?ix)^mobi/course/(?P<course_id>[\w\-~.:]+)($|/(?P<action>(structure|updates|handouts))($|/))', 'mobi_course_info_handler'),
)

js_info_dict = {
    'domain': 'djangojs',
    # No packages needed, we get LOCALE_PATHS anyway.
    'packages': (),
}

urlpatterns += patterns('',
    # Serve catalog of localized strings to be rendered by Javascript
    url(r'^i18n.js$', 'django.views.i18n.javascript_catalog', js_info_dict),
)


if settings.FEATURES.get('ENABLE_EXPORT_GIT'):
    urlpatterns += (url(r'^(?P<org>[^/]+)/(?P<course>[^/]+)/export_git/(?P<name>[^/]+)$',
                        'contentstore.views.export_git', name='export_git'),)

if settings.FEATURES.get('ENABLE_SERVICE_STATUS'):
    urlpatterns += patterns('',
        url(r'^status/', include('service_status.urls')),
    )

urlpatterns += patterns('', url(r'^admin/', include(admin.site.urls)),)

# enable automatic login
if settings.FEATURES.get('AUTOMATIC_AUTH_FOR_TESTING'):
    urlpatterns += (
        url(r'^auto_auth$', 'student.views.auto_auth'),
    )

if settings.DEBUG:
    try:
        from .urls_dev import urlpatterns as dev_urlpatterns
        urlpatterns += dev_urlpatterns
    except ImportError:
        pass

# Custom error pages
#pylint: disable=C0103
handler404 = 'contentstore.views.render_404'
handler500 = 'contentstore.views.render_500'
