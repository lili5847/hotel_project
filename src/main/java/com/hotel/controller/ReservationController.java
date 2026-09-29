package com.hotel.controller;

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

    // ១. បង្ហាញ Form កក់បន្ទប់ (GET Request)
    @GetMapping("/book")
    public String showBookingForm(@RequestParam("roomId") Integer roomId, Model model, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login"; // តម្រូវឱ្យ Login ជាមុនសិន
        }

        model.addAttribute("room", roomRepository.findById(roomId).orElse(null));
        return "Customer/booking.jsp";
    }

    // ២. ទទួលទិន្នន័យកក់បន្ទប់ (POST Request)
    @PostMapping("/book")
    public String processBooking(
            @RequestParam("roomId") Integer roomId,
            @RequestParam("checkIn") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkIn,
            @RequestParam("checkOut") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkOut,
            @RequestParam("guests") Integer guests,
            HttpSession session,
            Model model) {

        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        // ស្វែងរក Customer ID ដែលត្រូវគ្នានឹង User
        Optional<Customer> customerOpt = customerRepository.findByUserUserId(Math.toIntExact(loggedInUser.getUserId()));
        if (customerOpt.isEmpty()) {
            model.addAttribute("error", "មិនទាន់មានព័ត៌មាន Profile អតិថិជនឡើយ!");
            return "Customer/booking.jsp";
        }

        try {
            Reservation reservation = reservationService.createReservation(
                    checkIn, checkOut, roomId, roomId, guests);
            return "redirect:/reservations/my-bookings";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "Customer/booking.jsp";
        }
    }

    // ៣. បង្ហាញបញ្ជីការកក់របស់អតិថិជនបច្ចុប្បន្ន
    @GetMapping("/my-bookings")
    public String myBookings(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return "redirect:/login";
        }

        Optional<Customer> customerOpt = customerRepository.findByUserUserId(Math.toIntExact(loggedInUser.getUserId()));
        if (customerOpt.isPresent()) {
            List<Reservation> reservations = reservationService.getReservationsByCustomer(customerOpt.get().getCustId());
            model.addAttribute("reservations", reservations);
        }

        return "Customer/my-bookings.jsp";
    }

    // ៤. បោះបង់ការកក់បន្ទប់ (Cancel Booking)
    @PostMapping("/cancel")
    public String cancelBooking(@RequestParam("bookingId") Integer bookingId) {
        reservationService.cancelReservation(bookingId);
        return "redirect:/reservations/my-bookings";
    }
}