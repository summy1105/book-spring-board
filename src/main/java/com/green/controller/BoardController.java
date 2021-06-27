package com.green.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.green.service.BoardService;
import com.green.vo.BoardAttachVO;
import com.green.vo.BoardVo;
import com.green.vo.Criteria;
import com.green.vo.PageDTO;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board/*")
public class BoardController {
	@Setter(onMethod_ =@Autowired )
	private BoardService service;

	@GetMapping("/list")
	public void list(Model model, Criteria cri) {
		log.info("select all");
		System.out.println(cri);
		List<BoardVo> list = service.getList(cri);
		list.forEach(i->System.out.println(i));
		model.addAttribute("list", service.getList(cri));
		
		int total = service.getTotal(cri);
		model.addAttribute("pageMaker", new PageDTO(total, cri));
	}
	
	
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() {} // return "/board/register"
	
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVo board, RedirectAttributes rttr) {
		log.info("========================");
		log.info("board register : "+board);
		if(board.getAttachList()!= null) {
			board.getAttachList().forEach(attach -> log.info(attach.toString()));
		}			
		log.info("==================================");
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		
		return "redirect:/board/list";
	}
	
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get or /modify");
		System.out.println(cri);
		model.addAttribute("board", service.get(bno));
	}
	
	@GetMapping(value = "/getAttachList",
			produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		return new ResponseEntity<List<BoardAttachVO>>(service.getAttatchList(bno), HttpStatus.OK);
	}
	
	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/modify")
	public String modify(BoardVo board, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {
		System.out.println("post /modify  :"+board);
		if(service.modify(board)) {
			System.out.println("correct complete");
			rttr.addFlashAttribute("result", "success");
		}
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		return "redirect:/board/list";
	}
	
	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr, String writer) {
		log.info("post /delete :"+bno);
		List<BoardAttachVO> attachList = service.getAttatchList(bno);
		// 실제 파일 데이터 이외  DB의 board 게시글과 파일정보를 삭제
		if(service.remove(bno)) {
			deleteFiles(attachList); // 서버(DBX)에 파일데이터 삭제
			rttr.addFlashAttribute("result", "succeess");
		}		
		return "redirect:/board/list"+cri.getListLink();
	}
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size()==0) {
			return;
		}
		attachList.forEach(attach->{
			try {
				Path file = Paths.get("C:\\upload\\"+attach.getUploadPath()
						+"\\"+attach.getUuid()+"_"+attach.getFileName());
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbznail = Paths.get("c:\\upload\\"+attach.getUploadPath()
						+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					 Files.delete(thumbznail);
				}
			}catch(Exception e) {
				log.error("delete File error"+e.getMessage());
			}
		});
	}
}
