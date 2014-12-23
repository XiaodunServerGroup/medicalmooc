"""
Views for returning XModule JS (used by requirejs)
"""
import os
import json

from django.contrib.auth.decorators import login_required
from django_future.csrf import ensure_csrf_cookie
from django.conf import settings
from django.http import HttpResponse
from util.json_request import JsonResponse
from edxmako.shortcuts import render_to_response

from .perm import is_super

@login_required
@is_super
@ensure_csrf_cookie
def syscustom(request):
    current_logo_url = '/store/images/logo.png'
    current_logo_path = os.path.join(settings.STORE_ROOT, 'images/logo.png')
    
    if request.method == 'POST':
        id = request.POST.get('id', 0)
        type = request.POST.get('type')
        
        if 'file' in request.FILES:   
            img_data = request.FILES['file']
            fp = open(current_logo_path, 'wb') 
            for content in img_data.chunks():
                fp.write(content)
            fp.close()
            return JsonResponse({'status':1})
        else:
            return JsonResponse({'status':0})
    
    if not os.path.exists(current_logo_path):
        current_logo_url = ''
    
    return render_to_response('syscustom/syscustom_index.html', {'current_logo_url':current_logo_url})


