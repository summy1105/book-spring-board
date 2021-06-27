<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@ include file="../includes/header.jsp" %>
<style>
    .uploadResult{
        width:100%;
        background-color:gray;
    }
    
    .uploadResult ul{
        display:flex;
        flex-flow: row;
        justify-content:center;
        align-items: center;
    }
    
    .uploadResult ul li{
        list-style: none;
        padding: 10px;
        align-content:center;
        text-align:center;
    }
    
    .uploadResult ul li img{
        width: 100px;
    }
    
    .uploadResult ul li span{
        color:white;
    }
    
    .bigPictureWrapper{
        position : absolute;
        display: none;
        justify-content: center;
        align-items: center;
        top: 0%;
        width: 100%;
        height: 100%;
        background-color:gray;
        z-index:  100;
        background:rgba(255, 255, 255, 0.5);
    }
    
    .bigPicture{
        position:relative;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    
    .bigPicture img{
        width: 600px;
    }
    </style>

            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">글 상세</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            글 상세 조회
                        </div>
                        <!-- /.panel-heading -->
                        
                        <div class="panel-body">
                            <div class="form-group">
                                <label>번호</label>
                                <input class="form-control" name="bno" value='<c:out value="${board.bno}" />' readonly='readonly'/>
                            </div>
                            <div class="form-group">
                                <label for="title">제목</label>
                                <input class="form-control" id="title" name="title" value='<c:out value="${board.title}"/> ' readonly='readonly'/>
                            </div>
                            <div class="form-group">
                                <label for="content">내용</label>
                                <textarea class="form-control" rows="3" id="content" 
                                name="content" readonly='readonly'><c:out value="${board.content}"/></textarea>
                            </div>
                            <div class="form-group">
                                <label for="writer">작성자</label>
                                <input class="form-control" id="writer" name="writer" value='<c:out value="${board.writer}"/> ' readonly='readonly'>
                            </div>
                            <sec:authentication property="principal" var="pinfo"/>
                            <sec:authorize access="isAuthenticated()">
                            	<c:if test="${pinfo.username eq board.writer}">
                            		<button data-oper="modify" class="btn btn-success">수정</button>
                            	</c:if>
                            </sec:authorize>
                            <button data-oper="list" class="btn btn-info">취소- 목록</button>
                            
                            <form id="operFoam" action="/board/modify" method="get">
                            	<input type="hidden" id="bno" name="bno" value="${board.bno}">
                            	<input type="hidden" id="pageNum" name="pageNum" value="${cri.pageNum}">
                            	<input type="hidden" id="amount" name="amount" value="${cri.amount}">
                            	<input type="hidden" name="type" value="${cri.type}">
                            	<input type="hidden" name="keyword" value="${cri.keyword}"> 
                            </form>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /. board row -->
            
            <!-- file show-->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">Files</div>
                        <div class="panel-body">
                            <div class="uploadResult">
                                <ul></ul>
                            </div>
                        </div><!-- end body-->
                    </div><!-- end default-->
                </div><!-- end col-lg-12-->
            </div>

            <div class="bigPictureWrapper">
                <div class="bigPicture"></div>
            </div>
            <!--/file row-->


            <div class="row">
                <div class="col-lg-12">
                    <!--pannel-->
                    <!-- <div class="panel panel-default">
                        <div class="panel-heading">
                            <i class="fa fa-comments fa-fw">댓글</i>
                        </div>
                    </div> -->
                    <div class="panel panel-heading">
                        <i class="fa fa-comments fa-fw"></i> reply
                        <sec:authorize access="isAuthenticated()">
                        	<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">new reply</button>
                        </sec:authorize>
                    </div>
                    <div class="panel-body">
                        <ul class="chat">
                            <li class="left clearfix" data-rno="12">
                                <div>
                                    <div class="header">
                                        <strong class="primary-font">사용자00</strong>
                                        <small class="pull-right text-muted">2021-02-24</small>
                                    </div>
                                    <p>Good job</p>
                                </div>
                            </li><!--end reply-->
                        </ul><!--end ul-->
                    </div><!--end panel chat-panel-->
                    <div class = 'panel-footer'></div>
                </div><!--end col-lg-12-->
            </div><!--end reply row-->

			<!-- 모달창 <댓글 추가> -->
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Reply</label>
                                <input class="form-control" name="reply" value="New Reply">
                            </div>
                            <div class="form-group">
                                <label>Replyer</label>
                                <input class="form-control" name="replyer" value="replyer">
                            </div>
                            <div class="form-group">
                                <label>Reply Date</label>
                                <input class="form-control" name="replyDate" value=''>
                            </div>
                        </div> <!--end : modal body-->
                        <div class="modal-footer">
                            <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
                            <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                            <button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
                            <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div><!-- end modal-content -->
                </div><!-- end modal-dialog-->
            </div><!-- end: modal fade-->
            
            <!--추가 256페이지-->
            <script type="text/javascript" src="/resources/js/reply.js"></script>

            <script type="text/javascript">
                    
				$(document).ready(function() {
					var bnoValue = '<c:out value="${board.bno}"/>';
                    var replyUL = $(".chat");

                    var pageNum = 1; // 현재 페이지 번호를 나타냄 처음은 1번
                    var replyPageFooter = $('.panel-footer');// 댓글의 페이징 번호를 구성하는 div영역
                    
                 	// 댓글 페이지 번호 출력
                    function showReplyPage(replyCnt) {
                        var endNum = Math.ceil(pageNum/10.0)*10;
                        var startNum = endNum -9;
                        console.log("replyCnt:" + replyCnt);
                        console.log("pageNum:" + pageNum);
                        console.log("endNum:" + endNum);

                        var prev = startNum != 1;
                        var next = false;
                        if(endNum *10 >= replyCnt){
                            endNum = Math.ceil(replyCnt/10.0);
                        }
                        if(endNum*10< replyCnt){
                            next = true;
                        }
                        console.log("endNum2:" + endNum);

                        var str = "<div><ul class='pagination pull-right'>";
                        if(prev){
                            str+= "<li class='paginate_button'><a class='page-link' href='"+(startNum-1)+"'>이전</a></li>";
                        }
                        for (let i = startNum; i <= endNum; i++) {
                            var active = pageNum == i ? "active":"";
                            str+= "<li calss='page-item "+active+"'><a calss='page-link' href='"+(i)+"'>"+(i)+"</a></li>";
                        }
                        if(next){
                            str+= "<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>다음</a></li>";
                        }
                        str += "</ul></div>"
                        console.log(str)
                        replyPageFooter.html(str); 
                    }
                    
                    // 댓글 목록을 보여주는 함수
                    function showList(page){
                        replyService.getList({bno:bnoValue, page:page||1}
                            , (replyCnt, list)=>{  
                            	console.log(replyCnt);
                            	if(page == -1){
                            		pageNum = Math.ceil(replyCnt/10.0);
                            		showList(pageNum);
                            		return;
                            	}
                                var str = '';
                                if(list==null || list.length==0){
                                    replyUL.html('');
                                    return;
                                }
                                for(var i=0, len=list.length||0; i<len; i++){
                                    str+='<li class="left clearfix" data-rno="'+list[i].rno+'"/>';
                                    str+= "<div><div class='header'><strong class='primary-font'> "+list[i].replyer+ "</strong>";
                                    str+= "<small class='pull-right text-muted'>" +replyService.displayTime(list[i].replyDate)+ "</small></div>";
                                    str += "<p>"+list[i].reply+"</p></div></li>";
                                }
                                replyUL.html(str);
                                showReplyPage(replyCnt); // 댓글의 페이지 번호를 ul태그를 찾아 추가함
                            })
                    }


                    
					// 댓글 페이징 번호에서 페이징 번호를 클릭하면 실행
                    replyPageFooter.on("click","li a", function(e){
                        e.preventDefault();
                        console.log("reply pageButton click")

                        var targetPageNum = $(this).attr("href");
                        console.log("targetPageNum : "+ targetPageNum);

                        pageNum = targetPageNum;

                        showList(pageNum);
                    })
                    
                    
                    showReplyPage(2);
                    showList(1);

                    var operFoam =$("#operFoam");

                    $("button[data-oper='modify']").on("click", function(e) {
                        operFoam.attr("action","/board/modify").submit();
                    })

                    $("button[data-oper='list").on("click", function(e){
                        operFoam.find("#bno").remove();
                        operFoam.attr("action", "/board/list");
                        operFoam.submit();
                    });

                    // 모달 관련 태그 값들 변수에 지정
                    var modal = $(".modal");
                    var modalInputReply = modal.find("input[name='reply']"); //모달창 댓글 input태그
                    var modalInputReplyer = modal.find("input[name='replyer']"); //모달창 댓글작성인 input태그
                    var modalInputReplyDate = modal.find("input[name='replyDate']");  //모달창 댓글작성시간 input태그

                    var modalModBtn = $('#modalModBtn'); //모달 수정버튼
                    var modalRemoveBtn = $('#modalRemoveBtn'); //모달 삭제 버튼
                    var modalRegisterBtn = $('#modalRegisterBtn'); //모달 등록 버튼
                    
                    var reployer = null;
                    <sec:authorize access="isAuthenticated()">
                   	    replyer='<sec:authentication property="principal.username"/>';
                   	</sec:authorize>
                   	
                   	var csrfHeaderName = "${_csrf.headerName}";
                    var csrfTokenValue = "${_csrf.token}";
                    
                    $(document).ajaxSend(function(e, xhr, options){
                    	console.log("ajaxSend");
                        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
                    });
                    
                    // new reply 버튼 클릭시 
                    $('#addReplyBtn').on("click", function(e){
                        modal.find("input").val("");
                        modal.find("input[name='replyer']").val(replyer);
                        modalInputReplyDate.closest("div").hide(); //시간 input태그를 감싸고 있는 div태그를 숨김
                        modal.find("button[id !='modalCloseBtn']").hide(); // 닫기버튼 이외 숨김
                        
                        modalRegisterBtn.show(); // register버튼은 보이게

                        $(".modal").modal("show");
                    })
					// 모달 등록버튼
                    modalRegisterBtn.on("click", function(e){
                        var reply = {
                            reply : modalInputReply.val()
                            , replyer : modalInputReplyer.val()
                            , bno : bnoValue
                        };

                        replyService.add(reply, function(result){
                            alert(result);

                            modal.find("input").val("");
                            modal.modal("hide");
                            //showList(1);
                            showList(-1);
                        })
                    })
					
                    
                    // 댓글 목록중 하나의 댓글을 클릭시 실행
                    $(".chat").on("click", "li", function(e){
                        var rno = $(this).data("rno");
                        console.log(this)
                        console.log(rno)
                        
                        replyService.get(rno, function(reply){
                            console.log(reply.reply)
                            modalInputReply.val(reply.reply); // 댓글 input태그에
                            modalInputReplyer.val(reply.replyer);
                            modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
                            modal.data("rno",reply.rno);

                            modal.find("button[id != 'modalCloseBtn']").hide(); // 닫기 버튼 외 안보이게
                            modalModBtn.show();	// 수정
                            modalRemoveBtn.show(); // 삭제버튼 다시 보기이

                            $(".modal").modal("show");
                        })
                    })
                    // 모달(댓글) 수정 버튼
                    modalModBtn.on("click",function(e){
                        var reply = {rno : modal.data("rno"), reply: modalInputReply.val()};

                        replyService.update(reply, function(result){
                            alert(result);
                            modal.modal("hide");
                            showList(pageNum);
                        })
                    })
                    // 모달(댓글) 삭제 버튼
                    modalRemoveBtn.on("click", function(e){
                        var rno =modal.data("rno");
                        
                        if(!replyer){
                        	alert("로그인후 삭제가 가능합니다.");
                        	modal.modal("hide");
                        	return;
                        }
                        
                        var originalReplyer = modalInputReplyer.val();

                        $(document).ajaxSend(function(e, xhr, options){
                            console.log("ajaxSend");
                            xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
                            xhr.setRequestHeader("replyer", originalReplyer);
                        });

                        if(replyer != originalReplyer){
                        	alert("자신이 작성한 댓글만 삭제가 가능합니다.");
                        	modal.modal("hide");
                        	return;
                        }
                        
                        replyService.remove(rno,  function(result){
                            alert(result);
                            modal.modal("hide");
                            showList(pageNum);
                        }, replyer)
                    });
                    

                    // 파일
                    (function(){
                        var bno = "${board.bno}";
                        console.log("get file")
                        $.getJSON("/board/getAttachList", 
                            {bno:bno}, 
                            function(arr){
                                console.log(arr);

                                var str ="";

                                $(arr).each(function(i, attach){
                                    console.log(attach);
                                    if(attach.fileType){
                                        var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);//url 문자열을 각각의 브라우저에 맞게 인코딩

                                        str += "<li data-path='"+attach.uploadPath+"'' data-uuid='"+attach.uuid+"'";
                                        str += " data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
                                        str += "<img src='/display?fileName="+fileCallPath+"'>";
                                        str += "</div></li>";
                                    }else{
                                        str += "<li data-path='"+attach.uploadPath+"'' data-uuid='"+attach.uuid+"'";
                                        str += " data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
                                        str += "<span>"+attach.fileName+"</span><br/>";
                                        str += "<img src='/resources/img/attach.png'>";
                                        str += "</div></li>";
                                    }
                                })
                                $(".uploadResult ul").html(str);
                            }
                        )// end getJSON
                    })();//end file get function

                    $(".uploadResult").on("click", "li", function(e){
                        console.log("view Image");

                        var liObj = $(this);//li tag
                        var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));

                        if(liObj.data("type")){
                            showImage(path.replace(new RegExp(/\\/g), "/"));
                        }else{
                            //download
                            self.location = "/download?fileName="+path;
                        }
                    })// end file click event

                    function showImage(fileCallPath){
                        //alert(fileCallPath);
                        $(".bigPictureWrapper").css("display", "flex").show();
                        $(".bigPicture")
                            .html("<img src='/display?fileName="+fileCallPath+"'>")
                            .animate({width:'100%', height:'100%'}, 1000);
                    } //end showImage function

                    $(".bigPictureWrapper").on("click", function(e){
                        $(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
                        setTimeout(function(){
                            $(".bigPictureWrapper").hide();
                        }, 1000);
                    });// end close image file show

                });// end $(document).ready(function)
			</script>
            

 <%@ include file="../includes/footer.jsp"%>