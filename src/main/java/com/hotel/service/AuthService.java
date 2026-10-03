
package com.hotel.service;

import com.hotel.dto.RegisterRequest;
import com.hotel.model.Customer;
import com.hotel.model.Role;
import com.hotel.model.User;
import com.hotel.repository.CustomerRepository;
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
    private CustomerRepository customerRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Transactional
    public String registerUser(RegisterRequest registerRequest) {

        // 1. Check username
        if (userRepository.existsByUsername(registerRequest.getUsername())) {

            throw new RuntimeException(
                    "Username នេះមានគេប្រើប្រាស់រួចហើយ!"
            );
        }

        // 2. Check email
        if (userRepository.existsByEmail(registerRequest.getEmail())) {

            throw new RuntimeException(
                    "Email នេះមានគេប្រើប្រាស់រួចហើយ!"
            );
        }

        // 3. Create User
        User user = new User();

        user.setUsername(registerRequest.getUsername());

        user.setEmail(registerRequest.getEmail());

        user.setFullName(registerRequest.getFullName());

        user.setPhone(registerRequest.getPhone());

        // Encode password with BCrypt
        user.setPassword(
                passwordEncoder.encode(
                        registerRequest.getPassword()
                )
        );

        user.setEnabled(true);

        user.setStatus("ACTIVE");

        // String role
        user.setRole("ROLE_CUSTOMER");


        // 4. Create / find default Role
        Role userRole =
                roleRepository
                        .findByName("ROLE_CUSTOMER")
                        .orElseGet(() ->
                                roleRepository
                                        .findByName("ROLE_USER")
                                        .orElseGet(() ->
                                                roleRepository.save(
                                                        new Role("ROLE_CUSTOMER")
                                                )
                                        )
                        );

        user.setRoles(
                new HashSet<>(
                        Collections.singletonList(userRole)
                )
        );


        // 5. Save User FIRST
        User savedUser =
                userRepository.save(user);


        // 6. Automatically create Customer profile
        Customer customer = new Customer();

        customer.setUser(savedUser);

        customer.setPhone(registerRequest.getPhone());

        customerRepository.save(customer);


        return "ចុះឈ្មោះគណនីថ្មីជោគជ័យ!";
    }
}
