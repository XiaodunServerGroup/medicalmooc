#coding:utf-8
from datetime import datetime, timedelta
from django.conf import settings
from django.contrib.auth.models import User
from django.contrib.auth.signals import user_logged_in, user_logged_out
from django.db import models, IntegrityError
from django.db.models import Count
from django.db.models.signals import post_save
from django.dispatch import receiver, Signal
from django.core.exceptions import ObjectDoesNotExist


class CustomImage(models.Model):
    name = models.CharField(max_length=60)
    url = models.CharField(max_length=200)  
    img = models.ImageField(upload_to = settings.CUSTOM_IMAGE_DIR) 
    type = models.IntegerField(choices=settings.CUSTOM_IMAGE_CLASS, db_index=True)  #类型
    order_num = models.IntegerField(default=1) #排序号
    created_time = models.DateTimeField(auto_now_add=True, db_index=True)  #创建时间
    updated_time = models.DateTimeField(auto_now_add=True, db_index=True)  #


class CourseClass(models.Model):
    code = models.CharField(max_length=20,unique=True)
    name = models.CharField(max_length=30)
    order_num = models.IntegerField(default=1) #排序号
    created_time = models.DateTimeField(auto_now_add=True, db_index=True)  #创建时间
    updated_time = models.DateTimeField(auto_now_add=True, db_index=True)  #

