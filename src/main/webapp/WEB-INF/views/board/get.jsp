<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set value="${pageContext.request.contextPath }" var="ContextPath"></c:set>


<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css" integrity="sha384-zCbKRCUGaJDkqS1kPbPd7TveP5iyJE0EjAuZQTgFLD2ylzuqKfdKlfG/eSrtxUkn" crossorigin="anonymous">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="../resource/css/test.css" />



<script>

//현재 게시물의 댓글목록 가져오기(=새로고침)
$(document).ready(function(){
	
	const appRoot = '${pageContext.request.contextPath}';
	
	const listReply = function(){
		//계속 실행되니, 처음 실행시킬때 한번 비워주고
		$("#replyListContainer").empty();
	$.ajax({
		url : appRoot + "/reply/board/${board.id}",
		//성공했을 때
		success : function(list){
			for(let i = 0; i<list.length; i++){
				const replyMediaObject = $(`
				<hr>
				<div class="media">
				<img src="https://img.icons8.com/color/50/000000/arsenal-fc.png"/>
				  <div class="media-body">
				    <h5 class="mt-0"> <span class="reply-nickName"></span>
				    \${list[i].customInserted}</h5>
				    <p class="reply-body" style="white-space: pre;"></p>
				    
				    <div class="input-group" style="display:none;">
						<textarea name="" id="replyTextArea\${list[i].id}" class="form-control"></textarea>
							<div class="input-group-append">
						<button class="btn btn-outline-secondary cancel-button">취소</button>
						<button class="btn btn-outline-secondary" id="sendReply\${list[i].id}"><i class="fas fa-futbol fa-lg"></i></button>
						</div>
					</div>
				  </div>
				</div>`);
				
					replyMediaObject.find("#sendReply" + list[i].id).click(function() {
					const reply = replyMediaObject.find("#replyTextArea" + list[i].id).val();
					const data = {
						reply : reply
					};
					
					$.ajax({
						url : appRoot + "/reply/" +list[i].id,
						type : "put",
						contentType : "application/json",
						data : JSON.stringify(data),
						complete : function(){
							listReply();
						}
					});
				});
				
				replyMediaObject.find(".reply-nickName").text(list[i].nickName);
				replyMediaObject.find(".reply-body").text(list[i].reply);
				replyMediaObject.find(".form-control").text(list[i].reply);
				replyMediaObject.find(".cancel-button").click(function(){
					replyMediaObject.find(".reply-body").show();
					replyMediaObject.find(".input-group").hide();
				});
				
				if(list[i].own){
					//본인이 작성한 것만 수정버튼 추가
					const modifyButton = $("<button class ='btn btn-outline-secondary'>수정</button>");
					modifyButton.click(function(){
						$(this).parent().find('.reply-body').hide();
						$(this).parent().find('.input-group').show();
					});
					replyMediaObject.find(".media-body").append(modifyButton);
					
					//삭제버튼 추가
					const removeButton = $("<button class = 'btn btn-outline-danger'>삭제</button>");
					removeButton.click(function(){
						if(confirm("삭제 하시겠습니까?")){
							
							$.ajax({
								url : appRoot + "/reply/" +list[i].id,
								type : "delete",
								complete : function(){
									listReply();
								}
							});
						}
						
					});
					
					replyMediaObject.find(".media-body").append(removeButton);
					
				}
				
			$("#replyListContainer").append(replyMediaObject);
				
			}
		}
	});
}
	listReply(); //페이지 로딩 후 댓글 리스트 가져오는 함수(1번 실행)
	//댓글 전송
	$("#sendReply").click(function(){
		const reply = $("#replyTextArea").val();
		const memberId = '${sessionScope.loggedInMember.id}';
		const boardId = '${board.id}';
		
		const data ={
				reply : reply,
				memberId : memberId,
				boardId : boardId
		}
		
		$.ajax({
			url : appRoot + "/reply/write",
			type : "post",
			data : data,
			//refresh
			success : function(){
				//textarea reset
				$("#replyTextArea").val("");
			},
			error : function(){
				alert("댓글 권한이 없습니다. 로그인해 주세요");
			},
			complete : function(){
				//댓글 리스트 새로고침
				listReply(); 
			}
		});
	});
});
</script>

<title>Insert title here</title>
</head>
<body>
<header>
<a href="${ContextPath }/board/list">
<img src="https://img.icons8.com/color/50/000000/arsenal-fc.png" width="80" height="80"/>
</a>
<p class="aa">Gunners</p>
</header>


<br>
<div class="container">
	<div class="row">
		<div class="col">
			<form method="post" id="modifyForm">
			<!-- 글 번호가 존재하니, 추가해줘야 함 -->
			<input type="hidden" name="id" value="${board.id }">
			<div class="board-view">
			<div>
				<h2>${board.title }</h2>
			</div>
				<div>${board.nickName }</div>
				<hr>
				<div style="text-align:right">
				<c:if test="${sessionScope.loggedInMember.id eq board.writer }">
				<a href="remove?id=${board.id }" class="btn btn-outline-secondary" id="removeButton" >
					글 삭제
				</a>
				<a href="modify?id=${board.id }" class="btn btn-outline-secondary" >
					글 수정
				</a>
				</c:if>
				</div>
				<hr>
				
				<div class="form-group" id="main">
				${board.content }
				<c:forEach items="${fileNames }" var="fileName">
				<div class="row">
				<div class="col">
				<img class="img-fluid" src="${staticUrl}/${board.id }/${fileName }" alt="${fileName }">
				</div>
				</div>
				</c:forEach>
				</div>
				
				<hr class="repl">
			</div>
			</form>
		</div>
	</div>
</div>


<!-- 로그인한 멤버만 볼 수 있게 -->
<c:if test ="${not empty sessionScope.loggedInMember }">
<!-- 댓글작성 textarea-->

<div class="container">
	<div class="row">
		<div class="col">
		<hr>
			<!-- .input-group>textarea#replyTextarea.form-control+.input-group-append>button.btn.btn-outline-secondary#sendReply -->
			<div class="input-group">
				<textarea name="" id="replyTextArea" class="form-control" placeholder="댓글을 입력해주세요"></textarea>
				<div class="input-group-append">
					<button class="btn btn-outline-secondary" id="sendReply"><i class="fas fa-futbol fa-lg"></i></button>
				</div>
			</div>
		</div>
	</div>
</div>
</c:if>

<!-- 댓글 컨테이너 -->

<div class="container">
	<div class="row">
		<div class="col">
			<div id="replyListContainer">
			</div>
		</div>
	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-fQybjgWLrvvRgtW6bFlB7jaZrFsaBXjsOMm/tB9LTS58ONXgqbR9W8oWht/amnpF" crossorigin="anonymous"></script>
<script>
$(document).ready(function(){
	$("#removeButton").click(function(e){
		//브라우저한테 받아야 하는데, 첫번째 파라미터에 명시하면 됨.
		e.preventDefault();//기본 동작을 진행하지 않도록
		
		$("#modifyForm").attr("action", "remove").submit();
	});
});
</script>
</body>
</html>