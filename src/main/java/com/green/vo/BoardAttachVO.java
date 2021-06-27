package com.green.vo;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class BoardAttachVO {
	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType;
	
	private Long bno;
}
