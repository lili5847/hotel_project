package com.hotel.controller;

import com.hotel.dto.ApiResponse;
import com.hotel.dto.PaymentRequest;
import com.hotel.model.Payment;
import com.hotel.service.PaymentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payments")
@CrossOrigin(origins = "*")
@Tag(name = "Payment APIs", description = "គ្រប់គ្រងការទូទាត់ប្រាក់លើការកក់បន្ទប់")
public class PaymentRestController {

    @Autowired
    private PaymentService paymentService;

    // POST: /api/payments (ធ្វើការទូទាត់ប្រាក់)
    @PostMapping
    @Operation(summary = "ធ្វើការទូទាត់ប្រាក់", description = "ទទួលទិន្នន័យទូទាត់ប្រាក់ពី Frontend រួចអាប់ដេត Status នៃការកក់ទៅជា CONFIRMED")
    public ResponseEntity<ApiResponse<Payment>> processPayment(@Valid @RequestBody PaymentRequest request) {
        Payment payment = paymentService.processPayment(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("ការទូទាត់ប្រាក់ជោគជ័យ", payment));
    }

    // GET: /api/payments/reservation/{reservationId} (ទាញយកតាម Reservation ID)
    @GetMapping("/reservation/{reservationId}")
    @Operation(summary = "ទាញយកព័ត៌មានទូទាត់ប្រាក់តាម Reservation ID")
    public ResponseEntity<ApiResponse<Payment>> getPaymentByReservation(@PathVariable Integer reservationId) {
        Payment payment = paymentService.getPaymentByReservationId(reservationId);
        return ResponseEntity.ok(ApiResponse.success("ទាញយកព័ត៌មានទូទាត់ប្រាក់ជោគជ័យ", payment));
    }
}