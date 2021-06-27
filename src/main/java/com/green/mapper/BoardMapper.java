package com.green.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.green.vo.BoardVo;
import com.green.vo.Criteria;

public interface BoardMapper {
	//@Select("select * from tbl_board where bno >0")
	public List<BoardVo> getList();
	public List<BoardVo> getListWithPaging(Criteria cri);
	
	public void insert(BoardVo board);
	public void insertSelectKey(BoardVo board);
	
	public BoardVo read(Long bno);
	
	public int delete(Long bno);
	
	public int update(BoardVo board);
	
	public int getTotalCount(Criteria cri);
	
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}
