package com.project.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.project.domain.MemberVO;
import com.project.domain.ReplyVO;
import com.project.service.ReplyService;

import lombok.Setter;


@RestController
@RequestMapping("/reply")
public class ReplyController {
	
	@Setter(onMethod_ = @Autowired)
	private ReplyService service;
	
	@GetMapping("/board/{boardId}")
	public List<ReplyVO> list(@PathVariable Integer boardId, HttpSession session){
		//로그인한 내용을 session에 MemberVO에 loggedInMember라는 이름으로 넣어놨었음
		MemberVO loggedIn = (MemberVO) session.getAttribute("loggedInMember");
		
		List<ReplyVO> list = service.list(boardId);
		
		if(loggedIn !=null) {
			//결과를 조회해온 list(댓글이 들어있음)의 글을 쓴 id와 작성자가 같을때 작성한 사람
			for(ReplyVO reply : list) {
				//작성한 자의 id
				String writerId = reply.getMemberId();
				//작성한 자의 id와 로그인한 사람의 아이디가 같다면?
				reply.setOwn(loggedIn.getId().equals(writerId));
			}
		}
		
		return list;
	}
	
	@PostMapping("/write")
	//post방식으로 온 데이터가 밑에 reply에 잘 쌓임
	//sessionAttribute라는 어노테이션으로 얻어 올 수도 있다.
	public ResponseEntity<String> write(ReplyVO reply, @SessionAttribute(value ="loggedInMember", required = false)  MemberVO logged) {
		
		/* MemberVO logged = (MemberVO) session.getAttribute("loggedInMember"); */
		
		if(logged != null && logged.getId().equals(reply.getMemberId())) {
			service.insert(reply);
			return ResponseEntity.status(HttpStatus.OK).build();
			
		}else {
			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
	}
	
	@PutMapping("/{id}")
	public ResponseEntity<String> modify(@PathVariable Integer id, @RequestBody ReplyVO reply, HttpSession session) {

		//로그인한 멤버
		MemberVO logged = (MemberVO) session.getAttribute("loggedInMember");
		
		//댓글 조회
		ReplyVO old = service.readById(id);
		//로그인된 멤버의 아이디와 댓글작성한 사람의 아이디가 같을때만 update
		if(logged !=null && logged.getId().equals(old.getMemberId())) {
			//업데이트
			old.setReply(reply.getReply());
			service.update(old);
			return ResponseEntity.ok("");
		}else {
			//권한없음
			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
	}
	
	@DeleteMapping("/{id}")
	public ResponseEntity<String> remove(@PathVariable Integer id, HttpSession session){
		
		//로그인한 멤버
		MemberVO logged = (MemberVO) session.getAttribute("loggedInMember");
		
		//댓글 조회
		ReplyVO old = service.readById(id);
		//로그인된 멤버의 아이디와 댓글작성한 사람의 아이디가 같을때만 update
		if(logged !=null && logged.getId().equals(old.getMemberId())) {
			//업데이트
			service.delete(id);
			return ResponseEntity.ok("");
		}else {
			//권한없음
			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
	}
}
