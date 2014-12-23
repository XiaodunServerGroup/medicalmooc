#coding:utf-8
import json
from django.http import HttpResponse
from django.conf import settings

from util.json_request import JsonResponse
from syscustom.models import CustomImage
from syscustom.models import CourseClass
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


def get_courseclass(request):
    class_list = CourseClass.objects.all().order_by('order_num', 'id')
    
    classes = [{'code':obj.code, 'name':obj.name} for obj in class_list]
    data = {'count':len(classes), 'classes':classes}
    return JsonResponse(data)
    
    
    
    
    

