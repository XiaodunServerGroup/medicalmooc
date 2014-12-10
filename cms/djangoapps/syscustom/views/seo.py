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

seo_tempate = settings.SEO_TEMPLATE_PATH
global seo_mtime
seo_mtime = 0
seo_class_dict = {
              'index_page_keyword':'',
              'index_page_desc':'',
              'list_page_keyword':'',
              'list_page_desc':'',
              'intro_page_keyword':'',
              'intro_page_desc':'',
              }

def _init_seo_data():
    global seo_mtime
    if not os.path.exists(seo_tempate):
        f = codecs.open(seo_tempate, 'w', 'utf-8')
        f.write('')
        f.close()
    seo_mtime = os.stat(seo_tempate).st_mtime 
    f = open(seo_tempate, "r")
    content = f.read()
    f.close()
    
    try:
        content = json.loads(content)
        seo_class_dict.update(content)
    except:
        pass

_init_seo_data()

@login_required
@ensure_csrf_cookie
def seo(request):
    if request.method == 'POST':
        for k in seo_class_dict.keys():
            seo_class_dict[k] = request.POST.get(k, '')
        
        content = json.dumps(seo_class_dict)
        
        f = codecs.open(seo_tempate, 'w', 'utf-8')
        f.write(content)
        f.close()
        return JsonResponse({'status':1})
    else:
        _init_seo_data()
        return render_to_response('syscustom/seo.html', seo_class_dict)


def getSeoByKey(key):
    if os.stat(seo_tempate).st_mtime > seo_mtime:
        _init_seo_data()
        print 're init...data...'
    return seo_class_dict.get(key,'')





    