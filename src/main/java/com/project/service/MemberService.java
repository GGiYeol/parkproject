package com.project.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.domain.MemberVO;
import com.project.mapper.BoardMapper;
import com.project.mapper.MemberMapper;
import com.project.mapper.ReplyMapper;

import lombok.Setter;

@Service
public class MemberService {

	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper replyMapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardService boardService;
	
	public MemberVO read(String id) {
		return mapper.select(id);
	}
	
	public boolean register(MemberVO member) {
		return mapper.insert(member) == 1;
	}
	
	public boolean modify(MemberVO member) {
		return mapper.update(member) ==1;
	}
	
	@Transactional
	public boolean remove(String id) {
		//맴버가 작성한 댓글 지우기
		replyMapper.deleteByMemberId(id);
		//맴버가 작성한 게시물 지우기

		Integer[] boardIds = boardMapper.selectByMemberId(id);
		 
		if(boardIds !=null) {
			
		for(Integer boardId : boardIds) {
			boardService.remove(boardId);
			}
		}
		
		//맴버 지우기
		return mapper.delete(id) ==1;
	}

	public boolean hasId(String id) {
		
		MemberVO member = mapper.select(id);
		 
		
		return member != null;
	}

	public boolean hasNickName(String nickName) {
		
		MemberVO member  = mapper.select(nickName);
		
		return member != null;
	}
}
