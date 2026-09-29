package com.hotel.controller;

import com.hotel.dto.ApiResponse;
import com.hotel.dto.LoginRequest;
import com.hotel.dto.RegisterRequest;
import com.hotel.dto.UserResponse;
import com.hotel.model.User;
import com.hotel.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthRestController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // POST: /api/auth/register
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<UserResponse>> register(@RequestBody RegisterRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, "ឈ្មោះគណនី (Username) នេះមានគេប្រើរួចហើយ!"));
        }

        if (userRepository.existsByEmail(request.getEmail())) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, "អ៊ីមែល (Email) នេះមានគេប្រើរួចហើយ!"));
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setFullName(request.getFullName());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setRole("CUSTOMER"); // Default Role

        User savedUser = userRepository.save(user);

        // ប្រសិនបើ UserResponse ទទួល userId ជា Integer ប៉ុន្តែ Entity ប្រើ Long
        // ត្រូវប្រាកដថា UserResponse ប្រើ Long ឬប្រើ savedUser.getUserId().intValue()
        UserResponse response = new UserResponse(
                savedUser.getUserId(), // ប្រសិនបើ field ក្នុង User.java មានឈ្មោះថា id ត្រូវប្ដូរទៅជា savedUser.getId()
                savedUser.getUsername(),
                savedUser.getFullName(),
                savedUser.getEmail(),
                savedUser.getRole()
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success("ចុះឈ្មោះជោគជ័យ", response));
    }

    // POST: /api/auth/login
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<UserResponse>> login(@RequestBody LoginRequest request, HttpServletRequest httpRequest) {
        Optional<User> userOpt = userRepository.findByUsername(request.getUsername());

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (passwordEncoder.matches(request.getPassword(), user.getPassword())) {
                // រក្សាទុក Session សម្រាប់ Browser/Frontend client
                HttpSession session = httpRequest.getSession(true);
                session.setAttribute("currentUser", user);

                UserResponse response = new UserResponse(
                        user.getUserId(),
                        user.getUsername(),
                        user.getFullName(),
                        user.getEmail(),
                        user.getRole()
                );
                return ResponseEntity.ok(ApiResponse.success("ចូលប្រព័ន្ធជោគជ័យ", response));
            }
        }

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(ApiResponse.error(401, "ឈ្មោះគណនី ឬលេខសម្ងាត់មិនត្រឹមត្រូវឡើយ"));
    }

    // POST: /api/auth/logout
    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<Void>> logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return ResponseEntity.ok(ApiResponse.success("ចាកចេញពីប្រព័ន្ធជោគជ័យ", null));
    }
}