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

<title>Insert title here</title>
</head>
<body>

<header>
<a href="${ContextPath }/board/list">
<img src="https://img.icons8.com/color/50/000000/arsenal-fc.png" width="80" height="80"/>
</a>
<p class="aa">Gunners</p>
</header>


<div class="container">
	<div class="row">
		<div class="col-12">
			<hr>
			<h2>글수정</h2>
			<hr>
			<!-- 수정/삭제를 다르게 하려면 form의 action attribute를 변경해야 하는데 자바스크립트로 처리 -->
			<form method="post" id="modifyForm" enctype="multipart/form-data">
			<!-- 글 번호가 존재하니, 추가해줘야 함 -->
			<input type="hidden" name="id" value="${board.id }">
			<div class="form-group">
			<label for="input1"></label>
			<input type="text" class="form-control" id ="input1" value="${board.title }" name ="title" >
			</div>
			<div class="form-group">
			<label for="input2"></label>
			<textarea class="form-control" id ="input2" name = "content" >${board.content }</textarea>
			</div>
			
			<div class="row">
				<div class="col-12">
					<label for="">삭제할 파일 선택</label>
				</div>
			</div>		
			
				<c:forEach items="${fileNames }" var="fileName">
				<div class="row">
				<div class="col-1">
				<input type="checkbox" name ="removeFile" value="${fileName }">
				</div>
				<div class="col-11">
				<img class="img-fluid" src="${staticUrl}/${board.id }/${fileName }" alt="${fileName }">
				</div>
				</div>
			</c:forEach>
			
			<div class="form-group">
			<label for="input4"></label>
			<input type="file" class="form-control-file" id="input4" name="files" accept="image/*" style="float: right;" multiple>
			</div>
			<div class="form-group">
			<label for="input3"></label>
			<input type="text" class="form-control" id ="input3" value="${board.nickName }" readonly>
			</div>
			<input type="hidden" name="writer" value="${board.writer }">
			<button id="modifyButton" class = "btn btn-outline-primary" type="submit">수정하기</button>
			
			</form>
		</div>
	</div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-fQybjgWLrvvRgtW6bFlB7jaZrFsaBXjsOMm/tB9LTS58ONXgqbR9W8oWht/amnpF" crossorigin="anonymous"></script>
<script>
	$(document).ready(function(){
		
		$("#modifyButton").click(function(e){
			e.preventDefault();
			$("#modifyForm").attr("action", "modify").submit();
		});
	});
</script>

</body>
</html>