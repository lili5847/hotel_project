package com.hotel.config;

import com.hotel.repository.UserRepository;
import com.hotel.security.JwtAccessDeniedHandler;
import com.hotel.security.JwtAuthenticationEntryPoint;
import com.hotel.security.JwtAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.util.Collections;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true) // បើកដំណើរការ @PreAuthorize / @PostAuthorize
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationEntryPoint authenticationEntryPoint;

    @Autowired
    private JwtAccessDeniedHandler accessDeniedHandler;

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    // ១. Fetch User ពី Database តាមរយៈ Username ឬ Email មក Authenticate
    @Bean
    public UserDetailsService userDetailsService(UserRepository userRepository) {
        return usernameOrEmail -> userRepository.findByUsernameOrEmail(usernameOrEmail, usernameOrEmail)
                .map(user -> {
                    String roleStr = user.getRole() != null ? user.getRole() : "CUSTOMER";
                    String roleName = roleStr.startsWith("ROLE_") ? roleStr : "ROLE_" + roleStr;

                    return new org.springframework.security.core.userdetails.User(
                            user.getUsername(),
                            user.getPassword(),
                            Collections.singletonList(new SimpleGrantedAuthority(roleName))
                    );
                })
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username or email: " + usernameOrEmail));
    }

    // ២. PasswordEncoder Bean
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // ៣. AuthenticationManager Bean (សម្រាប់ JWT Auth)
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    // ៤. Security Filter Chain Configuration
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // បិទ CSRF សម្រាប់ REST APIs
                .csrf(AbstractHttpConfigurer::disable)

                // ដោះស្រាយ 401 Unauthorized និង 403 Forbidden សម្រាប់ JWT REST APIs
                .exceptionHandling(exception -> exception
                        .authenticationEntryPoint(authenticationEntryPoint)
                        .accessDeniedHandler(accessDeniedHandler)
                )

                // កំណត់ Session ទៅជា STATELESS (មិនរក្សាទុក Session ក្នុង Server ឡើយ ប្រើ JWT សុទ្ធ)
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )

                // កំណត់ URL Permissions
                .authorizeHttpRequests(auth -> auth
                        // Public Endpoints (Web Views, Static Assets, Auth APIs, និង Swagger Docs)
                        .requestMatchers(
                                "/",
                                "/login",
                                "/register",
                                "/rooms",
                                "/room-detail",
                                "/api/auth/**",
                                "/v3/api-docs/**",
                                "/swagger-ui/**",
                                "/swagger-ui.html",
                                "/css/**",
                                "/js/**",
                                "/images/**",
                                "/webjars/**"
                        ).permitAll()

                        // Role-based Endpoints
                        .requestMatchers("/api/reservations/**").hasAnyRole("CUSTOMER", "USER", "ADMIN")
                        .requestMatchers("/api/admin/**", "/admin/**").hasRole("ADMIN")

                        // Any other requests must be authenticated with JWT
                        .anyRequest().authenticated()
                );

        // បញ្ចូល JwtAuthenticationFilter ចូលទៅក្នុង Spring Security Filter Chain
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}