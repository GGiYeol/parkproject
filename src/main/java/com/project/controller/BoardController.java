package com.project.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.domain.BoardVO;
import com.project.domain.PageInfoVO;
import com.project.service.BoardService;

import lombok.Setter;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Setter(onMethod_ = @Autowired)
	private BoardService service;
	
	
	@RequestMapping("/list")
	public void list(@RequestParam(value="page", defaultValue="1") Integer page, 
			@RequestParam(value = "keyword", defaultValue = "") String keyword,
			Model model) {
		
		//page에 10개씩 보여줌
		Integer numberPerPage = 10;
		
		
		//컨트롤러는 서비스에게 일을 시킴
		//서비스는 DAO에 일을 시킴
		//게시물 목록
		
		/* List<BoardVO> list = service.getList(); */
		List<BoardVO> list = service.getListPage(page, keyword, numberPerPage);
		PageInfoVO pageInfo = service.getPageInfo(page, numberPerPage);
		
		//attribute는 spring에서는 model에 넣어서 넘겨줌
		model.addAttribute("list", list);
		model.addAttribute("pageInfo", pageInfo);
		
		//원 경로는 /web-inf~~인데 다 prefix와 serfix는 설정에 넣어줘서 따로 작성하지 않아도 됨. 
		
		
	}
	
	@GetMapping({"/get","/modify"})
	public void get(@RequestParam("id") Integer id, Model model) {
		BoardVO board = service.get(id);
		
		String[] fileNames = service.getFileNamesByBoardId(id);

		
		
		service.countList(id);
		model.addAttribute("board", board);
		model.addAttribute("fileNames", fileNames);
		
	}
	
	@PostMapping("/modify")
	public String modify(BoardVO board, String[] removeFile, MultipartFile[] files, RedirectAttributes rttr) {
		
		System.out.println(Arrays.toString(removeFile));
		
		try {
			if(service.modify(board,removeFile,files)) {
				
				rttr.addFlashAttribute("result", board.getId()+"번 게시물이 수정되었습니다.");
			}
		} catch (IllegalStateException | IOException e) {
			
			e.printStackTrace();
			rttr.addFlashAttribute("result", board.getId()+"번 게시물이 수정 중 문제가 발생했습니다.");
		}
//				rttr.addFlashAttribute("result", "success");
//				return "redirect:/board/get";
		return "redirect:/board/list";
	}
	
	@GetMapping("/register")
	public void register() {
		
	}
	
	@PostMapping("/register")
	//redirect 하기 위해 string으로 결정
	public String register(BoardVO board, MultipartFile[] files, RedirectAttributes rttr) {
		
		
		try {
			service.register(board, files);
			rttr.addFlashAttribute("result", "게시물이 작성되었습니다.");
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
			rttr.addFlashAttribute("result", "작성에 문제가 있습니다"); 
		}
		
		//등록된 게시물의 번호를 list에 쓰려고 session에 넣어줘야하는데, session에 잠시 넣었다가 지우는 것 RedirectAttributes
		//add attribute를 하기 위해
		
		
		return "redirect:/board/list";
	}

	@PostMapping("/remove")
	public String remove(int id, RedirectAttributes rttr) {
		
		if(service.remove(id)) {
			rttr.addFlashAttribute("result", "게시물이 삭제되었습니다.");
		}
		
		
		return "redirect:/board/list";
	}

}
