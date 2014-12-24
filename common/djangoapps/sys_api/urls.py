from django.conf.urls import include, patterns, url
from .views import *

urlpatterns = patterns('',
    url(r'^bootimg/(?P<client_type>\d+)/$', boot_image, name="bootimg"),
    url(r'^luoboimg/(?P<client_type>\d+)/$', luobo_image, name="luoboimage"),
    url(r'^luoboimg/(?P<luoboimg_id>\d+)/info/$', luobo_image_courseinfo, name="luoboimagecourseinfo"),
    url(r'^courseclass/all/$', get_courseclass, name="courseclass"),
)
