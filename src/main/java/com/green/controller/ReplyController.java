package com.green.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.green.service.ReplyService;
import com.green.vo.Criteria;
import com.green.vo.ReplyPageDTO;
import com.green.vo.ReplyVO;

import lombok.Setter; 

@RequestMapping("/replies")
@RestController
public class ReplyController {
	@Setter(onMethod_ =@Autowired )
	private ReplyService service;
	
	
	// 새로운 댓글생성(입력값 : 댓글정보-본문, 작성자, 게시글id)
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/new", 
			consumes = "application/json",
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO replyVO){
		System.out.println("댓글 생성"+replyVO);
		return service.register(replyVO) == 1?
				new ResponseEntity<String>("success", HttpStatus.OK)
				: new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	// 댓글조회(페이징기능, 입력값: 게시글id, page정보)
	@GetMapping(value = "/page/{bno}/{page}",
			produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyPageDTO> getList(
			@PathVariable("page") int page
			, @PathVariable("bno") Long bno){
		System.out.println("댓글 전체조회"+page+" "+bno);
		Criteria cri = new Criteria(page, 10);
//		List<ReplyVO> list = service.getList(cri, bno);
//		list.forEach(i->System.out.println(i));
		//return new ResponseEntity<List<ReplyVO>>(service.getList(cri, bno), HttpStatus.OK);
		
		return new ResponseEntity<ReplyPageDTO>(service.getListWithPage(cri, bno), HttpStatus.OK);
	}
	
	//댓글 하나 조회(입력값 : 댓글id)
	@GetMapping(value = "/{rno}",
			produces = {MediaType.APPLICATION_JSON_UTF8_VALUE, MediaType.APPLICATION_XML_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		ReplyVO vo = service.get(rno);
		System.out.println(rno+" "+vo);
		return new ResponseEntity<ReplyVO> (vo, HttpStatus.OK);
	}
	
	//댓글 하나 삭제(입력값 : 댓글id)
	@DeleteMapping("/{rno}")
	@PreAuthorize("principal.username == #replyer")
	public ResponseEntity<String> remove(@RequestHeader("replyer") String replyer, @PathVariable("rno") Long rno){
		System.out.println("delete"+rno);
		System.out.println(replyer);
		return service.remove(rno) == 1?
				new ResponseEntity<String>("success", HttpStatus.OK)
				: new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	//댓글 하나 수정(입력값 : 댓글id)
	@RequestMapping(value = "/{rno}", 
			method = {RequestMethod.PUT, RequestMethod.PATCH},
			consumes = "application/json",
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno){
		vo.setRno(rno);
		return service.modify(vo) == 1?
				new ResponseEntity<String>("success", HttpStatus.OK)
				: new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
}
