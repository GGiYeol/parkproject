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
<link rel="stylesheet" href="../resource/css/signup.css" />
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
		<div class="col">
			
			<form method="post" class="signForm">
				<div class="form-group">
				<br>
					<h2>회원가입</h2>
					<br>
					<label for="input1">아이디</label>
					<!-- .input-group>.input-append>button.btn.btn-secondary#idCheckButton{중복확인} -->
					<div class="input-group">
					<input type="text" class="form-control" id="input1" required name = "id" value="${member.id }">
						<div class="input-group-append">
						<!-- submit이 일어나지 않게 type을 button으로 설정 -->
							<button class="btn btn-secondary" id="idCheckButton"type="button" 
							style="background-color: red;">중복확인</button>
						</div>
					</div>
					<!-- small.form-text#idCheckMessage -->
					<small class="form-text" id="idCheckMessage"></small>
				</div>
				<div class="form-group">
					<label for="input2">패스워드</label>
					<input type="password" class="form-control" id="input2" required name ="password" value="${member.password }" >
				</div>
				<div class="form-group">
					<label for="input6">패스워드확인</label>
					<input type="password" class="form-control" id="input6" required >
				</div>
				<div class="form-group">
					<label for="input5">닉네임</label>
					<div class="input-group">
					<input type="text" class="form-control" id="input5" required name ="nickName" value="${member.nickName }">
					<div class="input-group-append">
						<button class="btn btn-secondary" id="nickNameCheckButton"
						 type="button"style="background-color: red;">중복확인</button>
					</div>
				</div>
				<small class="form-text" id="nickNameCheckMessage"></small>
					</div>
					
				<div class="form-group">
					<label for="input3">이메일</label>
					<input type="email" class="form-control" id="input3" required name ="email" value="${member.email }">
				</div>
				
				<div class="form-group">
					<label for="input4">주소</label>
					<input type="text" class="form-control" id="input4" required name="address"value="${member.address }">
				</div>
				<button class="btn1" id ="submitButton1" >가입</button>
			</form>
		</div>
	</div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-fQybjgWLrvvRgtW6bFlB7jaZrFsaBXjsOMm/tB9LTS58ONXgqbR9W8oWht/amnpF" crossorigin="anonymous"></script>

<script>
		//id 중복확인버튼이 클릭되면
	$(document).ready(function(){
		const passwordInput =$("#input2");
		const passwordConfirmInput =$("#input6");
		const submitButton =$("#submitButton1");
		//submit 버튼 활성화 조건 변수
		let idAble = false;
		let passwordCheck = false;
		let nickNameAble = false;
		
		//submit 버튼 활성화 메소드
		let enableSubmit = function(){
			if(idAble && passwordCheck && nickNameAble){
				submitButton.removeAttr("disabled");
			} else {
				submitButton.attr("disabled", true);
			}
		}
		
		const appRoot = "${pageContext.request.contextPath}";
		
		$("#idCheckButton").click(function(){
			//클릭하면 버튼 비활성화
			$("#idCheckButton").attr("disabled", true);
			
			//id 인풋요소에 입력된 값을
			const idValue = $("#input1").val().trim();
			
			//아이디에 빈 요소가 있을 때
			if(idValue === ""){
				$("#idCheckMessage").text("아이디를 입력해주세요").removeClass("text-primary text-danger").addClass("text-warning");
				$("#idCheckButton").removeAttr("disabled");
				return;
			}
			
			
		//서버에 전송 후
			$.ajax({
				url : appRoot + "/member/idcheck",
				data : {
					id : idValue
				},
		//응답받은 값에 따라 성공
				success : function(data){
					switch (data) {
					case "able":
						$("#idCheckMessage").text("사용가능한 아이디입니다.").removeClass("text-warning text-danger").addClass("text-primary");
						//서브밋 버튼 활성화 추
						idAble = true;			
						break;
					case "unable":
						//사용불가능
						$("#idCheckMessage").text("중복된 아이디입니다.").removeClass("text-primary text-warning").addClass("text-danger");
						//서브밋 버튼 비활성화 추가
						idAble = false;
						break;
					default:
						break;
					}
				},
				//아이디체크버튼을 누르면 다시 활성화
				complete : function(){
					//조건이 충족되었을때 버튼 활성화(id 사용 가능, password일치 확인)
					enableSubmit();
					
					$("#idCheckButton").removeAttr("disabled");
				}
			});
		});
		
		
		
		//두개의 인풋요소 같을 때만 서브밋버튼 활성화
		const confirmFunction =function(){
			const passwordValue=passwordInput.val();
			const passwordConfirmValue=passwordConfirmInput.val();
			
		if(passwordValue === passwordConfirmValue){
			//submitButton.removeAttr("disabled");
			passwordCheck = true;
		} else{
			//submitButton.attr("disabled", true);
			passwordCheck = false;
		}
		
		enableSubmit(); //조건이 충족되었을때만 submit버튼 활성화 
		};
		
		submitButton.attr("disabled", true);
		
		passwordInput.keyup(confirmFunction);
		
		passwordConfirmInput.keyup(confirmFunction);
		
		
		//nicknameCheckButton이 클릭되었을때
		//nickName input의 값을 읽어서
		///member/nickNameCheck로 요청 보낸 결과에 따라
		//메세지 출력 and 서브밋 버튼 활성화 비활성
		$("#nickNameCheckButton").click(function(){
			$("#nickNameCheckButton").attr("disabled", true);
			
			const nickName = $("#input5").val().trim();
			
			if(nickName === ""){
				$("#nickNameCheckMessage").text("닉네임을 입력해주세요")
				.removeClass("text-primary text-danger")
				.addClass("text-warning");
				$("#nickNameCheckButton").removeAttr("disabled");
				return;
			}
			
			$.ajax({
				url : appRoot + "/member/nickNameCheck",
				data : {
					nickName : nickName
				},
				success : function(data){
					switch(data){
					case "able" :
					$("#nickNameCheckMessage").text("사용가능한 닉네임입니다.")
					.removeClass("text-warning text-danger")
					.addClass("text-primary");
					nickNameAble = true;
					break;
					
					case "unable" :
					$("#nickNameCheckMessage").text("사용 불가능한 닉네임입니다.")
					.removeClass("text-warning text-primary")
					.addClass("text-danger");
					nickNameAble = false;
					break;
					
					}
				},
				
				complete : function(){
					enableSubmit();
					$("#nickNameCheckButton").removeAttr("disabled");
				}
			});
		});
		
		
	});
</script>

</body>
</html>