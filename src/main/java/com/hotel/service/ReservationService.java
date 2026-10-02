package com.hotel.service;

import com.hotel.dto.ReservationRequest;
import com.hotel.model.Customer;
import com.hotel.model.Reservation;
import com.hotel.model.Room;
import com.hotel.repository.CustomerRepository;
import com.hotel.repository.ReservationRepository;
import com.hotel.repository.RoomRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
public class ReservationService {

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private CustomerRepository customerRepository;


    // =====================================================
    // 1. CREATE RESERVATION
    // POST /api/reservations
    // =====================================================

    @Transactional
    public Reservation createReservation(ReservationRequest request) {

        // -------------------------------------------------
        // Validate request
        // -------------------------------------------------

        if (request == null) {
            throw new IllegalArgumentException(
                    "Reservation request មិនអាចទទេបានទេ!"
            );
        }

        Integer userId = request.getUserId();
        Integer roomId = request.getRoomId();

        LocalDate checkIn = request.getCheckInDate();
        LocalDate checkOut = request.getCheckOutDate();


        // -------------------------------------------------
        // Validate IDs
        // -------------------------------------------------

        if (userId == null) {
            throw new IllegalArgumentException(
                    "User ID ត្រូវតែមាន!"
            );
        }

        if (roomId == null) {
            throw new IllegalArgumentException(
                    "Room ID ត្រូវតែមាន!"
            );
        }


        // -------------------------------------------------
        // Validate dates
        // -------------------------------------------------

        if (checkIn == null || checkOut == null) {
            throw new IllegalArgumentException(
                    "Check-in និង Check-out ត្រូវតែមាន!"
            );
        }

        if (!checkOut.isAfter(checkIn)) {
            throw new IllegalArgumentException(
                    "Check-out ត្រូវតែធំជាង Check-in!"
            );
        }


        // -------------------------------------------------
        // Find Customer by User ID
        // -------------------------------------------------

        Customer customer = customerRepository
                .findByUserUserId(userId)
                .orElseThrow(() ->
                        new IllegalArgumentException(
                                "រកមិនឃើញ Customer សម្រាប់ User ID: "
                                        + userId
                        )
                );


        // -------------------------------------------------
        // Find Room
        // -------------------------------------------------

        Room room = roomRepository
                .findById(roomId)
                .orElseThrow(() ->
                        new IllegalArgumentException(
                                "រកមិនឃើញបន្ទប់ ID: "
                                        + roomId
                        )
                );


        // -------------------------------------------------
        // Check Room Type
        // -------------------------------------------------

        if (room.getRoomType() == null) {
            throw new IllegalArgumentException(
                    "បន្ទប់នេះមិនទាន់មាន Room Type!"
            );
        }

        if (room.getRoomType().getPrice() == null) {
            throw new IllegalArgumentException(
                    "Room Type នេះមិនទាន់មានតម្លៃ!"
            );
        }


        // -------------------------------------------------
        // Check Room Status
        // -------------------------------------------------

        if (room.getStatus() != null
                && room.getStatus().equalsIgnoreCase("BOOKED")) {

            throw new IllegalArgumentException(
                    "បន្ទប់នេះកំពុងត្រូវបានកក់!"
            );
        }


        // -------------------------------------------------
        // Check Date Overlap
        // -------------------------------------------------

        boolean booked =
                reservationRepository.isRoomBookedOverlap(
                        roomId,
                        checkIn,
                        checkOut
                );

        if (booked) {
            throw new IllegalArgumentException(
                    "បន្ទប់នេះត្រូវបានកក់រួចហើយសម្រាប់កាលបរិច្ឆេទនេះ!"
            );
        }


        // -------------------------------------------------
        // Calculate Nights
        // -------------------------------------------------

        long nights = ChronoUnit.DAYS.between(
                checkIn,
                checkOut
        );

        if (nights <= 0) {
            throw new IllegalArgumentException(
                    "ចំនួនថ្ងៃស្នាក់នៅមិនត្រឹមត្រូវ!"
            );
        }


        // -------------------------------------------------
        // Calculate Total Amount
        // -------------------------------------------------

        Double pricePerNight =
                room.getRoomType().getPrice();

        Double totalAmount =
                nights * pricePerNight;


        // -------------------------------------------------
        // Create Reservation
        // -------------------------------------------------

        Reservation reservation =
                new Reservation();

        reservation.setCustomer(customer);
        reservation.setRoom(room);
        reservation.setCheckIn(checkIn);
        reservation.setCheckOut(checkOut);
        reservation.setTotalAmount(totalAmount);

        // ReservationRequest មិនមាន guests
        // ដូច្នេះមិន set guests នៅទីនេះទេ

        reservation.setStatus("PENDING");


        // -------------------------------------------------
        // Update Room Status
        // -------------------------------------------------

        room.setStatus("BOOKED");

        roomRepository.save(room);


        // -------------------------------------------------
        // Save Reservation
        // -------------------------------------------------

        return reservationRepository.save(
                reservation
        );
    }


    // =====================================================
    // 2. GET ALL RESERVATIONS
    // GET /api/reservations
    // =====================================================

    public List<Reservation> getAllReservations() {

        return reservationRepository.findAll();
    }


    // =====================================================
    // 3. GET RESERVATIONS BY CUSTOMER
    // =====================================================

    public List<Reservation> getReservationsByCustomer(
            Integer customerId) {

        return reservationRepository
                .findByCustomerCustId(customerId);
    }


    // =====================================================
    // 4. GET RESERVATIONS BY USER ID
    // GET /api/reservations/user/{userId}
    // =====================================================

    public List<Reservation> getReservationsByUserId(
            Long userId) {

        if (userId == null) {
            throw new IllegalArgumentException(
                    "User ID មិនអាចទទេបានទេ!"
            );
        }

        Customer customer = customerRepository
                .findByUserUserId(userId.intValue())
                .orElseThrow(() ->
                        new IllegalArgumentException(
                                "រកមិនឃើញ Customer សម្រាប់ User ID: "
                                        + userId
                        )
                );

        return reservationRepository
                .findByCustomerCustId(
                        customer.getCustId()
                );
    }


    // =====================================================
    // 5. CANCEL RESERVATION
    // DELETE /api/reservations/{id}
    // =====================================================

    @Transactional
    public void cancelReservation(
            Integer bookingId) {

        // -------------------------------------------------
        // Find Reservation
        // -------------------------------------------------

        Reservation reservation =
                reservationRepository
                        .findById(bookingId)
                        .orElseThrow(() ->
                                new IllegalArgumentException(
                                        "រកមិនឃើញការកក់ ID: "
                                                + bookingId
                                )
                        );


        // -------------------------------------------------
        // Change Reservation Status
        // -------------------------------------------------

        reservation.setStatus("CANCELLED");


        // -------------------------------------------------
        // Make Room Available Again
        // -------------------------------------------------

        Room room =
                reservation.getRoom();

        if (room != null) {

            room.setStatus("AVAILABLE");

            roomRepository.save(room);
        }


        // -------------------------------------------------
        // Save Reservation
        // -------------------------------------------------

        reservationRepository.save(
                reservation
        );
    }
}