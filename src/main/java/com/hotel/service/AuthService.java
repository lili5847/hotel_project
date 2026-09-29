package com.hotel.service;

import com.hotel.dto.RegisterRequest;
import com.hotel.model.Role;
import com.hotel.model.User;
import com.hotel.repository.RoleRepository;
import com.hotel.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.HashSet;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Transactional
    public String registerUser(RegisterRequest registerRequest) {
        // 1. ពិនិត្យមើលថា Username មានរួចហើយឬនៅ
        if (userRepository.existsByUsername(registerRequest.getUsername())) {
            throw new RuntimeException("Username នេះមានគេប្រើប្រាស់រួចហើយ!");
        }

        // 2. ពិនិត្យមើលថា Email មានរួចហើយឬនៅ
        if (userRepository.existsByEmail(registerRequest.getEmail())) {
            throw new RuntimeException("Email នេះមានគេប្រើប្រាស់រួចហើយ!");
        }

        // 3. បង្កើត User ថ្មី និង Set ទិន្នន័យទាំងអស់
        User user = new User();
        user.setUsername(registerRequest.getUsername());
        user.setEmail(registerRequest.getEmail());
        user.setFullName(registerRequest.getFullName());
        user.setPhone(registerRequest.getPhone());

        // Encode Password មុនរក្សាទុកចូលក្នុង Database
        user.setPassword(passwordEncoder.encode(registerRequest.getPassword()));
        user.setEnabled(true);
        user.setStatus("ACTIVE");

        // 4. កំណត់ Default Role
        user.setRole("ROLE_CUSTOMER"); // កំណត់ String Role សម្រាប់ SecurityConfig

        // កំណត់ Role Entity (ករណីប្រើ ManyToMany Table)
        Role userRole = roleRepository.findByName("ROLE_CUSTOMER")
                .orElseGet(() -> roleRepository.findByName("ROLE_USER")
                        .orElseGet(() -> roleRepository.save(new Role("ROLE_CUSTOMER"))));

        user.setRoles(new HashSet<>(Collections.singletonList(userRole)));

        // 5. រក្សាទុកចូលក្នុង Database
        userRepository.save(user);

        return "ចុះឈ្មោះគណនីថ្មីជោគជ័យ!";
    }
}