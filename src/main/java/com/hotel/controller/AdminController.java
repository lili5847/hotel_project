package com.hotel.controller;

import com.hotel.model.Reservation;
import com.hotel.repository.ReservationRepository;
import com.hotel.repository.RoomRepository;
import com.hotel.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private ReservationService reservationService;

    // ១. បង្ហាញ Admin Dashboard ជាមួយ Statistic សង្ខេប
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        long totalRooms = roomRepository.count();
        long totalBookings = reservationRepository.count();
        List<Reservation> recentReservations = reservationRepository.findAll();

        model.addAttribute("totalRooms", totalRooms);
        model.addAttribute("totalBookings", totalBookings);
        model.addAttribute("reservations", recentReservations);

        return "admin/dashboard.jsp";
    }

    // ២. បង្ហាញបញ្ជីកក់បន្ទប់ទាំងអស់ (Manage Reservations)
    @GetMapping("/reservations")
    public String listAllReservations(Model model) {
        List<Reservation> reservations = reservationRepository.findAll();
        model.addAttribute("reservations", reservations);
        return "admin/reservations.jsp";
    }

    // ៣. ប្តូរស្ថានភាពការកក់ (ឧ. ពី PENDING ទៅ CONFIRMED)
    @PostMapping("/reservations/update-status")
    public String updateReservationStatus(
            @RequestParam("bookingId") Integer bookingId,
            @RequestParam("status") String status) {

        Reservation reservation = reservationRepository.findById(bookingId).orElse(null);
        if (reservation != null) {
            reservation.setStatus(status);
            reservationRepository.save(reservation);
        }

        return "redirect:/admin/reservations";
    }
}