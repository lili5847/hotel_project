package com.hotel.controller;

import com.hotel.dto.ApiResponse;
import com.hotel.dto.ReservationRequest;
import com.hotel.model.Reservation;
import com.hotel.service.ReservationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reservations")
@CrossOrigin(origins = "*")
@Tag(
        name = "Reservation APIs",
        description = "គ្រប់គ្រងការកក់បន្ទប់ និងប្រវត្តិការកក់"
)
public class ReservationRestController {

    @Autowired
    private ReservationService reservationService;

    // =====================================================
    // 1. CREATE RESERVATION
    // POST /api/reservations
    // =====================================================
    @PostMapping
    @PreAuthorize("hasAnyRole('CUSTOMER', 'USER', 'ADMIN')")
    @Operation(
            summary = "បង្កើតការកក់បន្ទប់ថ្មី",
            description = "បង្កើត Reservation ថ្មី និងត្រួតពិនិត្យបន្ទប់ទំនេរ"
    )
    public ResponseEntity<ApiResponse<Reservation>> createReservation(
            @Valid @RequestBody ReservationRequest request) {

        Reservation reservation =
                reservationService.createReservation(request);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(
                        ApiResponse.success(
                                "បង្កើតការកក់បន្ទប់ជោគជ័យ",
                                reservation
                        )
                );
    }

    // =====================================================
    // 2. GET ALL RESERVATIONS
    // GET /api/reservations
    // ADMIN ONLY
    // =====================================================
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(
            summary = "ទាញយកបញ្ជីការកក់ទាំងអស់",
            description = "Admin អាចមើល Reservation ទាំងអស់ក្នុងប្រព័ន្ធ"
    )
    public ResponseEntity<ApiResponse<List<Reservation>>> getAllReservations() {

        List<Reservation> reservations =
                reservationService.getAllReservations();

        return ResponseEntity.ok(
                ApiResponse.success(
                        "ទាញយកទិន្នន័យការកក់ជោគជ័យ",
                        reservations
                )
        );
    }

    // =====================================================
    // 3. GET RESERVATIONS BY USER
    // GET /api/reservations/user/{userId}
    // =====================================================
    @GetMapping("/user/{userId}")
    @PreAuthorize("hasAnyRole('CUSTOMER', 'USER', 'ADMIN')")
    @Operation(
            summary = "ទាញយកប្រវត្តិការកក់តាម User ID",
            description = "បង្ហាញប្រវត្តិការកក់របស់ Customer"
    )
    public ResponseEntity<ApiResponse<List<Reservation>>> getReservationsByUser(
            @PathVariable Long userId) {

        List<Reservation> reservations =
                reservationService.getReservationsByUserId(userId);

        return ResponseEntity.ok(
                ApiResponse.success(
                        "ទាញយកប្រវត្តិការកក់ជោគជ័យ",
                        reservations
                )
        );
    }

    // =====================================================
    // 4. CANCEL RESERVATION
    // DELETE /api/reservations/{id}
    // =====================================================
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('CUSTOMER', 'USER', 'ADMIN')")
    @Operation(
            summary = "បោះបង់ការកក់បន្ទប់",
            description = "ប្តូរ Reservation status ទៅ CANCELLED"
    )
    public ResponseEntity<ApiResponse<Void>> cancelReservation(
            @PathVariable Integer id) {

        reservationService.cancelReservation(id);

        return ResponseEntity.ok(
                ApiResponse.success(
                        "បោះបង់ការកក់បន្ទប់ជោគជ័យ",
                        null
                )
        );
    }
}