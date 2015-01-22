#coding:utf-8
import json
from django.http import HttpResponse
from django.conf import settings
from xmodule.modulestore.exceptions import InvalidLocationError, ItemNotFoundError, NoPathToItem
from xmodule.modulestore import Location
from student.views import course_from_id, single_course_reverification_info
from student.models import UserTestGroup, CourseEnrollment
from dogapi import dog_stats_api
from course_modes.models import CourseMode
from courseware.access import has_access
from util.json_request import JsonResponse
from util.common import *
from syscustom.models import *

from xmodule.modulestore.django import modulestore
from courseware.views import mobi_course_info,registered_for_course

def boot_image(request, client_type):
    try:
        obj = CustomImage.objects.filter(type=client_type).order_by('-order_num', '-id')[:1]
        if obj and obj[0]:
            data = {'type':client_type, 'image':obj[0].get_image_url()}
        else:
            data = {'type':client_type, 'image':''}
    except:
        data = {'type':client_type, 'image':''}
    return JsonResponse(data)

type_list = [settings.CUSTOM_IMAGE_CLASS[1], settings.CUSTOM_IMAGE_CLASS[2],settings.CUSTOM_IMAGE_CLASS[3],settings.CUSTOM_IMAGE_CLASS[4]]
def luobo_image(request, client_type):
    try:
        course_list =[]
        type_list_key =[type[0] for type in type_list]
        client_type = int(client_type)
        img_list = CustomImage.objects.filter(type=client_type).order_by('order_num', 'id')
        if client_type in  type_list_key:
            for obj in img_list:
                try:
                    course_id ='%s/%s/%s' % (obj.url.split('/')[-4],obj.url.split('/')[-3],obj.url.split('/')[-2])
                    course=modulestore().get_course(course_id)
                    course_json = mobi_course_info(request, course)
                    course_json['image']= obj.get_image_url()
                    course_list.append(course_json)
                except :
                    continue
            return JsonResponse({'count':len(course_list),'course-list':course_list})
        else:
            images = [{'url':obj.url, 'image':obj.get_image_url()} for obj in img_list]
            data = {'type':client_type, 'images':images}
    except:
        data = {'type':client_type, 'image':images}
    return JsonResponse(data)

def get_courseclass(request):
    class_list = CourseClass.objects.all().order_by('order_num', 'id')
    
    classes = [{'code':obj.code, 'name':obj.name} for obj in class_list]
    data = {'count':len(classes), 'classes':classes}
    return JsonResponse(data)
    
    
def reg_course(request):
    input = request.GET.get('input','')
    try:
        des_str = des_decrypt(input)
    except:
        return JsonResponse({'error':'decrypt error'})
    print des_str
    # des_str :uuid&username
    des_str = des_str.split("&")
    if(len(des_str)==2):
        uuid = des_str[0]
        username = des_str[1]
    else:
        return JsonResponse({'error':'param error'})
    
    try:
        user = User.objects.get(username=username)
    except User.DoesNotExist:
        return JsonResponse({'error':'user not exist'})
    
    try:
        c = CourseUuid.objects.get(uuid=uuid)
        course_id = c.course_id
    except CourseUuid.DoesNotExist:
        return JsonResponse({'error':'uuid course not exist'})
    
    try:
        course = course_from_id(course_id)
    except ItemNotFoundError:
        log.warning("User {0} tried to enroll in non-existent course {1}"
                    .format(user.username, course_id))
        return JsonResponse({'error':'Course id is invalid'})

    if not has_access(user, course, 'enroll'):
        return JsonResponse({'error':'Enrollment is closed'})

    # see if we have already filled up all allowed enrollments
    is_course_full = CourseEnrollment.is_course_full(course)

    if is_course_full:
        return JsonResponse({'error':'Course is full'})

    # If this course is available in multiple modes, redirect them to a page
    # where they can choose which mode they want.
    available_modes = CourseMode.modes_for_course(course_id)
    if len(available_modes) > 1:
        return JsonResponse({'error': reverse("course_modes_choose", kwargs={'course_id': course_id})})
      #  return HttpResponse(
      #      reverse("course_modes_choose", kwargs={'course_id': course_id})
      #  )

    current_mode = available_modes[0]

    course_id_dict = Location.parse_course_id(course_id)
    dog_stats_api.increment(
        "common.student.enrollment",
        tags=[u"org:{org}".format(**course_id_dict),
              u"course:{course}".format(**course_id_dict),
              u"run:{name}".format(**course_id_dict)]
    )

    CourseEnrollment.enroll(user, course.id, mode=current_mode.slug)
    
    
    try:
        UserBuyCourse.objects.create(user_id=user.id, course_id=course_id)
    except:
        import traceback
        print traceback.format_exc()

    return JsonResponse({'status':'1', 'msg':'Enrollment Success'})
    
    
def is_buy(request):
    course_id = request.POST.get('cid', '')
    
    try:
        user_id = request.user.id
        count = UserBuyCourse.objects.filter(user_id=user_id, course_id=course_id).count()
        if count:
            return JsonResponse({'status':'1'})
        
    except:
        import traceback
        print traceback.format_exc()
    
    return JsonResponse({'status':'0'})