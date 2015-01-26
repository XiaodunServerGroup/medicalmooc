#coding=utf-8
''' 
创建视频字幕时的相关方法
'''
import random
from random import randint
import datetime
import os
import time
from urllib2 import Request, urlopen
import urlparse
import traceback

from django.conf import settings

#生成随机视频字幕名
def get_random_name(ext):
    p = '%.4f' % time.time()
    return '%s%d%s' %(p.replace('.', ''), randint(1,1000), ext)

    #return '%d.%.4f.%s' %(randint(1,1000),time.time(),ext)

#根据日期创建目录
def get_dir(local_dir):
#一个星期的视频字幕放一个目录
# dir = random.choice(dirs)
    dir = os.path.join(local_dir,datetime.datetime.now().strftime('%Y%m'))
    dir = os.path.join(local_dir, dir)
    if not os.path.exists(dir):
        os.mkdir(dir)

    return dir


def save_file(file_data, upload_to, ext_filename='.srt'):
    file_name = get_random_name(ext_filename)
    file_path = get_dir(os.path.join(settings.STORE_ROOT, upload_to))
    file_path= os.path.join(file_path, file_name)
    fp = open(file_path, 'wb')  #读写打开这个要上传的文件
    for content in file_data.chunks():
        fp.write(content)
    fp.close()

    return file_path

def save_thumb_file():
    pass



if __name__ == '__main__':
    pass
