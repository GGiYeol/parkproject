package com.project.mapper;

import org.apache.ibatis.annotations.Param;

public interface FileMapper {

	int insert(@Param("boardId") int boardId, @Param("fileName")String fileName);

	String[] selectNamesByBoardId(Integer boardId);

	void delete(@Param("boardId") int boardId, @Param("fileName") String fileName);

	void deleteByBoardId(Integer boardId);



}
