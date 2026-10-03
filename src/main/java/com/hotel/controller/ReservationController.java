package com.hotel.controller;

import com.hotel.dto.ReservationRequest;
import com.hotel.model.Customer;
import com.hotel.model.Reservation;
import com.hotel.model.Room;
import com.hotel.model.User;
import com.hotel.repository.CustomerRepository;
import com.hotel.repository.RoomRepository;
import com.hotel.service.ReservationService;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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

    Room room =
            roomRepository
                    .findById(roomId)
                    .orElse(null);

    if (room == null) {
        return "redirect:/rooms";
    }

    model.addAttribute("room", room);

    return "Customer/booking";
}


@PostMapping("/book")
public String processBooking(
        @RequestParam("roomId") Integer roomId,

        @RequestParam("checkIn")
        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
        LocalDate checkIn,

        @RequestParam("checkOut")
        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
        LocalDate checkOut,

        @RequestParam(
                value = "guests",
                required = false,
                defaultValue = "1"
        )
        Integer guests,

        HttpSession session,
        Model model) {

    User loggedInUser =
            (User) session.getAttribute("user");

    if (loggedInUser == null) {
        return "redirect:/login";
    }

    Integer userId =
            Math.toIntExact(
                    loggedInUser.getUserId()
            );

    Optional<Customer> customerOpt =
            customerRepository
                    .findByUserUserId(userId);

    if (customerOpt.isEmpty()) {

        model.addAttribute(
                "error",
                "មិនទាន់មានព័ត៌មាន Profile អតិថិជនឡើយ!"
        );

        model.addAttribute(
                "room",
                roomRepository
                        .findById(roomId)
                        .orElse(null)
        );

        return "Customer/booking";
    }

    ReservationRequest request =
            new ReservationRequest();

    request.setUserId(userId);
    request.setRoomId(roomId);
    request.setCheckInDate(checkIn);
    request.setCheckOutDate(checkOut);
    request.setGuests(guests);

    try {

        reservationService
                .createReservation(request);

        return "redirect:/reservations/my-bookings";

    } catch (IllegalArgumentException e) {

        model.addAttribute(
                "error",
                e.getMessage()
        );

        model.addAttribute(
                "room",
                roomRepository
                        .findById(roomId)
                        .orElse(null)
        );

        return "Customer/booking";
    }
}


@GetMapping("/my-bookings")
public String myBookings(
        HttpSession session,
        Model model) {

    User loggedInUser =
            (User) session.getAttribute("user");

    if (loggedInUser == null) {
        return "redirect:/login";
    }

    Integer userId =
            Math.toIntExact(
                    loggedInUser.getUserId()
            );

    Optional<Customer> customerOpt =
            customerRepository
                    .findByUserUserId(userId);

    if (customerOpt.isPresent()) {

        List<Reservation> reservations =
                reservationService
                        .getReservationsByCustomer(
                                customerOpt
                                        .get()
                                        .getCustId()
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

    return "Customer/my-bookings";
}


/**
 * Cancel reservation securely.
 *
 * The booking must belong to the
 * currently logged-in customer.
 */
@PostMapping("/cancel")
public String cancelBooking(
        @RequestParam("bookingId") Integer bookingId,
        HttpSession session,
        Model model) {

    User loggedInUser =
            (User) session.getAttribute("user");

    if (loggedInUser == null) {
        return "redirect:/login";
    }

    Integer userId =
            Math.toIntExact(
                    loggedInUser.getUserId()
            );

    Optional<Customer> customerOpt =
            customerRepository
                    .findByUserUserId(userId);

    if (customerOpt.isEmpty()) {

        return "redirect:/reservations/my-bookings";
    }

    Integer customerId =
            customerOpt
                    .get()
                    .getCustId();

    try {

    	reservationService.cancelReservationByUserId(bookingId, userId);

    } catch (IllegalArgumentException e) {

        model.addAttribute(
                "error",
                e.getMessage()
        );

        List<Reservation> reservations =
                reservationService
                        .getReservationsByCustomer(
                                customerId
                        );

        model.addAttribute(
                "reservations",
                reservations
        );

        return "Customer/my-bookings";
    }

    return "redirect:/reservations/my-bookings";
}


}
