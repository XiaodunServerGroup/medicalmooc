"""
URL patterns for Javascript files used to load all of the XModule JS in one wad.
"""
from django.conf.urls import url, patterns

urlpatterns = patterns('syscustom.views',  # nopep8
    url(r'^$', 'syscustom', name="syscustom"),
    url(r'^statistics/$', 'statistics_code', name="statistics_code"),
    
    url(r'^indexluobo/$', 'indexluobo', name="indexluobo"),
    url(r'^indexluobo/add/$', 'luobo_edit', name="luobo_edit"),
    url(r'^indexluobo/(?P<id>\d+)/edit/$', 'luobo_edit', name="luobo_edit"),
    url(r'^luobo/delete/$', 'luobo_delete', name="luobo_delete"),
    url(r'^image/upload/$', 'image_upload', name="image_upload"),
)

urlpatterns += patterns('',  # bootlogo
    url(r'^bootlogo/$', 'syscustom.views.bootlogo.bootlogo', name="bootlogo"),
    url(r'^bootlogo/add/$', 'syscustom.views.bootlogo.bootlogo_edit', name="bootlogo_edit"),
    url(r'^bootlogo/(?P<id>\d+)/edit/$', 'syscustom.views.bootlogo.bootlogo_edit', name="bootlogo_edit"),
)

urlpatterns += patterns('',  # clientluobo
    url(r'^clientluobo/$', 'syscustom.views.clientluobo.clientluobo', name="clientluobo"),
    url(r'^clientluobo/add/$', 'syscustom.views.clientluobo.clientluobo_edit', name="clientluobo_edit"),
    url(r'^clientluobo/(?P<id>\d+)/edit/$', 'syscustom.views.clientluobo.clientluobo_edit', name="clientluobo_edit"),
)
