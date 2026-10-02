package com.hotel.config;

import jakarta.servlet.DispatcherType;
import com.hotel.security.JwtAccessDeniedHandler;
import com.hotel.security.JwtAuthenticationEntryPoint;
import com.hotel.security.JwtAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy; // 1. Import Lazy
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationEntryPoint authenticationEntryPoint;

    @Autowired
    private JwtAccessDeniedHandler accessDeniedHandler;

    @Autowired
    @Lazy // 2. បន្ថែម @Lazy ត្រង់នេះ ដើម្បីកាត់ផ្តាច់ Circular Dependency ជាមួយ JwtAuthenticationFilter
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    // ១. PasswordEncoder Bean
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    // ៣. Security Filter Chain Configuration
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
                        // Allow internal JSP forwards and error pages
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()

                        // Public Endpoints
                        .requestMatchers(
                                "/",
                                "/error",
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

                        .anyRequest().authenticated()
                );
        // បញ្ចូល JwtAuthenticationFilter ចូលទៅក្នុង Spring Security Filter Chain
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}