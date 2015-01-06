var site_domain = site_domain || '';
window.onload = function()
{
	var tabBtnBox = document.getElementById('tab-btn');
	if(!tabBtnBox) return false;
	var tabBtn = tabBtnBox.getElementsByTagName('img');
	var iNow = 0;

	//******************Tab**************************
	var prevBtn = document.getElementById('prevBtn');
	var nextBtn = document.getElementById('nextBtn');
	var bigImg = document.getElementById('big-img').getElementsByTagName('li');

	for(var i=0; i<tabBtn.length; i++)
	{


		tabBtn[i].index = i;
		tabBtn[i].onmouseover = function()
		{

			clearInterval(timer);
			tabBtn[iNow].className = '';
			goOpa(bigImg[iNow],{target:0,speed:5,endFn:function(){
			bigImg[iNow].style.zIndex=0;
			}});
			this.className = 'cls';

			iNow=this.index;
			goOpa(bigImg[iNow],{target:100,speed:5,endFn:function(){
			bigImg[iNow].style.zIndex = 10;
			}});
			if(iNow==0){
				$(".btn_pc").show();
			}else
			{
				$(".btn_pc").hide();
			}

		};

		tabBtn[i].onmouseout = function()
		{

			timer = setInterval(auto,3000);
		};

		tabBtn[i].onclick =  function()
		{
			if(i==2){
				$(".btn_pc").show();
			}else
			{
				$(".btn_pc").hide();
			}
			tabBtn[iNow].className = '';
			goOpa(bigImg[iNow],{target:0,speed:5,endFn:function(){
			bigImg[iNow].style.zIndex=0;
			}});
			this.className = 'cls';
			iNow=this.index;
			goOpa(bigImg[iNow],{target:100,speed:5,endFn:function(){
			bigImg[iNow].style.zIndex = 10;
			}});
				if(iNow!=0){
				$(".btn_pc").hide();
			}
		};

	};


	prevBtn.onclick = function(){
		clearInterval(timer);
		var _iNow = iNow;

		tabBtn[iNow].className = '';
		goOpa(bigImg[_iNow],{target:0,speed:5,endFn:function(){
		bigImg[_iNow].style.zIndex = 0;
		}});

		iNow--;if(iNow < 0)iNow = bigImg.length-1;
		tabBtn[iNow].className = 'cls';
		goOpa(bigImg[iNow],{target:100,speed:5,endFn:function(){
		bigImg[iNow].style.zIndex = 10;
		}});
		timer = setInterval(auto,3000);
	};

	nextBtn.onclick = function(){

		clearInterval(timer);
		var _iNow = iNow;
		tabBtn[iNow].className = '';
		goOpa(bigImg[_iNow],{target:0,speed:5,endFn:function(){//alert(iNow);
		bigImg[_iNow].style.zIndex = 0;
		//alert(iNow);
		}});

		//alert(iNow);
		iNow++;if(iNow == bigImg.length)iNow = 0;
		//alert(iNow);

		tabBtn[iNow].className = 'cls';
		goOpa(bigImg[iNow],{target:100,speed:5,endFn:function(){bigImg[iNow].style.zIndex=1;}});
		timer = setInterval(auto,3000);
	};



	function auto(){
		var _iNow = iNow;
		/*if(_iNow!=2){
			$(".btn_pc").hide();
			}else{
				$(".btn_pc").show();
			}*/

		tabBtn[_iNow].className = '';
		goOpa(bigImg[_iNow],{target:0,speed:5,endFn:function(){bigImg[_iNow].style.zIndex=0;}});

		iNow++;if(iNow == bigImg.length)iNow = 0;

		tabBtn[iNow].className = 'cls';
		goOpa(bigImg[iNow],{target:100,speed:5,endFn:function(){bigImg[iNow].style.zIndex=1;}});
	};
	$(".btn_pc").show();
	goOpa(bigImg[2],{target:0,speed:5,endFn:function(){bigImg[2].style.zIndex=0;}});


	var timer = setInterval(auto,3000);
	/*
	tabBtnBox.onmouseover = function()
	{
		clearInterval(timer);
		alert(this.index);
	};

	tabBtnBox.onmouseout = function()
	{
		timer = setInterval(auto,3000);
	};
	*/
};
function goOpa(obj,json)
{
	clearInterval(obj.timer);var opa = getStyle(obj,'opacity')*100;var iSpeed = json.target > opa ? json.speed : -json.speed;
	obj.timer = setInterval(function(){
		if( Math.abs(json.target-opa) <= Math.abs(iSpeed) )
		{obj.style.opacity = json.target/100;obj.style.filter = 'alpha(opacity:'+json.target+')';clearInterval(obj.timer);json.endFn  &&  json.endFn();}
		else{opa = opa + iSpeed;obj.style.opacity = opa/100;obj.style.filter = 'alpha(opacity:'+opa+')';};
	},30);
};
function getStyle(obj,attr){return obj.currentStyle?obj.currentStyle[attr]:getComputedStyle(obj,false)[attr];};


$(function(){
	$(".x_show1").hover(function(){$(".show").children("img").attr("src", site_domain + "/static/images/qr_android_phone.png");$(".show").show();},function(){$(".show").hide()});
	$(".x_show2").hover(function(){$(".show").children("img").attr("src", site_domain + "/static/images/qr_wechat.jpg");$(".show").show();},function(){$(".show").hide()});
	$(".x_show3").hover(function(){$(".show").children("img").attr("src", site_domain + "/static/images/qr_android_pad.png");$(".show").show();},function(){$(".show").hide()});
})


$(
var SSO_LOGOUT_URL = SSO_LOGOUT_URL || "";
	function(){
		$("#logout").click(function(){
			var username = $("#logout").text();
			var surl = SSO_LOGOUT_URL.replace('%s', username);
			var iframe="<iframe src='"+surl+"' security='restricted' sandbox='' style='display:none;'></iframe>";
			$("body").append(iframe); 
		    var to_url=$(this).attr('url');
		    setTimeout(function(){
		    	window.location.href=to_url;
		    },1200);
		}); 
	}
);
