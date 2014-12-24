# coding: utf-8
from django.conf import settings
from Crypto.Cipher import DES
import base64

BLOCK_SIZE = 8
KEY = settings.SSO_KEY
#KEY = "SSOFOUNDER"
pad = lambda s: s + (BLOCK_SIZE - len(s) % BLOCK_SIZE) * chr(BLOCK_SIZE - len(s) % BLOCK_SIZE)

unpad = lambda s : s[0:-ord(s[-1])]

def secure_key(key):
    return key[0:8]

def des_encrypt(input_str):
    obj = DES.new(secure_key(KEY), DES.MODE_ECB)

    return base64.b64encode(obj.encrypt(pad(input_str)))

def des_decrypt(decpt_str):
    obj = DES.new(secure_key(KEY),DES.MODE_ECB)

    return unpad(obj.decrypt(base64.b64decode(decpt_str)))

# test_enanddecrypt_str_with_DES
def test_run():
    str = "你好世界！"

    print "加密`你好世界！`".center(60, '*')
    en_str = des_encrypt(str)
    print des_encrypt(str)

    print "\n"
    print "解密以上字符串".center(60, '*')
    print des_decrypt(en_str)

    print "\n"
    print "| " + "解密给定字符串".center(60, "*") + ' | ', "期望结果".center(40, '*') + ' | ', "解密结果".center(40, "*") + ' |'
    print "| " + "pvvHJRIZ4RPiRSEmxJEXvQ==".center(53, " ") + " | ", "你好中国".center(40, " ") + " | ", des_decrypt("pvvHJRIZ4RPiRSEmxJEXvQ==").center(40, " ") + " |"  

if __name__ == "__main__":
    test_run()