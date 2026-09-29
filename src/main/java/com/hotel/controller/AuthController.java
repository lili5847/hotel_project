package com.hotel.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AuthController {

    @GetMapping("/login")
    public String showLoginForm() {
        return "Customer/login";
    }

    @GetMapping("/register")
    public String showRegisterForm() {
        return "Customer/register";
    }
}