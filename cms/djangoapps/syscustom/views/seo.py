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
def seo(request):
    seo_tempate = os.path.join(settings.STORE_ROOT, settings.SEO_TEMPLATE)
    params = {
              'index_page_keyword':'',
              'index_page_desc':'',
              'list_page_keyword':'',
              'list_page_desc':'',
              'intro_page_keyword':'',
              'intro_page_desc':'',
              }
    
    
    if request.method == 'POST':
        for k in params.keys():
            params[k] = request.POST.get(k, '')
        
        content = json.dumps(params)
        
        f = codecs.open(seo_tempate, 'w', 'utf-8')
        f.write(content)
        f.close()
        return JsonResponse({'status':1})
    else:
        if not os.path.exists(seo_tempate):
            f = codecs.open(seo_tempate, 'w', 'utf-8')
            f.write('')
            f.close()
        
        f = open(seo_tempate, "r")
        content = f.read()
        f.close()
        
        try:
            content = json.loads(content)
            params.update(content)
        except:
            pass
        print params
        return render_to_response('syscustom/seo.html', params)


