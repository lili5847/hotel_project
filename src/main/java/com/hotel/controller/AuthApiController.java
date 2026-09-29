package com.hotel.controller;

import com.hotel.dto.ApiResponse;
import com.hotel.dto.LoginRequest;
import com.hotel.dto.JwtAuthResponse;
import com.hotel.dto.RegisterRequest;
import com.hotel.security.JwtTokenProvider;
import com.hotel.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
@Tag(name = "Authentication APIs", description = "សម្រាប់ Login និង Register ចុះឈ្មោះអ្នកប្រើប្រាស់")
public class AuthApiController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Autowired
    private AuthService authService;

    // POST: /api/auth/register (ចុះឈ្មោះ User ថ្មី)
    @PostMapping("/register")
    @Operation(summary = "ចុះឈ្មោះគណនីថ្មី (Register)", description = "បង្កើតគណនី User ថ្មីជាមួយនឹង Password Encrypted")
    public ResponseEntity<ApiResponse<String>> register(@Valid @RequestBody RegisterRequest registerRequest) {
        String message = authService.registerUser(registerRequest);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(message, null));
    }

    // POST: /api/auth/login (ចូលប្រើប្រាស់)
    @PostMapping("/login")
    @Operation(summary = "ចូលប្រើប្រាស់ប្រព័ន្ធ (Login)", description = "ផ្ញើ Username/Email និង Password ដើម្បីទទួលបាន Bearer Token")
    public ResponseEntity<ApiResponse<JwtAuthResponse>> login(@Valid @RequestBody LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginRequest.getUsernameOrEmail(),
                        loginRequest.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = tokenProvider.generateToken(authentication);

        return ResponseEntity.ok(ApiResponse.success("ចូលប្រើប្រាស់ជោគជ័យ", new JwtAuthResponse(token)));
    }
}