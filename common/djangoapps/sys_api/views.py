#coding:utf-8
import json
from django.http import HttpResponse
from django.conf import settings

from util.json_request import JsonResponse
from syscustom.models import CustomImage
from syscustom.models import CourseClass

from xmodule.contentstore.content import StaticContent
from student.roles import CourseInstructorRole, CourseStaffRole
from django.contrib.auth.models import  AnonymousUser
from courseware.courses import course_image_url,get_courses,get_course_about_section
from courseware.views import mobi_course_info,registered_for_course
from student.models import UserTestGroup, CourseEnrollment, UserProfile


def boot_image(request, client_type):
    try:
        obj = CustomImage.objects.filter(type=client_type).order_by('order_num', 'id')[-1:]
        if obj and obj[0]:
            data = {'type':client_type, 'image':obj.get_image_url()}
    except:
        data = {'type':client_type, 'image':''}
    return JsonResponse(data)



def luobo_image(request, client_type):
    try:
        img_list = CustomImage.objects.filter(type=client_type).order_by('order_num', 'id')
        
        images = [{'url':obj.url, 'image':obj.get_image_url()} for obj in img_list]
        data = {'type':client_type, 'images':images}
    except:
        data = {'type':client_type, 'image':images}
    return JsonResponse(data)

def  luobo_image_courseinfo(request,luoboimg_id):
    try:
        user = request.user
    except:
        user = AnonymousUser()
    courses = get_courses(user, request.META.get('HTTP_HOST'))

    try:
        obj = CustomImage.objects.get(id=luoboimg_id)
    except:
        return  JsonResponse({'error': u'轮播图不存在'})

    url_split=obj.url.split('/')
    course_id = '%s/%s/%s' % (url_split[-4],url_split[-3],url_split[-2])

    for  course in courses:
        if course.id == course_id:
            try:
                course_json = mobi_course_info(request, course)
            except:
                continue
    return JsonResponse({"courseinfo": course_json})


def get_courseclass(request):
    class_list = CourseClass.objects.all().order_by('order_num', 'id')
    
    classes = [{'code':obj.code, 'name':obj.name} for obj in class_list]
    data = {'count':len(classes), 'classes':classes}
    return JsonResponse(data)
    
    
    
    
    

