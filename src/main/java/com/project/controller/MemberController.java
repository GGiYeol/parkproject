package com.project.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.domain.MemberVO;
import com.project.service.MemberService;

import lombok.Setter;
	
@Controller
@RequestMapping("/member")
public class MemberController {

	@Setter(onMethod_=@Autowired)
	private MemberService service;
	

	@RequestMapping("/idcheck")
	@ResponseBody
	public String idcheck(String id) {
	//ajax에서 받은 값이 id로 받아서 id로 넣어줌
		boolean idHas = service.hasId(id);
		
		if(idHas) {
			return "unable";
		} else {
			return "able";
	
		}
		
	}
	@RequestMapping("/nickNameCheck")
	@ResponseBody
	public String nickNameCheck(String nickName) {
		boolean nickNameHas = service.hasNickName(nickName);
		if(nickNameHas) {
			return "unable";
		} else {
			return "able";
	
		}
	}
	
	@GetMapping("/signup")
	public void signup() {
		
	}
	//requesthanddler method
	@PostMapping("/signup")
	public String signup(MemberVO member, RedirectAttributes rttr) {
		
		boolean ok = service.register(member);
		
		if(ok) {
			rttr.addFlashAttribute("result", member.getNickName() + "님 가입을 환영합니다!");
			return "redirect:/board/list";
		} else {
			return "redirect:/member/signup";
		}
	}
	@GetMapping("/login")
	public void login() {
		
	}
	@PostMapping("/login")
	public String login(String id, String password, HttpSession session) {
		//service를 사용해 아이디로 맴버정보받기
		//login.jsp의 name을 통해 받아옴
		MemberVO vo = service.read(id);
		
		if(vo == null) {
			//로그인실패
			return null;
		}
		//얻어온 맴버vo의 패스워드와 입력한 패스워드가 같은지 확인
		boolean correctPassword=password.equals(vo.getPassword());
		
		if(!correctPassword) {
			//로그인 실패
			return null;
		}
		//로그인성공
		session.setAttribute("loggedInMember", vo);
		//로그인이 되었는지 띄움
		System.out.println(session.getAttribute("loggedInMember"));
		return "redirect:/board/list";
		//다음요청에는 로그인이 되었는지 안되었는지 판단
		//세션객체를 이용하면 됨. 
		
	}
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		
		session.invalidate();
		
		return "redirect:/board/list";
	}
	
	@GetMapping("/info")
	public String info(HttpSession session) {
		MemberVO vo = (MemberVO)session.getAttribute("loggedInMember");
		if(vo == null) {
			return "redirect:/member/login";
		}
		return null;
	}
	@PostMapping("/info")
	public String info(HttpSession session, MemberVO member, RedirectAttributes rttr) {
		
		MemberVO vo = (MemberVO)session.getAttribute("loggedInMember");
		//로그아웃된 상태
		if(vo == null) {
			return "redirect:/member/login";
		}
		//로그인된 상태
		boolean ok = service.modify(member);
		if(ok) {
			rttr.addFlashAttribute("result", "회원정보가 변경되었습니다");
			//최신정보로 바꾸기 위함.
			session.setAttribute("loggedInMember", service.read(member.getId()));
		}else {
			rttr.addFlashAttribute("result1", "회원정보가 변경되지않았습니다");
			return "redirect:/member/info";
		}
		return "redirect:/board/list";
	}
	
	@PostMapping("/remove")
	public String remove(String id, HttpSession session, RedirectAttributes rttr) {
		MemberVO vo = (MemberVO)session.getAttribute("loggedInMember");
		
		if(vo == null) {
		return "redirect:/member/login";
		}
		 
		service.remove(id);
		
		session.invalidate();
		rttr.addFlashAttribute("result", "회원탈퇴되었습니다");
		return "redirect:/board/list";
	}
}

