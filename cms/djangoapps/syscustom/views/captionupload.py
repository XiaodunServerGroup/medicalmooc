import os
import json
import datetime

from django_future.csrf import ensure_csrf_cookie
from django.conf import settings

from util.json_request import JsonResponse
from edxmako.shortcuts import render_to_response

from ..caption import *


def caption_upload(request):
    if 'file' in request.FILES:
        caption_data = request.FILES['file']
        old_srt_file = request.POST.get("old_srt_file")
        
        old_srt_file_path = os.path.join(settings.STORE_ROOT, old_srt_file)
        if os.path.exists(old_srt_file_path) and not os.path.isdir(old_srt_file_path):
            os.remove(old_srt_file_path)

        try:
            caption_path = save_file(caption_data, upload_to=settings.VIDEO_SUBTITLE_DIR)
            caption = caption_path.replace(settings.STORE_ROOT, '').replace('\\', '/')
            info = {'url':settings.STORE_URL + caption, 'caption':caption}
            return JsonResponse(info)
        except :
            error = str(traceback.format_exc())
            return JsonResponse({'error':error})
    return JsonResponse({'error':'data error'})


