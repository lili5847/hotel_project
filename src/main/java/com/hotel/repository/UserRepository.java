package com.hotel.repository;

import com.hotel.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    // ស្វែងរក User តាមរយៈ Email (ប្រើសម្រាប់ Login)
    Optional<User> findByEmail(String email);

    // ពិនិត្យមើលថាមាន Email នេះក្នុង DB ឬនៅ (ប្រើសម្រាប់ Register)
    boolean existsByEmail(String email);
}