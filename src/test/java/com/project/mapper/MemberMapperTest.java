package com.project.mapper;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.project.domain.MemberVO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class MemberMapperTest {

	@Autowired
	public MemberMapper mapper;
	
	@Test
	public void insertTest() {
		MemberVO vo = new MemberVO();
		vo.setId("member1");
		vo.setAddress("here");
		vo.setEmail("aaa@aaa.com");
		vo.setPassword("password");
		int cnt = mapper.insert(vo);
		
		assertEquals(1,cnt);
	}
}
