window.onload = function()
{
	var tabBtnBox = document.getElementById('tab-btn');
	var tabBtn = tabBtnBox.getElementsByTagName('img');
	var iNow = 0;
	
	//******************Tab**************************
	var prevBtn = document.getElementById('prevBtn');
	var nextBtn = document.getElementById('nextBtn');
	var bigImg = document.getElementById('big-img').getElementsByTagName('img');
	
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
		};
	
		tabBtn[i].onmouseout = function()
		{
			timer = setInterval(auto,3000);
		};
	
		tabBtn[i].onclick =  function()
		{
			tabBtn[iNow].className = '';
			goOpa(bigImg[iNow],{target:0,speed:5,endFn:function(){
			bigImg[iNow].style.zIndex=0;
			}});
			this.className = 'cls';
			iNow=this.index;
			goOpa(bigImg[iNow],{target:100,speed:5,endFn:function(){
			bigImg[iNow].style.zIndex = 10;
			}});
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
		tabBtn[_iNow].className = '';
		goOpa(bigImg[_iNow],{target:0,speed:5,endFn:function(){bigImg[_iNow].style.zIndex=0;}});
		
		iNow++;if(iNow == bigImg.length)iNow = 0;
		
		tabBtn[iNow].className = 'cls';
		goOpa(bigImg[iNow],{target:100,speed:5,endFn:function(){bigImg[iNow].style.zIndex=1;}});
	};
	
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
		if( Math.abs(json.target-opa) <= Math.abs(iSpeed) ) {obj.style.opacity = json.target/100;obj.style.filter = 'alpha(opacity:'+json.target+')';clearInterval(obj.timer);json.endFn  &&  json.endFn();}
		else{opa = opa + iSpeed;obj.style.opacity = opa/100;obj.style.filter = 'alpha(opacity:'+opa+')';}; 
	},30);
};
function getStyle(obj,attr){return obj.currentStyle?obj.currentStyle[attr]:getComputedStyle(obj,false)[attr];};