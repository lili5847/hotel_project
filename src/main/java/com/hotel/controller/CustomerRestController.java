
package com.hotel.controller;

import com.hotel.dto.ApiResponse;
import com.hotel.model.User;
import com.hotel.repository.UserRepository;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/customers")
@CrossOrigin(origins = "*")
@Tag(
        name = "Customer Management APIs",
        description = "REST API សម្រាប់ Admin គ្រប់គ្រងអតិថិជន"
)
public class CustomerRestController {

    @Autowired
    private UserRepository userRepository;

    /**
     * Get all customers.
     */
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<List<User>>> getAllCustomers(
            @RequestParam(required = false) String q) {

        List<User> users = userRepository.findAll();

        // Remove ADMIN users
        users = users.stream()
                .filter(user -> {
                    if (user.getRole() != null) {
                        String role = user.getRole().trim();

                        if ("ADMIN".equalsIgnoreCase(role)
                                || "ROLE_ADMIN".equalsIgnoreCase(role)) {
                            return false;
                        }
                    }

                    if (user.getRoles() != null) {
                        boolean isAdmin = user.getRoles()
                                .stream()
                                .anyMatch(role ->
                                        "ADMIN".equalsIgnoreCase(role.getName())
                                                || "ROLE_ADMIN".equalsIgnoreCase(role.getName()));

                        if (isAdmin) {
                            return false;
                        }
                    }

                    return true;
                })
                .toList();

        // Search
        if (q != null && !q.trim().isEmpty()) {

            String keyword = q.trim().toLowerCase();

            users = users.stream()
                    .filter(user ->
                            (user.getFullName() != null
                                    && user.getFullName()
                                    .toLowerCase()
                                    .contains(keyword))

                            || (user.getEmail() != null
                                    && user.getEmail()
                                    .toLowerCase()
                                    .contains(keyword))

                            || (user.getUsername() != null
                                    && user.getUsername()
                                    .toLowerCase()
                                    .contains(keyword))
                    )
                    .toList();
        }

        return ResponseEntity.ok(
                ApiResponse.success(
                        "ទាញយកបញ្ជីអតិថិជនជោគជ័យ",
                        users
                )
        );
    }


    /**
     * Suspend customer.
     */
    @PostMapping("/{id}/suspend")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(
            summary = "ផ្អាកគណនីអតិថិជន",
            description = "ប្តូរ status របស់អតិថិជនទៅ SUSPENDED"
    )
    public ResponseEntity<ApiResponse<String>> suspendCustomer(
            @PathVariable Long id) {

        User user = userRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "រកមិនឃើញ User ដែលមាន ID: " + id
                        )
                );

        user.setStatus("SUSPENDED");
        user.setEnabled(false);

        userRepository.save(user);

        return ResponseEntity.ok(
                ApiResponse.success(
                        "ផ្អាកគណនីអតិថិជនជោគជ័យ",
                        null
                )
        );
    }

    /**
     * Activate customer.
     */
    @PostMapping("/{id}/activate")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(
            summary = "បើកដំណើរការគណនីអតិថិជន",
            description = "ប្តូរ status របស់អតិថិជនទៅ ACTIVE"
    )
    public ResponseEntity<ApiResponse<String>> activateCustomer(
            @PathVariable Long id) {

        User user = userRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "រកមិនឃើញ User ដែលមាន ID: " + id
                        )
                );

        user.setStatus("ACTIVE");
        user.setEnabled(true);

        userRepository.save(user);

        return ResponseEntity.ok(
                ApiResponse.success(
                        "បើកដំណើរការគណនីអតិថិជនជោគជ័យ",
                        null
                )
        );
    }
}

