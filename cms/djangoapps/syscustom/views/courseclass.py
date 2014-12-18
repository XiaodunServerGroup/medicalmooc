#coding:utf-8
from django.contrib.auth.decorators import login_required
from django_future.csrf import ensure_csrf_cookie
from django.conf import settings
from django.http import HttpResponse,HttpResponseRedirect
from django.shortcuts import redirect
from django.core.urlresolvers import reverse
from util.json_request import JsonResponse
from edxmako.shortcuts import render_to_response

import datetime
from  syscustom.models import CourseClass

from .perm import is_super

@login_required
@is_super
@ensure_csrf_cookie
def courseclass_list(request):
    courseclass_list= CourseClass.objects.all().order_by('order_num', 'id')
    return render_to_response('syscustom/courseclass_list.html', {'courseclass_list':courseclass_list})

@login_required
@is_super
@ensure_csrf_cookie
def courseclass_edit(request, id=None):
    if request.method == 'POST':
        id = request.POST.get('id', 0)
        code = request.POST.get('code').strip()
        name = request.POST.get('name').strip()
        order_num = request.POST.get('order_num').strip()
        
        count = CourseClass.objects.exclude(id=(id and id or -1)).filter(code=code).count()
        if count:
            return JsonResponse({'error':u'分类代码已存在'})
        
        try:
            order_num = int(order_num)
        except:
            order_num = 1
        
        if id:
            obj = CourseClass.objects.get(id=id)
            obj.updated_time = datetime.datetime.now()
        else:
            obj = CourseClass()
            
        obj.code=code
        obj.name=name
        obj.order_num = order_num
        obj.save()
        
        return JsonResponse({'status':'1','to_url': reverse('courseclass_list')})
    else:
        obj = None
        if id:
            obj = CourseClass.objects.get(id=id)
        return render_to_response('syscustom/courseclass_edit.html', {'obj':obj})


@login_required
@is_super
@ensure_csrf_cookie
def courseclass_del(request):
    id =request.GET.get('id',0)
    courseclass = CourseClass.objects.get(id=id)
    courseclass.delete()
    return HttpResponseRedirect(reverse('courseclass_list'))
