package com.green.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.green.mapper.MemberMapper;
import com.green.security.domain.CustomUser;
import com.green.vo.MemberVO;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomUserDetailsService implements UserDetailsService{
	@Setter(onMethod_=@Autowired )
	private MemberMapper memberMapper;

	// 로그인시 패스워드 체크전에 실행
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.warn("Load User By userName : "+username);
		
		//userName = userId
		MemberVO vo = memberMapper.read(username);
				
		log.warn("queried by member mapper: "+vo);
		
		// db에서 유저 값을 확인한후 customUser인스턴스를 만들어 패스워드 체크하는
		//org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder 으로 값을 넘겨줌
		//여기서 패스워드를 체크하여 일치하면 loginSuccess handler를 실행
		return vo==null? null:new CustomUser(vo);  
	}

}
