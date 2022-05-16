<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix = "c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="b" tagdir="/WEB-INF/tags/board"%>
<c:set value="${pageContext.request.contextPath }" var="ContextPath"></c:set>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" integrity="sha512-1ycn6IcaQQ40/MKBW2W4Rhis/DbILU74C1vSrLJxCq57o941Ym01SwNsOMqvEBFlcgUa6xLiPY/NS5R+E6ztJQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css" integrity="sha384-zCbKRCUGaJDkqS1kPbPd7TveP5iyJE0EjAuZQTgFLD2ylzuqKfdKlfG/eSrtxUkn" crossorigin="anonymous">
<!-- <link href="/css/test.css" rel="stylesheet" type="text/css"> -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="../resource/css/test.css" />
<link rel="stylesheet" href="../resource/css/boardlist.css" />



<title>Insert title here</title>


</head>
<body>
<!-- <div id="page-wrapper"> -->
<header>
<a href="${ContextPath }/board/list">
<img src="https://img.icons8.com/color/50/000000/arsenal-fc.png" width="80" height="80"/>
</a>
<p class="aa">Gunners</p>
</header>

<b:navBar></b:navBar>
<br>

<div id="container">
	<div class="row d-flex justify-content-center">
		<div class="col-md-8">
		
			<table class="table">
				<thead>
					<tr>
						<th>글번호</th>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
						<th>조회수</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items = "${list }" var="board">
				<tr>
						<td>${board.id }</td>
						
						<td class="a">
						<!-- 링크로 가기 위한 a태그 -->
						<a href="get?id=${board.id }" >
						<c:out value="${board.title }"/>
						</a>
						<c:if test ="${board.hasFile }">
						<i class="far fa-images"></i>
						</c:if>
						<c:if test = "${board.replyCount >0 }">
							[${board.replyCount }]
						</c:if>
						</td>
						<td><c:out value="${board.nickName }"/></td>
						<td>${board.customInserted }</td>
						<td>${board.countlist }</td>
				</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- </div> -->

<br>
<form action="" name="form1" method="get" >
		<div class="form-inline row d-flex justify-content-center">
			<input class="form-control" type="text" id="keyword" name="keyword" value="${pageInfo.keyword}" placeholder="검색어를 입력하세요"/>
			<button id="searchBtn" class="btn btn-secondary" style="background-color: red;">Search</button>
		</div>
</form>
<br>


<!-- pagenation -->
<nav aria-label="Page navigation example">
  <ul class="pagination my justify-content-center">
  	<c:if test ="${pageInfo.hasPrevButton }">
  	<c:url value="/board/list" var="pageLink">
    	<c:param name = "page" value="${pageInfo.leftPageNumber - 1 }"></c:param>
    </c:url>
    <li class="page-item">
      <a class="page-link" href="${pageLink }" aria-label="Previous">
        <span aria-hidden="true">&laquo;</span>
      </a>
    </li>
  	</c:if>
    
  <c:forEach begin="${pageInfo.leftPageNumber }" end="${pageInfo.rightPageNumber }" var="pageNumber">
    <c:url value="/board/list" var="pageLink">
    	<c:param name = "page" value="${pageNumber }"></c:param>
    </c:url>
    <li class="page-item ${pageInfo.currentPage == pageNumber ? 'active' : '' }">
    <a class="page-link" href="${pageLink }">${pageNumber }</a>
    </li>
  </c:forEach>  
  
  <c:if test = "${pageInfo.hasNextButton }">  
  <c:url value="/board/list" var="pageLink">
    	<c:param name = "page" value="${pageInfo.rightPageNumber + 1 }"></c:param>
    </c:url>
    <li class="page-item">
      <a class="page-link" href="${pageLink }" aria-label="Next">
        <span aria-hidden="true">&raquo;</span>
      </a>
    </li>
  </c:if>
  </ul>
</nav>


<!-- Modal -->
<c:if test="${not empty result }">
<div class="modal fade" id="modal1" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">처리 결과</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
       <p>${result }</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</c:if>

<footer>
<div>
<br>
	<span>본 사이트는 박기열의 작업 결과물 입니다.</span> <br>
	<span>copyright@ Park Gi Yeol All Right Reserved </span> <br>
	<a class= "foot" href="https://github.com/GGiYeol">Github : <i class="fab fa-github"></i></a>
</div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-fQybjgWLrvvRgtW6bFlB7jaZrFsaBXjsOMm/tB9LTS58ONXgqbR9W8oWht/amnpF" crossorigin="anonymous"></script>
<script>
	$(document).ready(function(){
		$("#modal1").modal('show');
	});
	

</script>
</body>
</html>