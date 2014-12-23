#coding:utf-8
"""
Views for returning XModule JS (used by requirejs)
"""
import os
import json
import datetime

from django.contrib.auth.decorators import login_required
from django_future.csrf import ensure_csrf_cookie
from django.conf import settings
from django.http import HttpResponse
from django.shortcuts import redirect
from django.core.urlresolvers import reverse

from util.json_request import JsonResponse
from edxmako.shortcuts import render_to_response


from ..models import *
from ..image import *
from .perm import is_super



_type_list = []
_type_ids = []
for item in settings.CUSTOM_IMAGE_CLASS:
    if item[1].find(u'启动图')>-1:
        _type_list.append(item)
        _type_ids.append(item[0])

@login_required
@is_super
@ensure_csrf_cookie
def bootlogo(request):
    image_list = CustomImage.objects.filter(type__in=_type_ids).order_by('type', 'id')
    return render_to_response('syscustom/bootlogo.html', {'store_url':settings.STORE_URL, 'image_list':image_list, 'type_list':_type_list})

@login_required
@is_super
@ensure_csrf_cookie
def bootlogo_edit(request, id=None):
    if request.method == 'POST':
        image = request.POST.get('image', '')
        type = request.POST.get('type', '')
        order_num = request.POST.get('order_num')
        try:
            order_num = int(order_num)
        except:
            order_num = 1
        
        if id:
            obj = CustomImage.objects.get(id=id)
            obj.updated_time = datetime.datetime.now()
        else:
            obj = CustomImage()
        obj.img = image
        obj.order_num = order_num
        obj.type = type
        obj.save()
        
        return redirect(reverse('bootlogo'))
    else:
        obj = None
        if id:
            obj = CustomImage.objects.get(id=id)
        return render_to_response('syscustom/bootlogo_edit.html', {'obj':obj, 'type_list':_type_list})

    

