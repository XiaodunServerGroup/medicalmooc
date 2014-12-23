from django.conf import settings
from django.conf.urls import patterns, include, url
from ratelimitbackend import admin
from django.conf.urls.static import static

import django.contrib.auth.views

# Uncomment the next two lines to enable the admin:
if settings.DEBUG or settings.FEATURES.get('ENABLE_DJANGO_ADMIN_SITE'):
    admin.autodiscover()

urlpatterns = ('',  # nopep8
    # certificate view
    url(r'^update_certificate$', 'certificates.views.update_certificate'),
    url(r'^$', 'branding.views.index', name="root"),   # Main marketing page, or redirect to courseware
    url(r'^dashboard$', 'student.views.dashboard', name="dashboard"),
    url(r'^token$', 'student.views.token', name="token"),
    url(r'^login$', 'student.views.signin_user', name="signin_user"),
    url(r'^login_failure_count$', 'student.views.login_failure_count', name='login_failure_count'),
    url(r'^register$', 'student.views.register_user', name="register_user"),

    url(r'^admin_dashboard$', 'dashboard.views.dashboard'),

    url(r'^lead/courses$', 'student.views.lead_courses', name='lead_courses'),

    url(r'^change_email$', 'student.views.change_email_request', name="change_email"),
    url(r'^email_confirm/(?P<key>[^/]*)$', 'student.views.confirm_email_change'),
    url(r'^change_name$', 'student.views.change_name_request', name="change_name"),
    url(r'^change_picurl$', 'student.views.change_picurl_request', name="change_picurl"),
    url(r'^change_shortbio$', 'student.views.change_shortbio_request', name="change_shortbio"),
    url(r'^accept_name_change$', 'student.views.accept_name_change'),
    url(r'^reject_name_change$', 'student.views.reject_name_change'),
    url(r'^pending_name_changes$', 'student.views.pending_name_changes'),
    url(r'^event$', 'track.views.user_track'),
    url(r'^t/(?P<template>[^/]*)$', 'static_template_view.views.index'),   # TODO: Is this used anymore? What is STATIC_GRAB?

    url(r'^accounts/login$', 'student.views.accounts_login', name="accounts_login"),
    url(r'^accounts/manage_user_standing', 'student.views.manage_user_standing',
        name='manage_user_standing'),
    url(r'^accounts/disable_account_ajax$', 'student.views.disable_account_ajax',
        name="disable_account_ajax"),

    url(r'^login_ajax$', 'student.views.login_user', name="login"),
    url(r'^login_ajax/(?P<error>[^/]*)$', 'student.views.login_user'),
    url(r'^logout$', 'student.views.logout_user', name='logout'),
    url(r'^create_account$', 'student.views.create_account', name='create_account'),
    url(r'^activate/(?P<key>[^/]*)$', 'student.views.activate_account', name="activate"),

    url(r'^password_reset/$', 'student.views.password_reset', name='password_reset'),
    ## Obsolete Django views for password resets
    ## TODO: Replace with Mako-ized views
    url(r'^password_change/$', django.contrib.auth.views.password_change,
        name='auth_password_change'),
    url(r'^password_change_done/$', django.contrib.auth.views.password_change_done,
        name='auth_password_change_done'),
    url(r'^password_reset_confirm/(?P<uidb36>[0-9A-Za-z]+)-(?P<token>.+)/$',
        'student.views.password_reset_confirm_wrapper',
        name='auth_password_reset_confirm'),
    url(r'^password_reset_complete/$', django.contrib.auth.views.password_reset_complete,
        name='auth_password_reset_complete'),
    url(r'^password_reset_done/$', django.contrib.auth.views.password_reset_done,
        name='auth_password_reset_done'),

    url(r'^heartbeat$', include('heartbeat.urls')),

    url(r'^user_api/', include('user_api.urls')),

    url(r'^lang_pref/', include('lang_pref.urls')),

    url(r'^', include('waffle.urls')),

    url(r'^i18n/', include('django.conf.urls.i18n')),

    url(r'^embargo$', 'student.views.embargo', name="embargo"),
)

urlpatterns += (
    url(r'^captcha/', include('captcha.urls')),
)

# mobile login restfull api
urlpatterns += (
    url(r'^mobi/token($|/(?P<action>(login|logout))$)', 'student.views.mobi_token_handler', name='mobi_token_handler'),
    url(r'^mobi/change_enrollment$', 'student.views.mobi_change_enrollment', name='mobi_change_enrollment')
)

# if settings.FEATURES.get("MULTIPLE_ENROLLMENT_ROLES"):
urlpatterns += (
    url(r'^verify_student/', include('verify_student.urls')),
    url(r'^course_modes/', include('course_modes.urls')),
)


js_info_dict = {
    'domain': 'djangojs',
    # No packages needed, we get LOCALE_PATHS anyway.
    'packages': (),
}

urlpatterns += (
    # Serve catalog of localized strings to be rendered by Javascript
    url(r'^jsi18n/$', 'django.views.i18n.javascript_catalog', js_info_dict),
)

# sysadmin dashboard, to see what courses are loaded, to delete & load courses
if settings.FEATURES["ENABLE_SYSADMIN_DASHBOARD"]:
    urlpatterns += (
        url(r'^sysadmin/', include('dashboard.sysadmin_urls')),
    )

#Semi-static views (these need to be rendered and have the login bar, but don't change)
urlpatterns += (
    url(r'^404$', 'static_template_view.views.render',
        {'template': '404.html'}, name="404"),
)
urlpatterns += (
    url(r'^common/header.html$', 'static_template_view.views.render',
        {'template': 'common_header.html'}, name="common_header"),
    url(r'^common/header.js$', 'static_template_view.views.render',
        {'template': 'common_header_barjs.html'}, name="common_header_barjs"),
    url(r'^common/header2.js$', 'static_template_view.views.render',
        {'template': 'common_header_barjs2.html'}, name="common_header_barjs2"),

    url(r'^common/footer.js$', 'static_template_view.views.render',
            {'template': 'common_footer_js.html'}, name="common_footer_js"),
)
urlpatterns += (
    url(r'^common/vplayer.html', 'static_template_view.views.render',
        {'template': 'vplayer.html'}, name="vplayer"),
)
# Semi-static views only used by edX, not by themes
if not settings.FEATURES["USE_CUSTOM_THEME"]:
    urlpatterns += (
        url(r'^jobs$', 'static_template_view.views.render',
            {'template': 'jobs.html'}, name="jobs"),
        url(r'^press$', 'student.views.press', name="press"),
        url(r'^media-kit$', 'static_template_view.views.render',
            {'template': 'media-kit.html'}, name="media-kit"),
        url(r'^faq$', 'static_template_view.views.render',
            {'template': 'faq.html'}, name="faq_edx"),
        url(r'^help$', 'static_template_view.views.render',
            {'template': 'help.html'}, name="help_edx"),

        # TODO: (bridger) The copyright has been removed until it is updated for edX
        # url(r'^copyright$', 'static_template_view.views.render',
        #     {'template': 'copyright.html'}, name="copyright"),

        # Press releases
        url(r'^press/([_a-zA-Z0-9-]+)$', 'static_template_view.views.render_press_release', name='press_release'),

        # Favicon
        (r'^favicon\.ico$', 'django.views.generic.simple.redirect_to', {'url': '/static/images/favicon.ico'}),
        # annotator.po
        (r'^annotator\.po$', 'django.views.generic.simple.redirect_to', {'url': '/static/js/vendor/ova/locale/zh_CN/annotator.po'}),

        url(r'^submit_feedback$', 'util.views.submit_feedback'),

    )

# Only enable URLs for those marketing links actually enabled in the
# settings. Disable URLs by marking them as None.
for key, value in settings.MKTG_URL_LINK_MAP.items():
    # Skip disabled URLs
    if value is None:
        continue

    # These urls are enabled separately
    if key == "ROOT" or key == "COURSES":
        continue

    # Make the assumptions that the templates are all in the same dir
    # and that they all match the name of the key (plus extension)
    template = "%s.html" % key.lower()

    # To allow theme templates to inherit from default templates,
    # prepend a standard prefix
    if settings.FEATURES["USE_CUSTOM_THEME"]:
        template = "theme-" + template

    # Make the assumption that the URL we want is the lowercased
    # version of the map key
    urlpatterns += (url(r'^%s' % key.lower(),
                        'static_template_view.views.render',
                        {'template': template}, name=value),)


if settings.PERFSTATS:
    urlpatterns += (url(r'^reprofile$', 'lms.lib.perfstats.views.end_profile'),)

# Multicourse wiki (Note: wiki urls must be above the courseware ones because of
# the custom tab catch-all)
if settings.WIKI_ENABLED:
    from wiki.urls import get_pattern as wiki_pattern
    from django_notify.urls import get_pattern as notify_pattern

    # Note that some of these urls are repeated in course_wiki.course_nav. Make sure to update
    # them together.
    urlpatterns += (
        # First we include views from course_wiki that we use to override the default views.
        # They come first in the urlpatterns so they get resolved first
        url('^wiki/create-root/$', 'course_wiki.views.root_create', name='root_create'),
        url(r'^wiki/', include(wiki_pattern())),
        url(r'^notify/', include(notify_pattern())),

        # These urls are for viewing the wiki in the context of a course. They should
        # never be returned by a reverse() so they come after the other url patterns
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/course_wiki/?$',
            'course_wiki.views.course_wiki_redirect', name="course_wiki"),
        url(r'^courses/(?:[^/]+/[^/]+/[^/]+)/wiki/', include(wiki_pattern())),
    )


if settings.WECHAT_ENABLED:
    urlpatterns += (
        url(r'^m/courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/courseware/(?P<chapter>[^/]*)/(?P<section>[^/]*)/(?P<position>[^/]*)/?$',
            'wechat.views.mobi_index', name="courseware_unit"),
        url(r'^m/courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/courseware$','wechat.views.mobi_directory',name="mobi_info"),
        url(r'^m/courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/about$', 'wechat.mobile_views.mobile_course_about', name="mobile_about_course"),
        url(r'^m/register$', "wechat.views.mobi_register", name="mobi_register"),
        url(r'^m/user/(?P<user_id>\d+)/success_register$', "wechat.views.mobi_register_success", name="mobi_register_success"),
        url(r'^m/login_ajax$', "wechat.views.mobi_login_ajax", name="mobi_login_ajax"),
        url(r'^m/login$', "wechat.views.mobi_login", name="mobi_login"),
        url(r'^mobile_change_enrollment$', 'wechat.mobile_views.mobile_change_enrollment', name="mobile_change_enrollment"),
        url(r'^m/show_video/$', "wechat.views.show_video"),
    )


if settings.COURSEWARE_ENABLED:
    urlpatterns += (
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/jump_to/(?P<location>.*)$',
            'courseware.views.jump_to', name="jump_to"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/jump_to_id/(?P<module_id>.*)$',
            'courseware.views.jump_to_id', name="jump_to_id"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/xblock/(?P<usage_id>[^/]*)/handler/(?P<handler>[^/]*)(?:/(?P<suffix>.*))?$',
            'courseware.module_render.handle_xblock_callback',
            name='xblock_handler'),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/xblock/(?P<usage_id>[^/]*)/handler_noauth/(?P<handler>[^/]*)(?:/(?P<suffix>.*))?$',
            'courseware.module_render.handle_xblock_callback_noauth',
            name='xblock_handler_noauth'),
        url(r'xblock/resource/(?P<block_type>[^/]+)/(?P<uri>.*)$',
            'courseware.module_render.xblock_resource',
            name='xblock_resource_url'),

        # Software Licenses

        # TODO: for now, this is the endpoint of an ajax replay
        # service that retrieve and assigns license numbers for
        # software assigned to a course. The numbers have to be loaded
        # into the database.
        url(r'^software-licenses$', 'licenses.views.user_software_license', name="user_software_license"),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/xqueue/(?P<userid>[^/]*)/(?P<mod_id>.*?)/(?P<dispatch>[^/]*)$',
            'courseware.module_render.xqueue_callback',
            name='xqueue_callback'),
        url(r'^change_setting$', 'student.views.change_setting',
            name='change_setting'),

        # TODO: These views need to be updated before they work
        url(r'^calculate$', 'util.views.calculate'),
        # TODO: We should probably remove the circuit package. I believe it was only used in the old way of saving wiki circuits for the wiki
        # url(r'^edit_circuit/(?P<circuit>[^/]*)$', 'circuit.views.edit_circuit'),
        # url(r'^save_circuit/(?P<circuit>[^/]*)$', 'circuit.views.save_circuit'),

        url(r'^courses/?$', 'branding.views.courses', name="courses"),
        url(r'^change_enrollment$',
            'student.views.change_enrollment', name="change_enrollment"),
        url(r'^change_email_settings$', 'student.views.change_email_settings', name="change_email_settings"),

        #About the course
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/about$',
            'courseware.views.course_about', name="about_course"),
        #About the mooc_list
        url(r'^mooc_list$',
            'courseware.views.mooc_list', name="mooc_list"),
        #View for mktg site (kept for backwards compatibility TODO - remove before merge to master)
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/mktg-about$',
            'courseware.views.mktg_course_about', name="mktg_about_course"),
        #View for mktg site
        url(r'^mktg/(?P<course_id>.*)$',
            'courseware.views.mktg_course_about', name="mktg_about_course"),
        
        # mobile course info url
        url(r'^mobi/courses-list/org/(?P<org>[\w\-]+)',
            'courseware.views.courses_list_by_org', name="courses_list_by_org"),
        
        url(r'^mobi/courses-list/(?P<action>(homefalls|hot|latest|all|my|rolling|search|sync))',
            'courseware.views.courses_list_handler', name="courses_list_handler"),
                
        url(r'^mobi/courses-list/category/(?P<course_category>[\w\-]+)($|/level/(?P<course_level>[\w\-]+)$)',
            'courseware.views.course_attr_list_handler', name="course_attr_list_handler"),
                 

        #Inside the course
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/$',
            'courseware.views.course_info', name="course_root"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/info$',
            'courseware.views.course_info', name="info"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/syllabus$',
            'courseware.views.syllabus', name="syllabus"),   # TODO arjun remove when custom tabs in place, see courseware/courses.py

        # mobile course info
        url(r'^mobi/courses/(?P<course_id>[\w\-~.:]+)($|/(?P<action>(updates|handouts|structure))$)',
            'courseware.views.mobi_course_action', name="mobi_course_action"),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/book/(?P<book_index>\d+)/$',
            'staticbook.views.index', name="book"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/book/(?P<book_index>\d+)/(?P<page>\d+)$',
            'staticbook.views.index', name="book"),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/pdfbook/(?P<book_index>\d+)/$',
            'staticbook.views.pdf_index', name="pdf_book"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/pdfbook/(?P<book_index>\d+)/(?P<page>\d+)$',
            'staticbook.views.pdf_index', name="pdf_book"),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/pdfbook/(?P<book_index>\d+)/chapter/(?P<chapter>\d+)/$',
            'staticbook.views.pdf_index', name="pdf_book"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/pdfbook/(?P<book_index>\d+)/chapter/(?P<chapter>\d+)/(?P<page>\d+)$',
            'staticbook.views.pdf_index', name="pdf_book"),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/htmlbook/(?P<book_index>\d+)/$',
            'staticbook.views.html_index', name="html_book"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/htmlbook/(?P<book_index>\d+)/chapter/(?P<chapter>\d+)/$',
            'staticbook.views.html_index', name="html_book"),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/courseware/?$',
            'courseware.views.index', name="courseware"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/courseware/(?P<chapter>[^/]*)/$',
            'courseware.views.index', name="courseware_chapter"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/courseware/(?P<chapter>[^/]*)/(?P<section>[^/]*)/$',
            'courseware.views.index', name="courseware_section"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/courseware/(?P<chapter>[^/]*)/(?P<section>[^/]*)/(?P<position>[^/]*)/?$',
            'courseware.views.index', name="courseware_position"),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/progress$',
            'courseware.views.progress', name="progress"),
        # Takes optional student_id for instructor use--shows profile as that student sees it.
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/progress/(?P<student_id>[^/]*)/$',
            'courseware.views.progress', name="student_progress"),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/calendar$',
            'courseware.views.calendar', name="calendar"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/calendar/get-events',
            'courseware.views.cal_getevents', name="cal_getevents"),

        # For the instructor
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/instructor$',
            'instructor.views.legacy.instructor_dashboard', name="instructor_dashboard"),

        # see ENABLE_INSTRUCTOR_BETA_DASHBOARD section for more urls

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/gradebook$',
            'instructor.views.legacy.gradebook', name='gradebook'),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/grade_summary$',
            'instructor.views.legacy.grade_summary', name='grade_summary'),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/staff_grading$',
            'open_ended_grading.views.staff_grading', name='staff_grading'),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/staff_grading/get_next$',
            'open_ended_grading.staff_grading_service.get_next', name='staff_grading_get_next'),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/staff_grading/save_grade$',
            'open_ended_grading.staff_grading_service.save_grade', name='staff_grading_save_grade'),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/staff_grading/get_problem_list$',
            'open_ended_grading.staff_grading_service.get_problem_list', name='staff_grading_get_problem_list'),

        # Open Ended problem list
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/open_ended_problems$',
            'open_ended_grading.views.student_problem_list', name='open_ended_problems'),

        # Open Ended flagged problem list
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/open_ended_flagged_problems$',
            'open_ended_grading.views.flagged_problem_list', name='open_ended_flagged_problems'),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/open_ended_flagged_problems/take_action_on_flags$',
            'open_ended_grading.views.take_action_on_flags', name='open_ended_flagged_problems_take_action'),

        # Cohorts management
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/cohorts$',
            'course_groups.views.list_cohorts', name="cohorts"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/cohorts/add$',
            'course_groups.views.add_cohort',
            name="add_cohort"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/cohorts/(?P<cohort_id>[0-9]+)$',
            'course_groups.views.users_in_cohort',
            name="list_cohort"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/cohorts/(?P<cohort_id>[0-9]+)/add$',
            'course_groups.views.add_users_to_cohort',
            name="add_to_cohort"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/cohorts/(?P<cohort_id>[0-9]+)/delete$',
            'course_groups.views.remove_user_from_cohort',
            name="remove_from_cohort"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/cohorts/debug$',
            'course_groups.views.debug_cohort_mgmt',
            name="debug_cohort_mgmt"),

        # Open Ended Notifications
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/open_ended_notifications$',
            'open_ended_grading.views.combined_notifications', name='open_ended_notifications'),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/peer_grading$',
            'open_ended_grading.views.peer_grading', name='peer_grading'),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/notes$', 'notes.views.notes', name='notes'),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/notes/', include('notes.urls')),
    )

    # allow course staff to change to student view of courseware
    if settings.FEATURES.get('ENABLE_MASQUERADE'):
        urlpatterns += (
            url(r'^masquerade/(?P<marg>.*)$', 'courseware.masquerade.handle_ajax', name="masquerade-switch"),
        )

    # discussion forums live within courseware, so courseware must be enabled first
    if settings.FEATURES.get('ENABLE_DISCUSSION_SERVICE'):
        urlpatterns += (
            # url(r'^courses/mobi/threads/(?P<thread_id>[\w\-]+)/delete$',
            #     'django_comment_client.base.views.mobi_delete_thread'),
            url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/discussion/',
                include('django_comment_client.urls')),
            url(r'^notification_prefs/enable/', 'notification_prefs.views.ajax_enable'),
            url(r'^notification_prefs/disable/', 'notification_prefs.views.ajax_disable'),
            url(r'^notification_prefs/status/', 'notification_prefs.views.ajax_status'),
            url(r'^notification_prefs/unsubscribe/(?P<token>[a-zA-Z0-9-_=]+)/',
                'notification_prefs.views.set_subscription', {'subscribe': False}, name="unsubscribe_forum_update"),
            url(r'^notification_prefs/resubscribe/(?P<token>[a-zA-Z0-9-_=]+)/',
                'notification_prefs.views.set_subscription', {'subscribe': True}, name="resubscribe_forum_update"),
        )

        # mobile discusstion restfull api
        urlpatterns += (
            # thread CURD
            url(r'^mobi/discussion/course-list',
                'django_comment_client.forum.views.mobi_forum_course_list', name="mobi_forum_course_list"),

            url(r'^mobi/courses/(?P<course_id>[\w\-~.:]+)/topics',
                'django_comment_client.forum.views.mobi_get_topics', name="mobi_get_topics"),

            url(r'^mobi/(?P<course_id>[\w\-~.:]+)/discussion/my',
                'django_comment_client.forum.views.my_joined_courses', name="my_joined_courses"),

            url(r'^mobi/(?P<course_id>[\w\-~.:]+)/discussion/all',
                'django_comment_client.forum.views.mobi_forum_course_discussion', name="mobi_forum_course_discussion"),

            url(r'^mobi/(?P<course_id>[\w\-~.:]+)/user/discussions$',
                'django_comment_client.forum.views.mobi_user_discussion', name="mobi_user_discussion"),

            url(r'^mobi/(?P<course_id>[\w\-~.:]+)/discussion/search',
                'django_comment_client.forum.views.mobi_disscussion_search', name="mobi_disscussion_search"),

            url(r'^mobi/threads/batch/delete$', 'django_comment_client.base.views.mobi_batch_threads_delete', name='mobi_batch_threads_delete'),

            url(r'^mobi/courses/(?P<course_id>[\w\-~.:]+)/discussion/(?P<thread_id>[\w\-]+)($|/(?P<action>(reply|replies)))',
                'django_comment_client.base.views.mobi_thread_handler', name="mobi_thread_handler"),

            url(r'^mobi/courses/(?P<course_id>[\w\-~.:]+)/(?P<topic_id>[\w\-]+)',
                'django_comment_client.base.views.mobi_create_thread', name="mobi_create_thread"),
        )

        # Spam messages filtering thesaurus
        urlpatterns += (
            url(r'^forum-discussion/thesaurus/management',
                'django_comment_client.forum.views.forum_thesaurus', name="forum_thesaurus"),
            url(r'^forum-discussion/thesaurus/oper/(?P<oper>(add|delete))$',
                'django_comment_client.forum.views.oper_thesaurus', name="oper_thesaurus")
        )

    urlpatterns += (
        # This MUST be the last view in the courseware--it's a catch-all for custom tabs.
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/(?P<tab_slug>[^/]+)/$',
        'courseware.views.static_tab', name="static_tab"),
    )

    if settings.FEATURES.get('ENABLE_STUDENT_HISTORY_VIEW'):
        urlpatterns += (
            url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/submission_history/(?P<student_username>[^/]*)/(?P<location>.*?)$',
                'courseware.views.submission_history',
                name='submission_history'),
        )


if settings.COURSEWARE_ENABLED and settings.FEATURES.get('ENABLE_INSTRUCTOR_BETA_DASHBOARD'):
    urlpatterns += (
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/instructor_dashboard$',
            'instructor.views.instructor_dashboard.instructor_dashboard_2', name="instructor_dashboard_2"),

        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/instructor_dashboard/api/',
            include('instructor.views.api_urls'))
    )

if settings.FEATURES.get('CLASS_DASHBOARD'):
    urlpatterns += (
        # Json request data for metrics for entire course
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/all_sequential_open_distrib$',
            'class_dashboard.views.all_sequential_open_distrib', name="all_sequential_open_distrib"),
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/all_problem_grade_distribution$',
            'class_dashboard.views.all_problem_grade_distribution', name="all_problem_grade_distribution"),

        # Json request data for metrics for particular section
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/problem_grade_distribution/(?P<section>\d+)$',
            'class_dashboard.views.section_problem_grade_distrib', name="section_problem_grade_distrib"),
    )

if settings.DEBUG or settings.FEATURES.get('ENABLE_DJANGO_ADMIN_SITE'):
    ## Jasmine and admin
    urlpatterns += (url(r'^admin/', include(admin.site.urls)),)

if settings.FEATURES.get('AUTH_USE_OPENID'):
    urlpatterns += (
        url(r'^openid/login/$', 'django_openid_auth.views.login_begin', name='openid-login'),
        url(r'^openid/complete/$', 'external_auth.views.openid_login_complete', name='openid-complete'),
        url(r'^openid/logo.gif$', 'django_openid_auth.views.logo', name='openid-logo'),
    )

if settings.FEATURES.get('AUTH_USE_SHIB'):
    urlpatterns += (
        url(r'^shib-login/$', 'external_auth.views.shib_login', name='shib-login'),
    )

if settings.FEATURES.get('AUTH_USE_CAS'):
    urlpatterns += (
        url(r'^cas-auth/login/$', 'external_auth.views.cas_login', name="cas-login"),
        url(r'^cas-auth/logout/$', 'django_cas.views.logout', {'next_page': '/'}, name="cas-logout"),
    )

if settings.FEATURES.get('RESTRICT_ENROLL_BY_REG_METHOD'):
    urlpatterns += (
        url(r'^course_specific_login/(?P<course_id>[^/]+/[^/]+/[^/]+)/$',
            'external_auth.views.course_specific_login', name='course-specific-login'),
        url(r'^course_specific_register/(?P<course_id>[^/]+/[^/]+/[^/]+)/$',
            'external_auth.views.course_specific_register', name='course-specific-register'),

    )

# Shopping cart
urlpatterns += (
    url(r'^shoppingcart/', include('shoppingcart.urls')),
)


if settings.FEATURES.get('AUTH_USE_OPENID_PROVIDER'):
    urlpatterns += (
        url(r'^openid/provider/login/$', 'external_auth.views.provider_login', name='openid-provider-login'),
        url(r'^openid/provider/login/(?:.+)$', 'external_auth.views.provider_identity', name='openid-provider-login-identity'),
        url(r'^openid/provider/identity/$', 'external_auth.views.provider_identity', name='openid-provider-identity'),
        url(r'^openid/provider/xrds/$', 'external_auth.views.provider_xrds', name='openid-provider-xrds')
    )

if settings.FEATURES.get('ENABLE_LMS_MIGRATION'):
    urlpatterns += (
        url(r'^migrate/modules$', 'lms_migration.migrate.manage_modulestores'),
        url(r'^migrate/reload/(?P<reload_dir>[^/]+)$', 'lms_migration.migrate.manage_modulestores'),
        url(r'^migrate/reload/(?P<reload_dir>[^/]+)/(?P<commit_id>[^/]+)$', 'lms_migration.migrate.manage_modulestores'),
        url(r'^gitreload$', 'lms_migration.migrate.gitreload'),
        url(r'^gitreload/(?P<reload_dir>[^/]+)$', 'lms_migration.migrate.gitreload'),
    )

if settings.FEATURES.get('ENABLE_SQL_TRACKING_LOGS'):
    urlpatterns += (
        url(r'^event_logs$', 'track.views.view_tracking_log'),
        url(r'^event_logs/(?P<args>.+)$', 'track.views.view_tracking_log'),
    )

if settings.FEATURES.get('ENABLE_SERVICE_STATUS'):
    urlpatterns += (
        url(r'^status/', include('service_status.urls')),
    )

if settings.FEATURES.get('ENABLE_INSTRUCTOR_BACKGROUND_TASKS'):
    urlpatterns += (
        url(r'^instructor_task_status/$', 'instructor_task.views.instructor_task_status', name='instructor_task_status'),
    )

if settings.FEATURES.get('RUN_AS_ANALYTICS_SERVER_ENABLED'):
    urlpatterns += (
        url(r'^edinsights_service/', include('edinsights.core.urls')),
    )
    import edinsights.core.registry

# FoldIt views
urlpatterns += (
    # The path is hardcoded into their app...
    url(r'^comm/foldit_ops', 'foldit.views.foldit_ops', name="foldit_ops"),
)

if settings.FEATURES.get('ENABLE_DEBUG_RUN_PYTHON'):
    urlpatterns += (
        url(r'^debug/run_python', 'debug.views.run_python'),
    )

# Crowdsourced hinting instructor manager.
if settings.FEATURES.get('ENABLE_HINTER_INSTRUCTOR_VIEW'):
    urlpatterns += (
        url(r'^courses/(?P<course_id>[^/]+/[^/]+/[^/]+)/hint_manager$',
            'instructor.hint_manager.hint_manager', name="hint_manager"),
    )

# enable automatic login
if settings.FEATURES.get('AUTOMATIC_AUTH_FOR_TESTING'):
    urlpatterns += (
        url(r'^auto_auth$', 'student.views.auto_auth'),
    )

urlpatterns = patterns(*urlpatterns)

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

#Custom error pages
handler404 = 'static_template_view.views.render_404'
handler500 = 'static_template_view.views.render_500'
