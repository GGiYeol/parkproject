package com.project.domain;

import lombok.Data;

@Data
public class PageInfoVO {

	private Integer lastPage;
	private Integer countRows; //총 게시물 수
	private Integer currentPage; //현재 페이지 번호	
	private Integer leftPageNumber;
	private Integer rightPageNumber;
	private Boolean hasPrevButton;
	private Boolean hasNextButton;
	private String keyword;

	
	
}
