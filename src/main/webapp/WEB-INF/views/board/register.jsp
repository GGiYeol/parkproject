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
			<h2>글쓰기</h2>
			<hr>
			<form method="post" enctype="multipart/form-data">
			<div class="form-group">
			<label for="input1"></label>
			<input type="text" class="form-control" id ="input1" name ="title" placeholder="제목을 입력하세요" required>
			<label for="input3"></label>
			<input type="text" class="form-control" id ="input3" value="${sessionScope.loggedInMember.nickName }" readonly>
			</div>
			
			<div class="form-group">
			<label for="input2"></label>
			<textarea class="form-control h-25" rows="20" name ="content" placeholder="내용을 입력하세요" cols="500px"required></textarea>
			</div>
			
			<div class="form-group">
				<label for="input4"></label>
				<input type="file" class="form-control-file" id="input4" name="files" accept="image/*" style="float: right;" multiple>
			</div>
			
			<!-- writer값이 넘어가야 하는데 보여지면 안되니, hidden으로 작성 -->
			<input type="hidden" name="writer" value="${sessionScope.loggedInMember.id }">
			<button class = "btn btn-outline-primary" type="submit" style="float: right;">등록</button>
			</form>
		</div>
	</div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-fQybjgWLrvvRgtW6bFlB7jaZrFsaBXjsOMm/tB9LTS58ONXgqbR9W8oWht/amnpF" crossorigin="anonymous"></script>

</body>
</html>