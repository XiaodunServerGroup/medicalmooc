"""
Specific overrides to the base prod settings to make development easier.
"""

from .aws import * # pylint: disable=wildcard-import, unused-wildcard-import

DEBUG = True
USE_I18N = True
TEMPLATE_DEBUG = DEBUG
TIME_ZONE = 'Asia/Shanghai'
LANGUAGE_CODE = 'zh_CN'
SITE_NAME = 'http://192.168.1.31:8001'

################################ LOGGERS ######################################

import logging

# Disable noisy loggers
for pkg_name in ['track.contexts', 'track.middleware', 'dd.dogapi']:
    logging.getLogger(pkg_name).setLevel(logging.CRITICAL)


################################ EMAIL ########################################

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

################################# LMS INTEGRATION #############################

LMS_BASE = "http://192.168.1.31:8000"
FEATURES['PREVIEW_LMS_BASE'] = LMS_BASE

################################# CELERY ######################################

# By default don't use a worker, execute tasks as if they were local functions
CELERY_ALWAYS_EAGER = True

################################ DEBUG TOOLBAR ################################
INSTALLED_APPS += ('debug_toolbar', 'debug_toolbar_mongo')
MIDDLEWARE_CLASSES += ('debug_toolbar.middleware.DebugToolbarMiddleware',)
INTERNAL_IPS = ('127.0.0.1',)

DEBUG_TOOLBAR_PANELS = (
    'debug_toolbar.panels.version.VersionDebugPanel',
    'debug_toolbar.panels.timer.TimerDebugPanel',
    'debug_toolbar.panels.settings_vars.SettingsVarsDebugPanel',
    'debug_toolbar.panels.headers.HeaderDebugPanel',
    'debug_toolbar.panels.request_vars.RequestVarsDebugPanel',
    'debug_toolbar.panels.sql.SQLDebugPanel',
    'debug_toolbar.panels.signals.SignalDebugPanel',
    'debug_toolbar.panels.logger.LoggingPanel',

    #  Enabling the profiler has a weird bug as of django-debug-toolbar==0.9.4 and
    #  Django=1.3.1/1.4 where requests to views get duplicated (your method gets
    #  hit twice). So you can uncomment when you need to diagnose performance
    #  problems, but you shouldn't leave it on.
    #  'debug_toolbar.panels.profiling.ProfilingPanel',
)

DEBUG_TOOLBAR_CONFIG = {
    'INTERCEPT_REDIRECTS': False
}

# To see stacktraces for MongoDB queries, set this to True.
# Stacktraces slow down page loads drastically (for pages with lots of queries).
DEBUG_TOOLBAR_MONGO_STACKTRACES = False

###############################################################################
# Lastly, see if the developer has any local overrides.
try:
    from .private import *  # pylint: disable=F0401
except ImportError:
    pass