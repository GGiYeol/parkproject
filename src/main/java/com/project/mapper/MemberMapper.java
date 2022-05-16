package com.project.mapper;

import com.project.domain.MemberVO;

public interface MemberMapper {

	public int insert(MemberVO member);
	
	public MemberVO select(String id);
	
	public int update(MemberVO member);
	
	public int delete(String id);

	
	
}
