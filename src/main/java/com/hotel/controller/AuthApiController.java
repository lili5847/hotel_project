package com.hotel.controller;

import com.hotel.dto.ApiResponse;
import com.hotel.dto.JwtAuthResponse;
import com.hotel.dto.LoginRequest;
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
@Tag(
        name = "Authentication APIs",
        description = "REST API សម្រាប់ Login និង Register"
)
public class AuthApiController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Autowired
    private AuthService authService;


    // ==========================================
    // REGISTER
    // POST /api/auth/register
    // ==========================================
    @PostMapping("/register")
    @Operation(
            summary = "Register User",
            description = "បង្កើតគណនី User ថ្មី"
    )
    public ResponseEntity<ApiResponse<String>> register(
            @Valid @RequestBody RegisterRequest registerRequest) {

        String message =
                authService.registerUser(registerRequest);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(
                        ApiResponse.success(
                                message,
                                null
                        )
                );
    }


    // ==========================================
    // LOGIN
    // POST /api/auth/login
    // ==========================================
    @PostMapping("/login")
    @Operation(
            summary = "Login User",
            description = "Login ដើម្បីទទួលបាន JWT Bearer Token"
    )
    public ResponseEntity<ApiResponse<JwtAuthResponse>> login(
            @Valid @RequestBody LoginRequest loginRequest) {

        Authentication authentication =
                authenticationManager.authenticate(
                        new UsernamePasswordAuthenticationToken(
                                loginRequest.getUsernameOrEmail(),
                                loginRequest.getPassword()
                        )
                );

        SecurityContextHolder
                .getContext()
                .setAuthentication(authentication);

        String token =
                tokenProvider.generateToken(authentication);

        JwtAuthResponse response =
                new JwtAuthResponse(token);

        return ResponseEntity.ok(
                ApiResponse.success(
                        "ចូលប្រើប្រាស់ជោគជ័យ",
                        response
                )
        );
    }
}
