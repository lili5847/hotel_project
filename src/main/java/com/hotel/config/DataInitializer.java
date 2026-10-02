package com.hotel.config;

import com.hotel.model.Role;
import com.hotel.model.User;
import com.hotel.repository.RoleRepository;
import com.hotel.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional; // 1. Import Transactional

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

    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_EMAIL = "admin@hotel.com";
    private static final String ADMIN_PASSWORD = "Admin@123456";

    @Override
    @Transactional // 2. បន្ថែម Annotation នេះដើម្បីរក្សា JPA Persistence Context តែមួយ
    public void run(String... args) throws Exception {

        Role roleUser = createRoleIfNotFound("ROLE_USER");
        Role roleAdmin = createRoleIfNotFound("ROLE_ADMIN");

        // Find existing admin by username OR email
        User admin = userRepository
                .findByUsernameOrEmail(
                        ADMIN_USERNAME,
                        ADMIN_EMAIL
                )
                .orElse(null);

        if (admin == null) {
            admin = new User();
            admin.setUsername(ADMIN_USERNAME);
            admin.setFullName("System Administrator");
            admin.setEmail(ADMIN_EMAIL);

            System.out.println(">>> [DataInitializer] Admin not found.");
            System.out.println(">>> [DataInitializer] Creating new admin...");
        } else {
            System.out.println(">>> [DataInitializer] Existing admin found.");
            System.out.println(">>> [DataInitializer] Updating admin...");
        }

        // Update admin information
        admin.setUsername(ADMIN_USERNAME);
        admin.setEmail(ADMIN_EMAIL);
        admin.setPassword(passwordEncoder.encode(ADMIN_PASSWORD));
        admin.setRole("ADMIN");
        admin.setStatus("ACTIVE");
        admin.setEnabled(true);

        // 3. កែសម្រួលការ Assign roles ដើម្បីកុំឲ្យជាន់ Object Reference
        Set<Role> roles = admin.getRoles();
        if (roles == null) {
            roles = new HashSet<>();
            admin.setRoles(roles);
        } else {
            // ប្រសិនបើ admin មានស្រាប់ ត្រូវ clear roles ចាស់ចោលមុន
            roles.clear();
        }

        roles.add(roleUser);
        roles.add(roleAdmin);

        userRepository.save(admin);

        System.out.println("=================================================");
        System.out.println(">>> [DataInitializer] ADMIN READY");
        System.out.println(">>> Username : " + ADMIN_USERNAME);
        System.out.println(">>> Email    : " + ADMIN_EMAIL);
        System.out.println(">>> Password : " + ADMIN_PASSWORD);
        System.out.println(">>> Role     : ADMIN");
        System.out.println(">>> Status   : ACTIVE");
        System.out.println(">>> Enabled  : true");
        System.out.println(">>> Password reset automatically.");
        System.out.println("=================================================");
    }

    private Role createRoleIfNotFound(String name) {

        return roleRepository
                .findByName(name)
                .orElseGet(() -> {

                    Role role = new Role();
                    role.setName(name);

                    Role savedRole = roleRepository.save(role);

                    System.out.println(
                            ">>> [DataInitializer] Role created: " + name
                    );

                    return savedRole;
                });
    }
}