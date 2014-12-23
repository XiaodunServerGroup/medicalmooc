$(function(){
	var tick=false;
	$('.icon2').click(function(){
		if(tick){
			return false;
		}
		tick=true;
		var that=$(this);
		var fa=that.parent();
		var ul=fa.find('ul');
		var pos=parseInt(ul.css('margin-left'));
		var w=180*4;
		if(pos<0){
			var d=pos+w;
			d=d<=0?d:0;
			ul.stop().animate({'margin-left':d+'px'},1E3,function(){
				tick=false;
			});
		}else{
			tick=false;
		}
		return false;
	})
	$('.icon1').click(function(){
		if(tick){
			return false;
		}
		tick=true;
		var that=$(this);
		var fa=that.parent();
		var ul=fa.find('ul');
		var length=ul.find('li').length;
		var pos=parseInt(ul.css('margin-left'));
		var w=180*4;
		var W=180;
		var AvNUM=length+Math.floor(pos/W)-4;
		console.log(AvNUM);
		if(AvNUM>0&&AvNUM>=4){
			console.log('q');
			ul.stop().animate({'margin-left':pos-w+'px'},1E3,function(){
				tick=false;
			});
		}else if(AvNUM>0&&AvNUM<4){
			console.log('qw');
			ul.stop().animate({'margin-left':pos-AvNUM*W+'px'},1E3,function(){
				tick=false;
			});
		}else{
			tick=false;
		}
		return false;
	})
})