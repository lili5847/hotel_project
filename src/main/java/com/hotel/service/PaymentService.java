package com.hotel.service;

import com.hotel.dto.PaymentRequest;
import com.hotel.model.Payment;
import com.hotel.model.Reservation;
import com.hotel.repository.PaymentRepository;
import com.hotel.repository.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @Transactional
    public Payment processPayment(PaymentRequest request) {

        Reservation reservation = reservationRepository.findById(request.getReservationId())
                .orElseThrow(() -> new RuntimeException("រកមិនឃើញការកក់បន្ទប់ដែលមាន ID នេះឡើយ"));

        // ✅ កែសម្រួលមកប្រើ getTotalAmount() ជំនួស getTotalPrice()
        if (!request.getAmount().equals(reservation.getTotalAmount())) {
            throw new RuntimeException("ចំនួនទឹកប្រាក់ដែលបានបង់ ($" + request.getAmount() +
                    ") មិនត្រូវគ្នាជាមួយនឹងតម្លៃសរុបនៃការកក់ ($" + reservation.getTotalAmount() + ") ឡើយ");
        }

        Payment payment = new Payment();
        payment.setReservation(reservation);
        payment.setAmount(request.getAmount());
        payment.setPaymentMethod(request.getPaymentMethod());
        payment.setTransactionId(request.getTransactionId());
        payment.setPaymentDate(LocalDateTime.now());
        payment.setPaymentStatus("COMPLETED");

        reservation.setStatus("CONFIRMED");
        reservationRepository.save(reservation);

        return paymentRepository.save(payment);
    }

    public Payment getPaymentByReservationId(Integer reservationId) {
        // ✅ កែសម្រួលឱ្យត្រូវតាម Property bookingId របស់ Reservation
        return paymentRepository.findByReservationBookingId(reservationId)
                .orElseThrow(() -> new RuntimeException("រកមិនឃើញព័ត៌មានទូទាត់ប្រាក់សម្រាប់ការកក់នេះឡើយ"));
    }
}