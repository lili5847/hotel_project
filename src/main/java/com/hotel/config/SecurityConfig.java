package com.hotel.config;

import com.hotel.repository.UserRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import java.util.Collections;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    // ១. បង្កើត UserDetailsService ដើម្បីទាញ User ពី Database មក Authenticate
    @Bean
    public UserDetailsService userDetailsService(UserRepository userRepository) {
        return email -> userRepository.findByEmail(email)
                .map(user -> new org.springframework.security.core.userdetails.User(
                        user.getEmail(),
                        user.getPassword(), // ប្រើgetPassword() សម្រាប់ការផ្ទៀងផ្ទាត់
                        Collections.singletonList(new SimpleGrantedAuthority(user.getRole()))
                ))
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
    }

    // ២. Security Filter Chain Configuration
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Disable CSRF សម្រាប់ការរត់ JSP និង Form
                .authorizeHttpRequests(auth -> auth
                        // Public Access (មិនបាច់ Login)
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/webjars/**").permitAll()
                        .requestMatchers("/login", "/register", "/", "/rooms", "/room-detail", "/api/rooms/**").permitAll()

                        // Customer & Admin Access
                        .requestMatchers("/reservations/**").hasAnyAuthority("CUSTOMER", "ADMIN", "ROLE_CUSTOMER", "ROLE_ADMIN")

                        // Admin Access Only
                        .requestMatchers("/admin/**").hasAnyAuthority("ADMIN", "ROLE_ADMIN")

                        // ផ្សេងៗទៀតត្រូវតែ Authenticate
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .usernameParameter("email") // ប្រើ Email ជា Username សម្រាប់ការ Login
                        .passwordParameter("password")
                        .defaultSuccessUrl("/rooms", true)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout=true")
                        .invalidateHttpSession(true)
                        .deleteCookies("JSESSIONID")
                        .permitAll()
                );

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }
}