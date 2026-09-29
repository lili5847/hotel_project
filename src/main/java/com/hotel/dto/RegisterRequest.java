package com.hotel.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class RegisterRequest {

    @NotBlank(message = "សូមបញ្ចូល ឈ្មោះគណនី (Username)")
    @Size(min = 3, max = 30, message = "ឈ្មោះគណនីត្រូវមានប្រវែងពី ៣ ទៅ ៣០ តួអក្សរ")
    private String username;

    @NotBlank(message = "សូមបញ្ចូល អ៊ីមែល (Email)")
    @Email(message = "ទម្រង់អ៊ីមែលមិនត្រឹមត្រូវឡើយ")
    private String email;

    @NotBlank(message = "សូមបញ្ចូល ពាក្យសម្ងាត់ (Password)")
    @Size(min = 6, message = "ពាក្យសម្ងាត់ត្រូវមានយ៉ាងតិច ៦ តួអក្សរ")
    private String password;

    @NotBlank(message = "សូមបញ្ចូល ឈ្មោះពេញ (Full Name)")
    private String fullName;

    private String phone;

    public RegisterRequest() {}

    public RegisterRequest(String username, String email, String password, String fullName, String phone) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
    }

    // --- Getters and Setters ---

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}