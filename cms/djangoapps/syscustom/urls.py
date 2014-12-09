"""
URL patterns for Javascript files used to load all of the XModule JS in one wad.
"""
from django.conf.urls import url, patterns

urlpatterns = patterns('syscustom.views',  # nopep8
    url(r'^$', 'syscustom'),
    url(r'^courseclass$',  'courseclass_list',name="courseclass_list" ),
    url(r'^courseclass/add/$',   'courseclass_add',name="courseclass_add" ),
    url(r'^courseclass/update$',   'courseclass_update',name="courseclass_update" ),
    url(r'^courseclass/del$', 'courseclass_del',name="courseclass_del" ),

)
