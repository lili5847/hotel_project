package com.hotel.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AuthController {

    // ១. បង្ហាញ Form Login (GET Request)
    @GetMapping("/login")
    public String showLoginForm() {
        // Return ត្រឹមតែ View Name (គ្មាន .jsp extension)
        return "Customer/login";
    }

    // ២. បង្ហាញ Form Register (GET Request)
    @GetMapping("/register")
    public String showRegisterForm() {
        return "Customer/register";
    }

    /*
     * ចំណាំសំខាន់៖
     * - មិនចាំបាច់សរសេរ @PostMapping("/login") ទេ ព្រោះ Spring Security ជាអ្នកទទួល Form POST និង Authenticate ស្វ័យប្រវត្តិ។
     * - មិនចាំបាច់សរសេរ @GetMapping("/logout") ទេ ព្រោះ Spring Security ជាអ្នក Clear Session និង Logout ស្វ័យប្រវត្តិ។
     */
}