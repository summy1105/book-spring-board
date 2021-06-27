package com.green.service;

import java.util.List;

import com.green.vo.Criteria;
import com.green.vo.ReplyPageDTO;
import com.green.vo.ReplyVO;

public interface ReplyService {
	public int register(ReplyVO replyVO);
	public ReplyVO get(Long rno);
	public int remove(Long rno);
	public int modify(ReplyVO replyVO);
	public List<ReplyVO> getList(Criteria cri, Long bno);
	public ReplyPageDTO getListWithPage(Criteria cri, Long bno);
}
