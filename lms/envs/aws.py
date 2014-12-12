"""
This is the default template for our main set of AWS servers. This does NOT
cover the content machines, which use content.py

Common traits:
* Use memcached, and cache-backed sessions
* Use a MySQL 5.1 database
"""
# We intentionally define lots of variables that aren't used, and
# want to import all variables from base settings files
# pylint: disable=W0401, W0614

import json

from .common import *
from logsettings import get_logger_config
import os

from path import path

# SERVICE_VARIANT specifies name of the variant used, which decides what JSON
# configuration files are read during startup.
SERVICE_VARIANT = os.environ.get('SERVICE_VARIANT', None)

# CONFIG_ROOT specifies the directory where the JSON configuration
# files are expected to be found. If not specified, use the project
# directory.
CONFIG_ROOT = path(os.environ.get('CONFIG_ROOT', ENV_ROOT))
# CONFIG_PREFIX specifies the prefix of the JSON configuration files,
# based on the service variant. If no variant is use, don't use a
# prefix.
CONFIG_PREFIX = SERVICE_VARIANT + "." if SERVICE_VARIANT else ""

PROJECT_PATH = path(os.path.abspath(os.path.dirname(__name__)))

SITE_ROOT = path(os.path.dirname(os.path.realpath(__file__)))

################################ ALWAYS THE SAME ##############################

DEBUG = False
TEMPLATE_DEBUG = False

EMAIL_BACKEND = 'django_ses.SESBackend'
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
DEFAULT_FILE_STORAGE = 'django.core.files.storage.FileSystemStorage'
# MEDIA_ROOT = ENV_ROOT / "uploads"
MEDIA_ROOT = PROJECT_PATH / SERVICE_VARIANT / "static/uploads"
MEDIA_URL = "/discussion/upfiles/"
# FILE_UPLOAD_TEMP_DIR = ENV_ROOT / "uploads"
FILE_UPLOAD_TEMP_DIR = PROJECT_PATH / SERVICE_VARIANT / "static/uploads"
FILE_UPLOAD_HANDLERS = (
    'django.core.files.uploadhandler.MemoryFileUploadHandler',
    'django.core.files.uploadhandler.TemporaryFileUploadHandler',
)


# Enable Berkeley forums
FEATURES['ENABLE_DISCUSSION_SERVICE'] = True

# IMPORTANT: With this enabled, the server must always be behind a proxy that
# strips the header HTTP_X_FORWARDED_PROTO from client requests. Otherwise,
# a user can fool our server into thinking it was an https connection.
# See
# https://docs.djangoproject.com/en/dev/ref/settings/#secure-proxy-ssl-header
# for other warnings.
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

###################################### CELERY  ################################

# Don't use a connection pool, since connections are dropped by ELB.
BROKER_POOL_LIMIT = 0
BROKER_CONNECTION_TIMEOUT = 1

# For the Result Store, use the django cache named 'celery'
CELERY_RESULT_BACKEND = 'cache'
CELERY_CACHE_BACKEND = 'celery'

# When the broker is behind an ELB, use a heartbeat to refresh the
# connection and to detect if it has been dropped.
BROKER_HEARTBEAT = 10.0
BROKER_HEARTBEAT_CHECKRATE = 2

# Each worker should only fetch one message at a time
CELERYD_PREFETCH_MULTIPLIER = 1

# Skip djcelery migrations, since we don't use the database as the broker
SOUTH_MIGRATION_MODULES = {
    'djcelery': 'ignore',
}

# Rename the exchange and queues for each variant

QUEUE_VARIANT = CONFIG_PREFIX.lower()

CELERY_DEFAULT_EXCHANGE = 'edx.{0}core'.format(QUEUE_VARIANT)

HIGH_PRIORITY_QUEUE = 'edx.{0}core.high'.format(QUEUE_VARIANT)
DEFAULT_PRIORITY_QUEUE = 'edx.{0}core.default'.format(QUEUE_VARIANT)
LOW_PRIORITY_QUEUE = 'edx.{0}core.low'.format(QUEUE_VARIANT)
HIGH_MEM_QUEUE = 'edx.{0}core.high_mem'.format(QUEUE_VARIANT)

CELERY_DEFAULT_QUEUE = DEFAULT_PRIORITY_QUEUE
CELERY_DEFAULT_ROUTING_KEY = DEFAULT_PRIORITY_QUEUE

CELERY_QUEUES = {
    HIGH_PRIORITY_QUEUE: {},
    LOW_PRIORITY_QUEUE: {},
    DEFAULT_PRIORITY_QUEUE: {},
    HIGH_MEM_QUEUE: {},
}

# If we're a worker on the high_mem queue, set ourselves to die after processing
# one request to avoid having memory leaks take down the worker server. This env
# var is set in /etc/init/edx-workers.conf -- this should probably be replaced
# with some celery API call to see what queue we started listening to, but I
# don't know what that call is or if it's active at this point in the code.
if os.environ.get('QUEUE') == 'high_mem':
    CELERYD_MAX_TASKS_PER_CHILD = 1


########################## NON-SECURE ENV CONFIG ##############################
# Things like server locations, ports, etc.

with open(CONFIG_ROOT / CONFIG_PREFIX + "env.json") as env_file:
    ENV_TOKENS = json.load(env_file)

# STATIC_ROOT specifies the directory where static files are
# collected
STATIC_ROOT_BASE = ENV_TOKENS.get('STATIC_ROOT_BASE', None)
if STATIC_ROOT_BASE:
    STATIC_ROOT = path(STATIC_ROOT_BASE)


# STATIC_URL_BASE specifies the base url to use for static files
STATIC_URL_BASE = ENV_TOKENS.get('STATIC_URL_BASE', None)
if STATIC_URL_BASE:
    # collectstatic will fail if STATIC_URL is a unicode string
    STATIC_URL = STATIC_URL_BASE.encode('ascii')
    if not STATIC_URL.endswith("/"):
        STATIC_URL += "/"

PLATFORM_NAME = ENV_TOKENS.get('PLATFORM_NAME', PLATFORM_NAME)
# For displaying on the receipt. At Stanford PLATFORM_NAME != MERCHANT_NAME, but PLATFORM_NAME is a fine default
CC_MERCHANT_NAME = ENV_TOKENS.get('CC_MERCHANT_NAME', PLATFORM_NAME)
EMAIL_BACKEND = ENV_TOKENS.get('EMAIL_BACKEND', EMAIL_BACKEND)
EMAIL_FILE_PATH = ENV_TOKENS.get('EMAIL_FILE_PATH', None)
EMAIL_HOST = ENV_TOKENS.get('EMAIL_HOST', 'mail.pmph.com')  # django default is localhost
EMAIL_PORT = ENV_TOKENS.get('EMAIL_PORT', 25)  # django default is 25
EMAIL_USE_TLS = ENV_TOKENS.get('EMAIL_USE_TLS', False)  # django default is False
SITE_NAME = ENV_TOKENS['SITE_NAME']
SESSION_ENGINE = ENV_TOKENS.get('SESSION_ENGINE', SESSION_ENGINE)
SESSION_COOKIE_DOMAIN = ENV_TOKENS.get('SESSION_COOKIE_DOMAIN')
REGISTRATION_EXTRA_FIELDS = ENV_TOKENS.get('REGISTRATION_EXTRA_FIELDS', REGISTRATION_EXTRA_FIELDS)

CMS_BASE = ENV_TOKENS.get('CMS_BASE', 'studio.edx.org')

# allow for environments to specify what cookie name our login subsystem should use
# this is to fix a bug regarding simultaneous logins between edx.org and edge.edx.org which can
# happen with some browsers (e.g. Firefox)
if ENV_TOKENS.get('SESSION_COOKIE_NAME', None):
    # NOTE, there's a bug in Django (http://bugs.python.org/issue18012) which necessitates this being a str()
    SESSION_COOKIE_NAME = str(ENV_TOKENS.get('SESSION_COOKIE_NAME'))

BOOK_URL = ENV_TOKENS['BOOK_URL']
MEDIA_URL = ENV_TOKENS['MEDIA_URL']
LOG_DIR = ENV_TOKENS['LOG_DIR']

CACHES = ENV_TOKENS['CACHES']
# Cache used for location mapping -- called many times with the same key/value
# in a given request.
if 'loc_cache' not in CACHES:
    CACHES['loc_cache'] = {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
        'LOCATION': 'edx_location_mem_cache',
    }

# Email overrides
DEFAULT_FROM_EMAIL = ENV_TOKENS.get('DEFAULT_FROM_EMAIL', DEFAULT_FROM_EMAIL)
DEFAULT_FEEDBACK_EMAIL = ENV_TOKENS.get('DEFAULT_FEEDBACK_EMAIL', DEFAULT_FEEDBACK_EMAIL)
ADMINS = ENV_TOKENS.get('ADMINS', ADMINS)
SERVER_EMAIL = ENV_TOKENS.get('SERVER_EMAIL', SERVER_EMAIL)
TECH_SUPPORT_EMAIL = ENV_TOKENS.get('TECH_SUPPORT_EMAIL', TECH_SUPPORT_EMAIL)
CONTACT_EMAIL = ENV_TOKENS.get('CONTACT_EMAIL', CONTACT_EMAIL)
BUGS_EMAIL = ENV_TOKENS.get('BUGS_EMAIL', BUGS_EMAIL)
PAYMENT_SUPPORT_EMAIL = ENV_TOKENS.get('PAYMENT_SUPPORT_EMAIL', PAYMENT_SUPPORT_EMAIL)
PAID_COURSE_REGISTRATION_CURRENCY = ENV_TOKENS.get('PAID_COURSE_REGISTRATION_CURRENCY',
                                                   PAID_COURSE_REGISTRATION_CURRENCY)

# Payment Report Settings
PAYMENT_REPORT_GENERATOR_GROUP = ENV_TOKENS.get('PAYMENT_REPORT_GENERATOR_GROUP', PAYMENT_REPORT_GENERATOR_GROUP)

# Bulk Email overrides
BULK_EMAIL_DEFAULT_FROM_EMAIL = ENV_TOKENS.get('BULK_EMAIL_DEFAULT_FROM_EMAIL', BULK_EMAIL_DEFAULT_FROM_EMAIL)
BULK_EMAIL_EMAILS_PER_TASK = ENV_TOKENS.get('BULK_EMAIL_EMAILS_PER_TASK', BULK_EMAIL_EMAILS_PER_TASK)
BULK_EMAIL_EMAILS_PER_QUERY = ENV_TOKENS.get('BULK_EMAIL_EMAILS_PER_QUERY', BULK_EMAIL_EMAILS_PER_QUERY)
BULK_EMAIL_DEFAULT_RETRY_DELAY = ENV_TOKENS.get('BULK_EMAIL_DEFAULT_RETRY_DELAY', BULK_EMAIL_DEFAULT_RETRY_DELAY)
BULK_EMAIL_MAX_RETRIES = ENV_TOKENS.get('BULK_EMAIL_MAX_RETRIES', BULK_EMAIL_MAX_RETRIES)
BULK_EMAIL_INFINITE_RETRY_CAP = ENV_TOKENS.get('BULK_EMAIL_INFINITE_RETRY_CAP', BULK_EMAIL_INFINITE_RETRY_CAP)
BULK_EMAIL_LOG_SENT_EMAILS = ENV_TOKENS.get('BULK_EMAIL_LOG_SENT_EMAILS', BULK_EMAIL_LOG_SENT_EMAILS)
BULK_EMAIL_RETRY_DELAY_BETWEEN_SENDS = ENV_TOKENS.get('BULK_EMAIL_RETRY_DELAY_BETWEEN_SENDS', BULK_EMAIL_RETRY_DELAY_BETWEEN_SENDS)
# We want Bulk Email running on the high-priority queue, so we define the
# routing key that points to it.  At the moment, the name is the same.
# We have to reset the value here, since we have changed the value of the queue name.
BULK_EMAIL_ROUTING_KEY = HIGH_PRIORITY_QUEUE

# Theme overrides
THEME_NAME = ENV_TOKENS.get('THEME_NAME', None)

# Marketing link overrides
MKTG_URL_LINK_MAP.update(ENV_TOKENS.get('MKTG_URL_LINK_MAP', {}))

# Timezone overrides
TIME_ZONE = ENV_TOKENS.get('TIME_ZONE', TIME_ZONE)

# Translation overrides
LANGUAGES = ENV_TOKENS.get('LANGUAGES', LANGUAGES)
LANGUAGE_CODE = ENV_TOKENS.get('LANGUAGE_CODE', LANGUAGE_CODE)
USE_I18N = ENV_TOKENS.get('USE_I18N', USE_I18N)

# Additional installed apps
for app in ENV_TOKENS.get('ADDL_INSTALLED_APPS', []):
    INSTALLED_APPS += (app,)

ENV_FEATURES = ENV_TOKENS.get('FEATURES', ENV_TOKENS.get('MITX_FEATURES', {}))
for feature, value in ENV_FEATURES.items():
    FEATURES[feature] = value

WIKI_ENABLED = ENV_TOKENS.get('WIKI_ENABLED', WIKI_ENABLED)
local_loglevel = ENV_TOKENS.get('LOCAL_LOGLEVEL', 'INFO')

LOGGING = get_logger_config(LOG_DIR,
                            logging_env=ENV_TOKENS['LOGGING_ENV'],
                            syslog_addr=(ENV_TOKENS['SYSLOG_SERVER'], 514),
                            local_loglevel=local_loglevel,
                            debug=False,
                            service_variant=SERVICE_VARIANT)

COURSE_LISTINGS = ENV_TOKENS.get('COURSE_LISTINGS', {})
SUBDOMAIN_BRANDING = ENV_TOKENS.get('SUBDOMAIN_BRANDING', {})
VIRTUAL_UNIVERSITIES = ENV_TOKENS.get('VIRTUAL_UNIVERSITIES', [])
META_UNIVERSITIES = ENV_TOKENS.get('META_UNIVERSITIES', {})
COMMENTS_SERVICE_URL = ENV_TOKENS.get("COMMENTS_SERVICE_URL", '')
COMMENTS_SERVICE_KEY = ENV_TOKENS.get("COMMENTS_SERVICE_KEY", '')
CERT_QUEUE = ENV_TOKENS.get("CERT_QUEUE", 'test-pull')
ZENDESK_URL = ENV_TOKENS.get("ZENDESK_URL")
FEEDBACK_SUBMISSION_EMAIL = ENV_TOKENS.get("FEEDBACK_SUBMISSION_EMAIL")
MKTG_URLS = ENV_TOKENS.get('MKTG_URLS', MKTG_URLS)

# git repo loading  environment
GIT_REPO_DIR = ENV_TOKENS.get('GIT_REPO_DIR', '/edx/var/edxapp/course_repos')
GIT_IMPORT_STATIC = ENV_TOKENS.get('GIT_IMPORT_STATIC', True)

for name, value in ENV_TOKENS.get("CODE_JAIL", {}).items():
    oldvalue = CODE_JAIL.get(name)
    if isinstance(oldvalue, dict):
        for subname, subvalue in value.items():
            oldvalue[subname] = subvalue
    else:
        CODE_JAIL[name] = value

COURSES_WITH_UNSAFE_CODE = ENV_TOKENS.get("COURSES_WITH_UNSAFE_CODE", [])

# Event Tracking
if "TRACKING_IGNORE_URL_PATTERNS" in ENV_TOKENS:
    TRACKING_IGNORE_URL_PATTERNS = ENV_TOKENS.get("TRACKING_IGNORE_URL_PATTERNS")

# SSL external authentication settings
SSL_AUTH_EMAIL_DOMAIN = ENV_TOKENS.get("SSL_AUTH_EMAIL_DOMAIN", "MIT.EDU")
SSL_AUTH_DN_FORMAT_STRING = ENV_TOKENS.get("SSL_AUTH_DN_FORMAT_STRING",
                                           "/C=US/ST=Massachusetts/O=Massachusetts Institute of Technology/OU=Client CA v1/CN={0}/emailAddress={1}")

HOSTNAME_MODULESTORE_DEFAULT_MAPPINGS = ENV_TOKENS.get('HOSTNAME_MODULESTORE_DEFAULT_MAPPINGS',{})

############################## SECURE AUTH ITEMS ###############
# Secret things: passwords, access keys, etc.

with open(CONFIG_ROOT / CONFIG_PREFIX + "auth.json") as auth_file:
    AUTH_TOKENS = json.load(auth_file)

############### Mixed Related(Secure/Not-Secure) Items ##########
# If Segment.io key specified, load it and enable Segment.io if the feature flag is set
SEGMENT_IO_LMS_KEY = AUTH_TOKENS.get('SEGMENT_IO_LMS_KEY')
if SEGMENT_IO_LMS_KEY:
    FEATURES['SEGMENT_IO_LMS'] = ENV_TOKENS.get('SEGMENT_IO_LMS', False)

CC_PROCESSOR = AUTH_TOKENS.get('CC_PROCESSOR', CC_PROCESSOR)

SECRET_KEY = AUTH_TOKENS['SECRET_KEY']

AWS_ACCESS_KEY_ID = AUTH_TOKENS["AWS_ACCESS_KEY_ID"]
if AWS_ACCESS_KEY_ID == "":
    AWS_ACCESS_KEY_ID = None

AWS_SECRET_ACCESS_KEY = AUTH_TOKENS["AWS_SECRET_ACCESS_KEY"]
if AWS_SECRET_ACCESS_KEY == "":
    AWS_SECRET_ACCESS_KEY = None

AWS_STORAGE_BUCKET_NAME = AUTH_TOKENS.get('AWS_STORAGE_BUCKET_NAME', 'edxuploads')

# If there is a database called 'read_replica', you can use the use_read_replica_if_available
# function in util/query.py, which is useful for very large database reads
DATABASES = AUTH_TOKENS['DATABASES']

XQUEUE_INTERFACE = AUTH_TOKENS['XQUEUE_INTERFACE']

# Get the MODULESTORE from auth.json, but if it doesn't exist,
# use the one from common.py
MODULESTORE = AUTH_TOKENS.get('MODULESTORE', MODULESTORE)
CONTENTSTORE = AUTH_TOKENS.get('CONTENTSTORE', CONTENTSTORE)
DOC_STORE_CONFIG = AUTH_TOKENS.get('DOC_STORE_CONFIG',DOC_STORE_CONFIG)
MONGODB_LOG = AUTH_TOKENS.get('MONGODB_LOG', {})

OPEN_ENDED_GRADING_INTERFACE = AUTH_TOKENS.get('OPEN_ENDED_GRADING_INTERFACE',
                                               OPEN_ENDED_GRADING_INTERFACE)

EMAIL_HOST_USER = AUTH_TOKENS.get('EMAIL_HOST_USER', '')  # django default is ''
EMAIL_HOST_PASSWORD = AUTH_TOKENS.get('EMAIL_HOST_PASSWORD', '')  # django default is ''

# Datadog for events!
DATADOG = AUTH_TOKENS.get("DATADOG", {})
DATADOG.update(ENV_TOKENS.get("DATADOG", {}))

# TODO: deprecated (compatibility with previous settings)
if 'DATADOG_API' in AUTH_TOKENS:
    DATADOG['api_key'] = AUTH_TOKENS['DATADOG_API']

# Analytics dashboard server
ANALYTICS_SERVER_URL = ENV_TOKENS.get("ANALYTICS_SERVER_URL")
ANALYTICS_API_KEY = AUTH_TOKENS.get("ANALYTICS_API_KEY", "")

# Zendesk
ZENDESK_USER = AUTH_TOKENS.get("ZENDESK_USER")
ZENDESK_API_KEY = AUTH_TOKENS.get("ZENDESK_API_KEY")

# API Key for inbound requests from Notifier service
EDX_API_KEY = AUTH_TOKENS.get("EDX_API_KEY")

# Celery Broker
CELERY_BROKER_TRANSPORT = ENV_TOKENS.get("CELERY_BROKER_TRANSPORT", "")
CELERY_BROKER_HOSTNAME = ENV_TOKENS.get("CELERY_BROKER_HOSTNAME", "")
CELERY_BROKER_VHOST = ENV_TOKENS.get("CELERY_BROKER_VHOST", "")
CELERY_BROKER_USER = AUTH_TOKENS.get("CELERY_BROKER_USER", "")
CELERY_BROKER_PASSWORD = AUTH_TOKENS.get("CELERY_BROKER_PASSWORD", "")

BROKER_URL = "{0}://{1}:{2}@{3}/{4}".format(CELERY_BROKER_TRANSPORT,
                                            CELERY_BROKER_USER,
                                            CELERY_BROKER_PASSWORD,
                                            CELERY_BROKER_HOSTNAME,
                                            CELERY_BROKER_VHOST)

# upload limits
STUDENT_FILEUPLOAD_MAX_SIZE = ENV_TOKENS.get("STUDENT_FILEUPLOAD_MAX_SIZE", STUDENT_FILEUPLOAD_MAX_SIZE)

# Event tracking
TRACKING_BACKENDS.update(AUTH_TOKENS.get("TRACKING_BACKENDS", {}))

# Student identity verification settings
VERIFY_STUDENT = AUTH_TOKENS.get("VERIFY_STUDENT", VERIFY_STUDENT)

# Grades download
GRADES_DOWNLOAD_ROUTING_KEY = HIGH_MEM_QUEUE

GRADES_DOWNLOAD = ENV_TOKENS.get("GRADES_DOWNLOAD", GRADES_DOWNLOAD)

##### ACCOUNT LOCKOUT DEFAULT PARAMETERS #####
MAX_FAILED_LOGIN_ATTEMPTS_ALLOWED = ENV_TOKENS.get("MAX_FAILED_LOGIN_ATTEMPTS_ALLOWED", 5)
MAX_FAILED_LOGIN_ATTEMPTS_LOCKOUT_PERIOD_SECS = ENV_TOKENS.get("MAX_FAILED_LOGIN_ATTEMPTS_LOCKOUT_PERIOD_SECS", 15 * 60)

MICROSITE_CONFIGURATION = ENV_TOKENS.get('MICROSITE_CONFIGURATION', {})
MICROSITE_ROOT_DIR = path(ENV_TOKENS.get('MICROSITE_ROOT_DIR', ''))

#### PASSWORD POLICY SETTINGS #####
PASSWORD_MIN_LENGTH = ENV_TOKENS.get("PASSWORD_MIN_LENGTH")
PASSWORD_MAX_LENGTH = ENV_TOKENS.get("PASSWORD_MAX_LENGTH")
PASSWORD_COMPLEXITY = ENV_TOKENS.get("PASSWORD_COMPLEXITY", {})
PASSWORD_DICTIONARY_EDIT_DISTANCE_THRESHOLD = ENV_TOKENS.get("PASSWORD_DICTIONARY_EDIT_DISTANCE_THRESHOLD")
PASSWORD_DICTIONARY = ENV_TOKENS.get("PASSWORD_DICTIONARY", [])

### INACTIVITY SETTINGS ####
SESSION_INACTIVITY_TIMEOUT_IN_SECONDS = AUTH_TOKENS.get("SESSION_INACTIVITY_TIMEOUT_IN_SECONDS")

##### LMS DEADLINE DISPLAY TIME_ZONE #######
TIME_ZONE_DISPLAYED_FOR_DEADLINES = ENV_TOKENS.get("TIME_ZONE_DISPLAYED_FOR_DEADLINES",
                                                   TIME_ZONE_DISPLAYED_FOR_DEADLINES)

##### X-Frame-Options response header settings #####
X_FRAME_OPTIONS = ENV_TOKENS.get('X_FRAME_OPTIONS', X_FRAME_OPTIONS)

############# Config Thesaurus File Path##############################
load_thesaurus_path = CONFIG_ROOT / CONFIG_PREFIX + "thesaurus.yml"
if not os.path.exists(load_thesaurus_path):
    open(str(load_thesaurus_path), 'a').close()

THESAURUS_PATH = load_thesaurus_path
