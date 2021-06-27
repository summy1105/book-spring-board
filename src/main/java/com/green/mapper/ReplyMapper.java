package com.green.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.green.vo.Criteria;
import com.green.vo.ReplyVO;

public interface ReplyMapper {
	public int insert(ReplyVO replyVO);
	public ReplyVO read(Long rno);
	
	public ArrayList<ReplyVO> readAll();
	
	public int delete(Long rno);
	
	public int update(ReplyVO replyVO);
	
	public int modify(ReplyVO replyVO);
	
	public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long bno);
	
	public int getCountByBno(Long bno);
}
