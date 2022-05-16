package com.project.mapper;

import java.util.List;

import com.project.domain.ReplyVO;

public interface ReplyMapper {

	public List<ReplyVO> list(Integer boardId);

	public int insert(ReplyVO reply);

	public ReplyVO selectById(Integer id);

	public boolean update(ReplyVO newReply);

	public int delete(Integer id);

	public int deleteByBoardId(Integer boardId);

	public int deleteByMemberId(String memberId);

}
