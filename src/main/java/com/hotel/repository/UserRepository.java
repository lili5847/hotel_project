package com.hotel.repository;

import com.hotel.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // ស្វែងរកតាម Email (ប្រើសម្រាប់ Spring Security / Form Login)
    Optional<User> findByEmail(String email);

    // ស្វែងរកតាម Username
    Optional<User> findByUsername(String username);

    // ស្វែងរកតាម Username ឬ Email (ប្រើសម្រាប់ Auth API ដែលអនុញ្ញាតឱ្យបញ្ចូលមួយណាក៏បាន)
    Optional<User> findByUsernameOrEmail(String username, String email);

    // ពិនិត្យមើលថាតើមាន Username នេះក្នុង DB រួចហើយឬនៅ
    Boolean existsByUsername(String username);

    // ពិនិត្យមើលថាតើមាន Email នេះក្នុង DB រួចហើយឬនៅ
    Boolean existsByEmail(String email);
}