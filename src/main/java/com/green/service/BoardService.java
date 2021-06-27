package com.green.service;

import java.util.List;

import com.green.vo.BoardAttachVO;
import com.green.vo.BoardVo;
import com.green.vo.Criteria;

public interface BoardService {

		public List<BoardVo> getList(Criteria cri);
		public void register(BoardVo board); //insert
		public BoardVo get(Long bno); //read
		public boolean remove(Long bno); //delete
		public boolean modify(BoardVo board); //update
		public int getTotal(Criteria cri);
		
		public List<BoardAttachVO> getAttatchList(Long bno);
}
