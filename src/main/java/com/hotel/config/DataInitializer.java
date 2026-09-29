package com.hotel.config;

import com.hotel.model.Role;
import com.hotel.model.User;
import com.hotel.repository.RoleRepository;
import com.hotel.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // 1. បង្កើត Default Roles ប្រសិនបើមិនទាន់មាន
        Role roleUser = createRoleIfNotFound("ROLE_USER");
        Role roleAdmin = createRoleIfNotFound("ROLE_ADMIN");

        // 2. បង្កើត Default Admin User ប្រសិនបើមិនទាន់មាន
        if (!userRepository.existsByUsername("admin")) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setEmail("admin@hotel.com");
            admin.setPassword(passwordEncoder.encode("Admin@123456")); // Password ដើមសម្រាប់ Admin
            admin.setEnabled(true);

            Set<Role> roles = new HashSet<>();
            roles.add(roleUser);
            roles.add(roleAdmin);
            admin.setRoles(roles);

            userRepository.save(admin);
            System.out.println(">>> [DataInitializer] Admin User ត្រូវបានបង្កើតដោយជោគជ័យ (Username: admin / Password: Admin@123456)");
        }
    }

    private Role createRoleIfNotFound(String name) {
        return roleRepository.findByName(name)
                .orElseGet(() -> {
                    Role role = roleRepository.save(new Role(name));
                    System.out.println(">>> [DataInitializer] Role ត្រូវបានបង្កើត៖ " + name);
                    return role;
                });
    }
}