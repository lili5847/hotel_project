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

        Reservation reservation =
                reservationRepository.findById(request.getReservationId())
                        .orElseThrow(() ->
                                new RuntimeException(
                                        "រកមិនឃើញការកក់បន្ទប់ដែលមាន ID នេះឡើយ"
                                )
                        );

        if ("CANCELLED".equalsIgnoreCase(reservation.getStatus())) {
            throw new RuntimeException(
                    "ការកក់បន្ទប់នេះត្រូវបានលុបចោលរួចហើយ"
            );
        }

        if ("CONFIRMED".equalsIgnoreCase(reservation.getStatus())) {
            throw new RuntimeException(
                    "ការកក់បន្ទប់នេះត្រូវបានបញ្ជាក់រួចហើយ"
            );
        }

        if (reservation.getTotalAmount() == null) {
            throw new RuntimeException(
                    "ការកក់នេះមិនមានតម្លៃសរុបឡើយ"
            );
        }

        if (request.getAmount() == null
                || Double.compare(
                        request.getAmount(),
                        reservation.getTotalAmount()
                ) != 0) {

            throw new RuntimeException(
                    "ចំនួនទឹកប្រាក់ដែលបានបង់ ($"
                    + request.getAmount()
                    + ") មិនត្រូវគ្នាជាមួយនឹងតម្លៃសរុបនៃការកក់ ($"
                    + reservation.getTotalAmount()
                    + ") ឡើយ"
            );
        }

        Payment payment = new Payment();

        payment.setReservation(reservation);
        payment.setAmount(request.getAmount());
        payment.setPaymentMethod(request.getPaymentMethod());
        payment.setTransactionId(request.getTransactionId());
        payment.setPaymentStatus("COMPLETED");
        payment.setPaidAt(LocalDateTime.now());

        reservation.setStatus("CONFIRMED");

        reservationRepository.save(reservation);

        return paymentRepository.save(payment);
    }

    public Payment getPaymentByReservationId(Integer reservationId) {

        return paymentRepository
                .findByReservationBookingId(reservationId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "រកមិនឃើញព័ត៌មានទូទាត់ប្រាក់សម្រាប់ការកក់នេះឡើយ"
                        )
                );
    }
}