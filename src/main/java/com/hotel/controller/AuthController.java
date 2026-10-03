package com.hotel.controller;

import com.hotel.model.User;

import jakarta.servlet.http.HttpSession;

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

@GetMapping("/after-login")
public String afterLogin(HttpSession session) {

    User loggedInUser =
            (User) session.getAttribute("user");

    if (loggedInUser == null) {
        return "redirect:/login";
    }

    if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole())
            || "ROLE_ADMIN".equalsIgnoreCase(
                    loggedInUser.getRole())) {

        return "redirect:/admin";
    }

    if (loggedInUser.getRoles() != null) {

        boolean isAdmin =
                loggedInUser.getRoles()
                        .stream()
                        .anyMatch(role ->
                                "ROLE_ADMIN".equalsIgnoreCase(
                                        role.getName()
                                )
                                || "ADMIN".equalsIgnoreCase(
                                        role.getName()
                                )
                        );

        if (isAdmin) {
            return "redirect:/admin";
        }
    }

    return "redirect:/rooms";
}


}
