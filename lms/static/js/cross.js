w=document.body.clientWidth;
h=document.body.clientHeight;
var src="http://mooc.diandiyun.com/common/cross_proxy.html#"+w+"|"+h;
var iframe="<iframe src='"+src+"' id='myFrame' name='myFrame' frameborder='0' scrolling='no' style='display:none;'></iframe>";
document.write(iframe);