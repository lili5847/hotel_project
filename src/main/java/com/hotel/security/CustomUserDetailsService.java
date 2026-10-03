package com.hotel.security;

import com.hotel.model.User;
import com.hotel.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.stream.Collectors;

@Service
public class CustomUserDetailsService
implements UserDetailsService {


@Autowired
private UserRepository userRepository;

@Override
public UserDetails loadUserByUsername(
        String username) throws UsernameNotFoundException {

    User user = userRepository
            .findByUsername(username)
            .orElseGet(() ->
                    userRepository
                            .findByEmail(username)
                            .orElseThrow(() ->
                                    new UsernameNotFoundException(
                                            "User not found: " + username
                                    )
                            )
            );

    return org.springframework.security.core.userdetails.User
            .withUsername(user.getUsername())
            .password(user.getPassword())
            .authorities(
                    user.getRoles()
                            .stream()
                            .map(role ->
                                    new SimpleGrantedAuthority(
                                            role.getName()
                                    )
                            )
                            .collect(Collectors.toSet())
            )
            .disabled(!user.isEnabled())
            .build();
}

}
