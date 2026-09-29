package com.hotel.repository;

import com.hotel.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Integer> {

    // ✅ កែមកប្រើ BookingId ឱ្យត្រូវតាម Reservation Entity
    Optional<Payment> findByReservationBookingId(Integer bookingId);

    List<Payment> findAllByReservationBookingId(Integer bookingId);
}