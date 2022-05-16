package com.project.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.project.domain.BoardVO;

public interface BoardMapper {

	public List<BoardVO> getList();
	public int insert(BoardVO board);
	public BoardVO read(int id);
	public int delete(int id);
	public int update(BoardVO board);
	public List<BoardVO> getListPage(@Param("from") Integer from,
			@Param("keyword") String keyword,
			@Param("items") Integer numberPerPage);
	public Integer getCountRows();
	public int deleteByMemberId(String memberId);
	public int listCount(int id);
	public Integer[] selectByMemberId(String memberId);
	
}
