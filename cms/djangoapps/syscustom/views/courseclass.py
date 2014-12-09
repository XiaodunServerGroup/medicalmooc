"""
Views for returning XModule JS (used by requirejs)
"""
from django.contrib.auth.decorators import login_required
from django_future.csrf import ensure_csrf_cookie
from django.conf import settings
from django.http import HttpResponse,HttpResponseRedirect
from util.json_request import JsonResponse
from edxmako.shortcuts import render_to_response

import datetime
from  syscustom.models import CourseClass
from datetime import timedelta

@login_required
@ensure_csrf_cookie
def courseclass_list(request):
    courseclass_list= CourseClass.objects.all()
    return render_to_response('syscustom/courseclass_list.html', {'courseclass_list':courseclass_list})

@ensure_csrf_cookie
def courseclass_add(request):
    print request.POST
    if request.method == 'POST':
        code = request.POST.get('code')
        name = request.POST.get('name')
        order_num = request.POST.get('order_num')
        courseclass =CourseClass(code=code,name=name,order_num=order_num)
        try:
            courseclass.save()
        except:
            pass
        return HttpResponseRedirect('/syscustom/courseclass')
    return render_to_response('syscustom/courseclass_add.html')

@ensure_csrf_cookie
def courseclass_update(request):
    id =request.GET.get('id',0)
    if id:
        courseclass_list = CourseClass.objects.get(id=id)

    if request.method =='POST':
        code=request.POST.get('code')
        name=request.POST.get('name')
        order_num = request.POST.get('order_num')
        courseclass = CourseClass.objects.get(code=code)
        courseclass.name = name
        courseclass.order_num = order_num
#        cha 8hour
        update_time= datetime.datetime.now()
        courseclass.updated_time =update_time.strftime("%Y-%m-%d %H:%M:%S")
        try:
            courseclass.save()
        except:
            pass
        return HttpResponseRedirect('/syscustom/courseclass')

    return render_to_response('syscustom/courseclass_update.html', {'courseclass_list':courseclass_list})

@ensure_csrf_cookie
def courseclass_del(request):
    id =request.GET.get('id',0)
    courseclass = CourseClass.objects.get(id=id)
    courseclass.delete()
    return HttpResponseRedirect('/syscustom/courseclass')
