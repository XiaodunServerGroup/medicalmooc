#coding=utf-8
''' 
创建图片时的相关方法
'''
import random
from random import randint
import Image
import ImageEnhance
import datetime
import os
import time
from urllib2 import Request, urlopen
import urlparse
import traceback

from django.conf import settings

#生成随机图片名
def get_random_name(ext):
    p = '%.4f' % time.time()
    return '%s%d%s' %(p.replace('.', ''), randint(1,1000), ext)

    #return '%d.%.4f.%s' %(randint(1,1000),time.time(),ext)

#根据日期创建目录
def get_dir(local_dir):
    #一个星期的图片放一个目录
   # dir = random.choice(dirs)
    dir = os.path.join(local_dir,datetime.datetime.now().strftime('%Y%m'))
    dir = os.path.join(local_dir, dir)
    if not os.path.exists(dir):
        os.mkdir(dir)
    
    return dir


def save_image(img_data, upload_to, ext_filename='.jpg'):
    file_name = get_random_name(ext_filename)
    img_path = get_dir(os.path.join(settings.STORE_ROOT, upload_to))
    img_path= os.path.join(img_path, file_name)
    
    fp = open(img_path, 'wb')  #读写打开这个要上传的文件
    for content in img_data.chunks():
        fp.write(content)
    fp.close()
    return img_path

def save_thumb_img():
    pass

#计算缩略图尺寸
def box_size(size, new_size):
    t1 = size[0]*1.0/size[1]
    t2 = new_size[0]*1.0/new_size[1]
    if t1 > t2:
        return int(t2*size[1]),size[1]
    elif t1< t2:
        return size[0],int(size[0]/t2)
    else:
        return size



if __name__ == '__main__':
    pass
