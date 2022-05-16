package com.project.domain;

import java.time.LocalDateTime;
import java.time.ZoneId;

import lombok.Data;

@Data
public class ReplyVO {

	
	private Integer id;
	private Integer boardId;
	private String memberId;
	private String reply;
	private LocalDateTime inserted;
	private LocalDateTime updated;
	private String nickName;
	private Boolean own;
	
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
