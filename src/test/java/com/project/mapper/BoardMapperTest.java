package com.project.mapper;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.project.domain.BoardVO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class BoardMapperTest {
	
	@Autowired
	public BoardMapper mapper;
	
	
	@Test
	public void mapperTest() {
		assertNotNull(mapper);
	}
	
	@Test
	public void insertTest() {
		BoardVO vo = new BoardVO();
		
		vo.setTitle("title" + Math.random());
		vo.setContent("content" + Math.random());
		vo.setWriter("writer" + Math.random());
		
		
		int cnt = mapper.insert(vo);
		assertEquals(1, cnt);
	}
	
}
