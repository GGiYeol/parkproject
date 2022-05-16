package com.project.domain;

import java.time.LocalDateTime;
import java.time.ZoneId;

import lombok.Data;

@Data
public class BoardVO {

	private int id;
	private String title;
	private String content;
	private String writer;
	private LocalDateTime inserted;
	private LocalDateTime updated;
	private String nickName;
	
	private Integer replyCount;
	private int countlist;
	
	private Boolean hasFile;
	
	
	
	
	public String getCustomInserted() {
		// 현재일시
		LocalDateTime now = LocalDateTime.now(ZoneId.of("+09:00"));
		LocalDateTime beforeOneDayFromNow = now.minusDays(1);

		if (inserted.isBefore(beforeOneDayFromNow)) {
			return inserted.toLocalDate().toString();
		} else {
			return inserted.toLocalTime().toString();
		}
	}
	
}
