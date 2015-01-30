var bookmark;//光标位置
(function() {
	tinymce.create('tinymce.plugins.UploadImgPlugin', {
		init : function(ed, url) {
			// Register commands
			upload_url = tinyMCE.get("content").getParam("upload_url")
			
			initDiv(url,upload_url);
			ed.addCommand('mceUploadImg', function() {
				// Internal image object like a flash placeholder
				if (ed.dom.getAttrib(ed.selection.getNode(), 'class').indexOf('mceItem') != -1)
					return;
				bookmark = tinyMCE.get("content").selection.getBookmark();
				$.fn.shadeBlock($("#uploadFormTrigger"),380, 200, "#uploadForm", "添加图片")
			});
			// Register buttons
			URL = url;
			ed.addButton('img', {
				title : '插入图片',
				cmd : 'mceUploadImg',
				image :url + '/img/sample.gif'
			});
		},
		getInfo : function() {
			return {
				longname : 'Advanced image',
				author : 'Moxiecode Systems AB',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/advimage',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}
	});
	// Register plugin
	tinymce.PluginManager.add('uploadImg', tinymce.plugins.UploadImgPlugin);
})();

// JavaScript Document
(function($){
	var globalVar;
	$.fn.shadeBlock = function(obj,blockWidth, blockHeight, blockSrc, blockTitle){
	// 初始化全局参数
	globalVar = $.fn.shadeBlock.globalVar;
	// 准备遮罩层调用
	$.fn.shadeBlock.createShade();
	// 绑定鼠标事件--显示影藏block调用
	$(this).shadeBlock.show(blockWidth, blockHeight, blockSrc, blockTitle);
	return false;
	//return obj.click(function(){
	//	$(this).shadeBlock.show(blockWidth, blockHeight, blockSrc, blockTitle);
		//return false;
	//});
	};
	// 准备遮罩层
	$.fn.shadeBlock.createShade = function(){
		if($("#shield").html() == null){
			var shield = document.createElement("div");
			$(shield).attr("id","shield");
			$(shield).css({
				position:"absolute",
				top:"0",
				left:"0",
				"z-index":"1000",
				width:"100%",
				height:"100%",
				background:globalVar.shadeBackground,
				opacity:globalVar.shadeOpacity,
				display:"none" 
			});
			$("body").append($(shield));
		}
	};
	// 显示影藏block
	$.fn.shadeBlock.show = function(blockWidth, blockHeight, blockSrc, blockTitle){
		var pageSize = $.fn.getPageSize();
		var shadeBlockContent;
		var targetBlockArr = blockSrc.split("#");
		var shadeBlockId = targetBlockArr[1];
		
		if($.trim(targetBlockArr[0]) == "") shadeBlockContent = $("#"+shadeBlockId).remove().html();
		else shadeBlockContent = "<iframe class='shadeHiddenBlock' id='"+shadeBlockId+"' scrolling='"+globalVar.frameScroll+"' src='"+targetBlockArr[0]+"' width="+(blockWidth-2)+" height="+(blockHeight-50)+" frameborder='0'></iframe>";

		// 创建将要显示的block
		if($("#"+shadeBlockId+"Wrapper").html() == null){
			var wrapper = "<div class='outWrapper' id='"+shadeBlockId+"Wrapper'>"+
							"<div class='innerWrapper'>"+
								"<div class='shadeBlockTitle'>"+
									"<h5>"+blockTitle+"</h5></div>"+
								"<div class='shadeBlockContent'>"+shadeBlockContent+"</div>"+
							"</div></div>";
			$("body").append(wrapper);
			$("#"+shadeBlockId+"Wrapper").css({ 
				top:(pageSize[1] > blockHeight ? pageSize[1] : blockHeight)/2+"px",
				left:"50%",
				width:blockWidth, 
				height:blockHeight, 
				"margin-top":"-"+blockHeight/2+"px", 
				"margin-left":"-"+blockWidth/2+"px" 
			});
			$("#"+shadeBlockId+"Wrapper").children(".innerWrapper").css({ width:(blockWidth-2)+"px", height:(blockHeight-2)+"px" });
			$("#closeHandlerFor"+shadeBlockId).mouseover(function(){ $("#closeHandlerFor"+shadeBlockId).attr("src",globalVar.blockHideIconOn); });
			$("#closeHandlerFor"+shadeBlockId).mouseout(function(){ $("#closeHandlerFor"+shadeBlockId).attr("src",globalVar.blockHideIcon); });
			$("#closeHandlerFor"+shadeBlockId).click(function(){ $.fn.shadeBlock.hides(shadeBlockId); });
			//$("#shield").click(function(){ $.fn.shadeBlock.hides(shadeBlockId); });
		}
		
		// 显示block
		var shieldNewHeight = pageSize[1] > (blockHeight+6) ? pageSize[1] : (blockHeight+6); //重新计算当前页面尺度， 并更改遮罩层尺度
		$("#shield").css("height",shieldNewHeight+"px");
		$("#shield").fadeIn(globalVar.fadeInTime);
		$("#"+shadeBlockId+"Wrapper").fadeIn(globalVar.fadeInTime);
	};
	// 影藏shade Block
	$.fn.shadeBlock.hides = function(shadeBlockId){
		$("#shield").fadeOut(globalVar.fadeOutTime);
		$("#"+shadeBlockId+"Wrapper").fadeOut(globalVar.fadeOutTime);
	}
	// 全局参数
	$.fn.shadeBlock.globalVar = {
		shadeBlockId : "shadeBlockId",									// 显示内容块的Id，如果与Dom中其他元素的Id冲突，需要定义成其他值
		shadeBackground : "#000", 										// 遮罩层基色
		shadeOpacity : "0.7",											// 遮罩层透明度
		blockTitleFont : "Verdana, Arial, Helvetica, sans-serif",		// 显示内容区标题字体
		blockHideIcon : "images/shadeClose.gif",						// 显示内容区关闭图标
		blockHideIconOn : "images/shadeCloseOn.gif",					// 显示内容区关闭图标(mouseon)
		fadeInTime : 400,												// 渐变显示block时间
		fadeOutTime : 400,												// 渐变影藏block时间
		frameScroll : "no"												// 嵌入的iframe窗口是否带滑动条
	};
	
	// 获取页面尺寸函数
	$.fn.getPageSize = function(){
		var xScroll, yScroll;
		if (window.innerHeight && window.scrollMaxY) {
			xScroll = window.innerWidth + window.scrollMaxX;
			yScroll = window.innerHeight + window.scrollMaxY;
		} else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
			xScroll = document.body.scrollWidth;
			yScroll = document.body.scrollHeight;
		} else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
			xScroll = document.body.offsetWidth;
			yScroll = document.body.offsetHeight;
		}
		var windowWidth, windowHeight;
		if (self.innerHeight) { // all except Explorer
			if(document.documentElement.clientWidth){
				windowWidth = document.documentElement.clientWidth;
			} else {
				windowWidth = self.innerWidth;
			}
			windowHeight = self.innerHeight;
		} else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
			windowWidth = document.documentElement.clientWidth;
			windowHeight = document.documentElement.clientHeight;
		} else if (document.body) { // other Explorers
			windowWidth = document.body.clientWidth;
			windowHeight = document.body.clientHeight;
		}
		// for small pages with total height less then height of the viewport
		if(yScroll < windowHeight){
			pageHeight = windowHeight;
		} else {
			pageHeight = yScroll;
		}
		// for small pages with total width less then width of the viewport
		if(xScroll < windowWidth){
			pageWidth = xScroll;
		} else {
			pageWidth = windowWidth;
		}
		var arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight);
		return arrayPageSize;
	};
})(jQuery);
function change(v){
	if(v==1){
		$("#fromLocal").css("display","inline-block");$("#local").removeClass("bar2");$("#local").addClass("bar1");
		$("#fromNet").css("display","none");$("#net").removeClass("bar1");$("#net").addClass("bar2");
		
	}else{
		$("#fromLocal").css("display","none");$("#local").removeClass("bar1");$("#local").addClass("bar2");
		$("#fromNet").css("display","inline-block");$("#net").removeClass("bar2");$("#net").addClass("bar1");
		$("#img_url").focus();
	}
}
function insertLink(){
	imgUrl = $("#img_url").val();
	$("#img_url").val("");
	tinyMCE.get("content").selection.moveToBookmark(bookmark); 
	tinyMCE.execCommand('mceReplaceContent',false,'<img src='+imgUrl+'>');
	$.fn.shadeBlock.hides("uploadForm");
}
function upload_over(imgUrl){
	tinyMCE.get("content").selection.moveToBookmark(bookmark); 
	$("#file").val("");
	tinyMCE.execCommand('mceReplaceContent',false,'<img src='+imgUrl+'>');
	$.fn.shadeBlock.hides("uploadForm");
}
function upload(upload_url){
	$.ajaxFileUpload({
				url:upload_url, 
				secureuri:false,
				fileElementId:'file',
				dataType: 'text',
				success: function (data, status){
					upload_over(data);
				},
				error: function (data, status, e){
					alert(e);
				}
			}
		);
}

function initDiv(url, upload_url){
form1=$("#uploadForm");
if(form1.length>0){return};
$("head").append('<link href="'+ url + '/css/shadeBlock.css" media="screen" rel="stylesheet" type="text/css" />');
$("body").append('<a href="javascript:;" class="shadeHiddenBlock" style="display:none;" id="uploadFormTrigger">上传</a>'+
		'<div class="shadeHiddenBlock" style="display:none;" id="uploadForm" >'+
		'<table class="tbl">'+
			'<tr><td>'+
		'	<div style="border:0px solid black;margin-left:6px;"><div class="bar1 fl" id="local" onclick="javascript:change(1);">从你的电脑上传</div><div id="net" class="bar2" onclick="javascript:change(2);">从网上地址添加</div></div>'+
		'	</td><td>&nbsp;</td></tr>'+
		'	<tr><td colspan="1" align="center" height="85px">'+
		'		<form id="upload_form" method="POST" action="'+upload_url+'" enctype="multipart/form-data">'+
		'		<div id="fromLocal" class="fromLocal">'+
		'			<input id="file" name="file" type="file"/><br/>支持上传jpg、gif、png、bmp格式的图片，大小不超过8M'+
		'		</div>'+
		'		</form>'+
		'		<div id="fromNet" class="fromNet">'+
		'			地址: <input type="text" id="img_url" name="img_url" size="45"/><br/>'+
		'			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;例如: http://s.xnimg.cn/a.gif'+
		'		</div>'+
		'	</td>'+
		'	</tr>'+
		'	<tr>'+
		'	<td colspan="3" align="right" height="30px">'+
		'			<div style="border:0px solid black;margin-right:20px">'+
		'			<input type="button" class="btn" onclick="javascript:insertLink();" value="确定"/>&nbsp;&nbsp;'+
		'			<input type="button" class="btn" onclick="javascript:upload(\''+upload_url+'\');" value="上传"/>&nbsp;&nbsp;'+
		'			<input type="button" class="btn" id="cancel1" onclick="javascript:$.fn.shadeBlock.hides(\'uploadForm\'); " value="取消"/>'+
		'		    </div>'+
		'	</td>'+
		'	</tr>'+
		'</table>'+
	'</div>');
};