package com.hotel;

import java.time.LocalDateTime;

public class User {

    private int userId;
    private String fullName;      // maps to USERS.name
    private String email;
    private String passwordHash;  // maps to USERS.password (BCrypt hash, never the plain text)
    private String phone;
    private String role;          // "CUSTOMER" or "ADMIN"
    private String status;        // "ACTIVE" or "SUSPENDED"
    private LocalDateTime createdAt;

    public User() { }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    // Named getFullName()/setFullName() on purpose, even though the DB
    // column is "name" — this matches what the JSPs already expect
    // (e.g. sessionScope.user.fullName in navbar.jsp / admin-sidebar.jsp).
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public boolean isAdmin() { return "ADMIN".equalsIgnoreCase(role); }
    public boolean isActive() { return "ACTIVE".equalsIgnoreCase(status); }
}