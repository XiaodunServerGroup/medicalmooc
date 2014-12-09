"""
Views for returning XModule JS (used by requirejs)
"""
import os
import codecs
import json

from django.contrib.auth.decorators import login_required
from django_future.csrf import ensure_csrf_cookie
from django.conf import settings
from django.http import HttpResponse
from util.json_request import JsonResponse
from edxmako.shortcuts import render_to_response


@login_required
@ensure_csrf_cookie
def statistics_code(request):
    statictics_code_tempate = os.path.join(settings.STORE_ROOT, settings.STATISTICS_CODE_TEMPLATE)
    
    if request.method == 'POST':
        content = request.POST.get('content')
        f = codecs.open(statictics_code_tempate, 'w', 'utf-8')
        f.write(content)
        f.close()
        return JsonResponse({'status':1})
    else:
        if not os.path.exists(statictics_code_tempate):
            f = codecs.open(statictics_code_tempate, 'w', 'utf-8')
            f.write('')
            f.close()
        
        f = open(statictics_code_tempate, "r")
        content = f.read()
        f.close()
        
        return render_to_response('syscustom/statictics_code.html', {'content':content})


