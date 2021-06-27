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
        width: 20px;
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
<!----------------------------
--    attribute
--  1. BoardVO board
--  2. Criteria cri
------------------------------>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">글 수정</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            글 수정 페이지
                        </div>
                        <!-- /.panel-heading -->
                        
                        <form action="/board/modify" method="post">
                            <div class="form-group">
                                <label for="bno">번호</label>
                                <input class="form-control" name="bno" id="bno" value='<c:out value="${board.bno}" />' readonly="readonly"/>
                            </div>
                            <div class="form-group">
                                <label for="title">제목</label>
                                <input class="form-control" id="title" name="title" value='<c:out value="${board.title}"/> ' />
                            </div>
                            <div class="form-group">
                                <label for="content">내용</label>
                                <textarea class="form-control" rows="3" id="content" 
                                name="content" ><c:out value="${board.content}"/></textarea>
                            </div>
                            <div class="form-group">
                                <label for="writer">작성자</label>
                                <input class="form-control" id="writer" name="writer" value='<c:out value="${board.writer}"/>' readonly="readonly" />
                            </div>
                            <div class="form-group">
                                <label>등록일</label>
                                <input class="form-control" name="regDate" 
                                value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regDate }"/>' readonly='readonly'>
                            </div>
                            <div class="form-group">
                                <label>수정일</label>
                                <input class="form-control" name="updateDate" 
                                value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}"/>' readonly='readonly'>
                            </div>
                            <sec:authentication property="principal" var="pinfo"/>
                            <sec:authorize access="isAuthenticated()">
                            	<c:if test="${pinfo.username eq board.writer}">
                            		<button data-oper="modify" class="btn btn-default" type="submit">수정</button>
                            		<button data-oper="remove" class="btn btn-danger" type="submit">삭제</button>
                            	</c:if>
                            </sec:authorize>
                          
                            <button data-oper="list" class="btn btn-info" type="submit">목록</button>
                            
                            <input type="hidden" id="pageNum" name="pageNum" value="${cri.pageNum}">
                            <input type="hidden" id="amount" name="amount" value="${cri.amount}">
                            <input type="hidden" name="type" value="${cri.type}">
                            <input type="hidden" name="keyword" value="${cri.keyword}"> 
                            
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        </form>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->

            <!-- file show-->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">File Attach</div>
                        <!-- end panel-heading -->
                        <div class="panel-body">
                            <div class="form-group uploadDiv">
                                <input type="file" name="uploadFile" multiple>
                            </div>
                            <div class="uploadResult">
                                <ul></ul>
                            </div>
                        </div>
                        <!-- end panel-body -->
                    </div>
                    <!-- end panel-default--->
                </div>
                <!-- end panel -->
            </div>
            <!-- end row -->

            <div class="bigPictureWrapper">
                <div class="bigPicture"></div>
            </div>
            <!--/file row-->
            
        <script type="text/javascript">
            $(document).ready(function (){

                // when form submit
                var formObj = $("form");
                $("button").click(function (e){
                    e.preventDefault(); //기존 이벤트 삭제
                    var operation = $(this).data("oper"); // 현재 이벤트 button 객체의 data-oper값 추출
                    console.log(operation);
                    //remove
                    if(operation === "remove"){
                        formObj.attr("action", "/board/remove");
                        //list, load the criteria information to list page
                    }else if(operation === "list"){
                        $("form").attr("action", "/board/list").attr("method","get");
                        var pageNumTag= $("input[name='pageNum']").clone();
                        var amountTag = $("input[name='amount']").clone();
                        var typeTag = $("input[name='type']").clone();
                        var keywordTag = $("input[name='keyword']").clone();
                        formObj.empty().append(pageNumTag).append(amountTag).append(typeTag).append(keywordTag).submit();
                        return;
                    }else if(operation === "modify"){
                        console.log("modify submit click");

                        var str = "";
                        $(".uploadResult ul li").each(function(i, obj){
                            var jobj = $(obj); // each li tag
                            console.log(jobj);

                            str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
                            str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
                            str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
                            str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
                        });
                        formObj.append(str).submit();
                    }
                    formObj.submit();
                });

                // show file list
                (function() {
                    var bno = "${board.bno}"
                    $.getJSON("/board/getAttachList", {bno:bno},
                        function(arr){
                            console.log(arr);
                            var str="";

                            $(arr).each(function(i, attach){
                                //image
                                if(attach.fileType){
                                    var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);

                                    str += "<li data-path='"+attach.uploadPath+"'' data-uuid='"+attach.uuid+"'";
                                    str += " data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
                                    str += "<span>"+attach.fileName+"</span>";
                                    str += "<button type='button' class='btn btn-warning btn-circle'";
                                    str +=  " data-file=\'"+fileCallPath+"\' data-type='image'>"; // data 정보 button tag에 추가
                                    str += "<i class='fa fa-times'></i></button><br>";
                                    str += "<img src='/display?fileName="+fileCallPath+"'>";
                                    str += "</div></li>";
                                }else{
                                    var fileCallPath = encodeURIComponent(attach.uploadPath+"/"+attach.uuid+"_"+attach.fileName);//url 문자열을 각각의 브라우저에 맞게 인코딩
                                    str += "<li data-path='"+attach.uploadPath+"'' data-uuid='"+attach.uuid+"'";
                                    str += " data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
                                    str += "<span>"+attach.fileName+"</span>";
                                    str += "<button type='button' class='btn btn-warning btn-circle'";
                                    str +=  " data-file=\'"+fileCallPath+"\' data-type='file'>"; // data 정보 button tag에 추가
                                    str += "<i class='fa fa-times'></i></button><br>";
                                    str += "<img src='/resources/img/attach.png'>";
                                    str += "</div></li>";
                                }
                            })
                            $(".uploadResult ul").html(str);
                        })
                })(); //end function show file list

                // eventHandler file X button
                $(".uploadResult").on("click", "button", function(e){
                    console.log("delete file");

                    if(confirm("Remove this file?")){
                        var targetLi = $(this).closest("li"); // The closest() method returns the first ancestor of the selected element.
                        targetLi.remove()//화면에서만 삭제, 수정버튼시 DB및 서버에서 파일 삭제함
                    }
                });
				
                var csrfHeaderName = "${_csrf.headerName}";
                var csrfTokenValue = "${_csrf.token}";

                // eventHandler input[type=file] change : upload file
                $("input[type='file']").change(function(e){
                    var formData = new FormData();
                    var inputFile = $("input[name='uploadFile']");
                    var files = inputFile[0].files;
                        //console.log(files);
                    for(var i=0; i<files.length; i++){
                        if(!checkExtension(files[i].name, files[i].size)){
                            return false;
                        }
                        formData.append("uploadFile", files[i]);
                    }
                    $.ajax({
                        url:'/uploadAjaxAction',
                        processData: false,
                        contentType: false,
                        data: formData,
                        type:'POST',
                        beforeSend: function(xhr){
                        	xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
                        },
                        dataType:'json',
                        success:function(result){
                            console.log(result);
                            showUploadResult(result);
                            // $(".uploadDiv").html(cloneObj.html());
                        }
                    })
                })// end eventHandler input[type=file] change : upload file

            });// end documemt read
            
            // check file size and type
            var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
            var maxSize = 52428800; //5MB
            
            function checkExtension(fileName, fileSize){
                if(fileSize>=maxSize){
                    alert("file size over"); return false;
                }
                if(regex.test(fileName)){
                    alert("file type error"); return false;
                }
                return true;
            }

            // execute after finish upload file 
            function showUploadResult(uploadResultArr){
                if(!uploadResultArr || uploadResultArr.length ==0){ return;}
                var uploadUL = $(".uploadResult ul");

                var str = "";
                
                $(uploadResultArr).each(function(i, obj){
                    console.log(obj);
                    if(obj.image){
                        var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);//url 문자열을 각각의 브라우저에 맞게 인코딩
                        var originPath = obj.uploadPath+"\\"+obj.uuid +"_"+obj.fileName;
                        originPath = originPath.replace(new RegExp(/\\/g), "/");

                        str += "<li data-path='"+obj.uploadPath+"'' data-uuid='"+obj.uuid+"'";
                        str += " data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
                        str += "<span>"+obj.fileName+"</span>";
                        str += "<button type='button' class='btn btn-warning btn-circle'";
                        str +=  " data-file=\'"+fileCallPath+"\' data-type='image'>"; // data 정보 button tag에 추가
                        str += "<i class='fa fa-times'></i></button><br>";
                        str += "<img src='/display?fileName="+fileCallPath+"'>";
                        str += "</div></li>";
                    }else{
                        var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);//url 문자열을 각각의 브라우저에 맞게 인코딩
                        var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/")
                        str += "<li data-path='"+obj.uploadPath+"'' data-uuid='"+obj.uuid+"'";
                        str += " data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
                        str += "<span>"+obj.fileName+"</span>";
                        str += "<button type='button' class='btn btn-warning btn-circle'";
                        str +=  " data-file=\'"+fileCallPath+"\' data-type='file'>"; // data 정보 button tag에 추가
                        str += "<i class='fa fa-times'></i></button><br>";
                        str += "<img src='/resources/img/attach.png'>";
                        str += "</div></li>";
                    }
                })
                uploadUL.append(str);
            }
        </script>

 <%@ include file="../includes/footer.jsp"%>