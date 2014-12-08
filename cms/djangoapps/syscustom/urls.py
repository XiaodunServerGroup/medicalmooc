"""
URL patterns for Javascript files used to load all of the XModule JS in one wad.
"""
from django.conf.urls import url, patterns

urlpatterns = patterns('syscustom.views',  # nopep8
    url(r'^$', 'syscustom'),
)
