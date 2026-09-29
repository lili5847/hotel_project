package com.hotel.dto;

import jakarta.validation.constraints.NotBlank;

public class LoginRequest {

    @NotBlank(message = "សូមបញ្ចូល Username ឬ Email")
    private String usernameOrEmail;

    @NotBlank(message = "សូមបញ្ចូល ពាក្យសម្ងាត់ (Password)")
    private String password;

    public LoginRequest() {}

    public LoginRequest(String usernameOrEmail, String password) {
        this.usernameOrEmail = usernameOrEmail;
        this.password = password;
    }

    // --- Getters and Setters ---

    public String getUsernameOrEmail() {
        return usernameOrEmail;
    }

    public void setUsernameOrEmail(String usernameOrEmail) {
        this.usernameOrEmail = usernameOrEmail;
    }

    // Method ជំនួយសម្រាប់ Controller/Service ដែលហៅ getUsername()
    public String getUsername() {
        return usernameOrEmail;
    }

    public void setUsername(String username) {
        this.usernameOrEmail = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}