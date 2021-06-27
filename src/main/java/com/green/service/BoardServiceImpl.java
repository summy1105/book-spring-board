package com.green.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.green.mapper.BoardAttachMapper;
import com.green.mapper.BoardMapper;
import com.green.vo.BoardAttachVO;
import com.green.vo.BoardVo;
import com.green.vo.Criteria;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
//@AllArgsConstructor
public class BoardServiceImpl implements BoardService {
	//spring 4.3 이상에서 자동처리됨
	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
	@Setter(onMethod_=@Autowired)
	private BoardAttachMapper attachMapper;
	
	@Override
	public List<BoardVo> getList(Criteria cri) {
		return boardMapper.getListWithPaging(cri);
	}

	// table 2개에 2개 이상의 데이터를 저장하기때문에 @Transactional annotation필요
	@Transactional
	@Override
	public void register(BoardVo board) {
		log.info(board.toString());
		boardMapper.insertSelectKey(board);		
		
		if(board.getAttachList() == null 
				|| board.getAttachList().size() <=0) return;
		
		board.getAttachList().forEach(attach->{
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVo get(Long bno) {
		return boardMapper.read(bno);
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove board and file : "+ bno);
		attachMapper.deleteAll(bno);
		return boardMapper.delete(bno) == 1;
	}

	@Override
	public boolean modify(BoardVo board) {
		log.info("sevice modify : "+board);
		attachMapper.deleteAll(board.getBno());
		boolean modifyResult = (boardMapper.update(board) == 1);
		
		// 오직 데이터 베이스의 파일 기록만 삭제하고 재기록
		if(modifyResult 
				&& board.getAttachList() != null  // 업로드할 파일이 없으면
				&& board.getAttachList().size()>0) {
			board.getAttachList().forEach(attach->{
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	@Override
	public int getTotal(Criteria cri) {
		return boardMapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttatchList(Long bno) {
		return attachMapper.findByBno(bno);
	}

}
