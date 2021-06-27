/**
 * 
 */

//console.log("reply module...");

var replyService = (function() {
  const add = (reply, callback)=>{
    $.ajax({
      type: "POST",
      url: "/replies/new",
      data : JSON.stringify(reply),
      contentType: "application/json;characters=utf-8",
      success: function(result, status, xhr){
        if(callback)  { callback(result) }
      },
      error: function(xhr, status, er){
        //if(error) { error(er)}
    	alert("error : "+er)
      }
    })
  }
  const getList = (param,callback,error) =>{
	  var bno = param.bno
	  var page = param.page || 1 ;
	  console.log(bno, page);
	  $.getJSON(
	    "/replies/page/"+bno+"/"+page+".json"
	    , function (data) {
  			console.log(data);
	      if(callback) { callback(data.replyCnt, data.list)} // replypageDTO(갯수, 댓글의 목록의 배열)
	    }
	  ).fail(function (xhr, status, err) {
	    if(error) { error()}
	  })
	}
  
  const remove = (rno, f, error, replyer)=>{
	  console.log("aaa"+replyer);
	  $.ajax({
		  type:'delete'
		 , url:'/replies/'+rno
		 , data: JSON.stringify({rno:rno, replyer:replyer})
		 , contentType:"application/json; charset=utf-8"
		 , success : function(deleteResult, status, xhr){
			 if(f){ f(deleteResult); }
		 }
//            		  	 , error: function(xhr, status, er){
//            		  		 if(error) { error(er); }
//            		  	 }
	  }) // parameter : object 한개
  }
  
  const update = (reply, callback)=>{
	  $.ajax({
		  type:'put'
		  , url:'/replies/'+reply.rno
		  , data : JSON.stringify(reply)
		  , contentType: "application/json;characters=utf-8"
		  , success: function(result, status, xhr){
		        if(callback)  { callback(result) }
	      }
	  	  , error: function(xhr, status, er){
	          //if(error) { error(er)}
	      	alert("error : "+er)
	        }
	  })
  }
  
  function get(reply, callback, error){
	  $.get( "/replies/"+reply+'.json'
			  , function (result){
				  if(callback) callback(result)
			  }
	  ).fail(function(xhr, status, err){
		  if(error) error()
	  })
  };
  
	function displayTime(timeValue){
		var today = new Date();
		var gap = today.getTime() - timeValue;
		
		var dateObj = new Date(timeValue);
		var str='';

		if(gap<(1000*60*60*24)){
			var hh = dateObj.getHours();
			var mm = dateObj.getMinutes();
			var ss = dateObj.getSeconds();

			return [(hh>9?'':'0')+hh, ':', (mm>9? '':'0')+mm, ':', (ss>9?'':'0')+ss].join('');
		}else{
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth()+1;//getMonth() is zero-based
			var dd = dateObj.getDate();

			return [yy,'/', (mm>9?'':'0')+mm, '/', (dd>9?'':'0')+dd].join('');
		}
	};

  return {
	  add:add
	  ,getList:getList
	  , remove:remove
	  , update: update
	  , get:get
		, displayTime: displayTime
  	}
})();




// var replyService = (function() {
//   function add(reply, callback, tt, uu) { 
//     console.log("reply");
//     console.log( callback(7) );
//     console.log( tt(3,6,{a:"홍말자"}) );
//     console.log(uu+9);
//   }
//   return {add:add}
// })();

// replyService.add("reply"
//       , a=> a*3
//       , (a,b,c)=>{
//         console.log(c.a);
//         return a*b
//       }
//       ,5)


// var replyService2 = (function() {
//   return {
//     add : (a,b) => a+b,
//     sub : (a,b) => a-b,
//     mul : (a,b) => a*b,
//     div : (a,b) => a/b
//   }
// })();
// console.log(replyService2)
// var {add, sub} = replyService2; //destructuring
// console.log(add(3,4));
// console.log(replyService2.add(3,4));