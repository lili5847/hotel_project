package com.hotel.controller;

import com.hotel.dto.ReservationRequest;
import com.hotel.model.Customer;
import com.hotel.model.Reservation;
import com.hotel.model.User;
import com.hotel.repository.CustomerRepository;
import com.hotel.repository.RoomRepository;
import com.hotel.service.ReservationService;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/reservations")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private RoomRepository roomRepository;


    // =====================================================
    // 1. SHOW BOOKING FORM
    // GET /reservations/book?roomId=1
    // =====================================================

    @GetMapping("/book")
    public String showBookingForm(
            @RequestParam("roomId") Integer roomId,
            Model model,
            HttpSession session) {

        User loggedInUser =
                (User) session.getAttribute("user");

        if (loggedInUser == null) {
            return "redirect:/login";
        }

        model.addAttribute(
                "room",
                roomRepository.findById(roomId).orElse(null)
        );

        return "Customer/booking.jsp";
    }


    // =====================================================
    // 2. PROCESS BOOKING
    // POST /reservations/book
    // =====================================================

    @PostMapping("/book")
    public String processBooking(
            @RequestParam("roomId") Integer roomId,

            @RequestParam("checkIn")
            @DateTimeFormat(
                    iso = DateTimeFormat.ISO.DATE
            )
            LocalDate checkIn,

            @RequestParam("checkOut")
            @DateTimeFormat(
                    iso = DateTimeFormat.ISO.DATE
            )
            LocalDate checkOut,

            @RequestParam(
                    value = "guests",
                    required = false,
                    defaultValue = "1"
            )
            Integer guests,

            HttpSession session,
            Model model) {

        // -------------------------------------------------
        // Check Login
        // -------------------------------------------------

        User loggedInUser =
                (User) session.getAttribute("user");

        if (loggedInUser == null) {
            return "redirect:/login";
        }


        // -------------------------------------------------
        // Find Customer
        // -------------------------------------------------

        Optional<Customer> customerOpt =
                customerRepository.findByUserUserId(
                        Math.toIntExact(
                                loggedInUser.getUserId()
                        )
                );

        if (customerOpt.isEmpty()) {

            model.addAttribute(
                    "error",
                    "មិនទាន់មានព័ត៌មាន Profile អតិថិជនឡើយ!"
            );

            model.addAttribute(
                    "room",
                    roomRepository.findById(roomId).orElse(null)
            );

            return "Customer/booking.jsp";
        }


        // -------------------------------------------------
        // Create Reservation Request
        // -------------------------------------------------

        ReservationRequest request =
                new ReservationRequest();

        request.setUserId(
                Math.toIntExact(
                        loggedInUser.getUserId()
                )
        );

        request.setRoomId(roomId);

        request.setCheckInDate(checkIn);

        request.setCheckOutDate(checkOut);


        // -------------------------------------------------
        // Create Reservation
        // -------------------------------------------------

        try {

            reservationService.createReservation(
                    request
            );

            return "redirect:/reservations/my-bookings";

        } catch (IllegalArgumentException e) {

            model.addAttribute(
                    "error",
                    e.getMessage()
            );

            model.addAttribute(
                    "room",
                    roomRepository.findById(roomId).orElse(null)
            );

            return "Customer/booking.jsp";
        }
    }


    // =====================================================
    // 3. MY BOOKINGS
    // GET /reservations/my-bookings
    // =====================================================

    @GetMapping("/my-bookings")
    public String myBookings(
            HttpSession session,
            Model model) {

        User loggedInUser =
                (User) session.getAttribute("user");

        if (loggedInUser == null) {
            return "redirect:/login";
        }


        // -------------------------------------------------
        // Find Customer
        // -------------------------------------------------

        Optional<Customer> customerOpt =
                customerRepository.findByUserUserId(
                        Math.toIntExact(
                                loggedInUser.getUserId()
                        )
                );


        if (customerOpt.isPresent()) {

            List<Reservation> reservations =
                    reservationService
                            .getReservationsByCustomer(
                                    customerOpt.get().getCustId()
                            );

            model.addAttribute(
                    "reservations",
                    reservations
            );

        } else {

            model.addAttribute(
                    "reservations",
                    List.of()
            );
        }


        return "Customer/my-bookings.jsp";
    }


    // =====================================================
    // 4. CANCEL BOOKING
    // POST /reservations/cancel
    // =====================================================

    @PostMapping("/cancel")
    public String cancelBooking(
            @RequestParam("bookingId") Integer bookingId) {

        reservationService.cancelReservation(
                bookingId
        );

        return "redirect:/reservations/my-bookings";
    }
}