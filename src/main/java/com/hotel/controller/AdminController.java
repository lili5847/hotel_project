
package com.hotel.controller;

import com.hotel.model.Reservation;
import com.hotel.model.User;
import com.hotel.repository.ReservationRepository;
import com.hotel.repository.RoomRepository;
import com.hotel.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("")
    public String dashboard(
            HttpSession session,
            Model model) {

        User loggedInUser =
                (User) session.getAttribute("user");

        if (loggedInUser == null) {
            return "redirect:/login";
        }

        if (!isAdmin(loggedInUser)) {
            return "redirect:/rooms";
        }

        List<Reservation> reservations =
                reservationRepository.findAll();

        long totalReservations = reservations.size();

        long pendingReservations =
                reservations.stream()
                        .filter(r ->
                                "PENDING".equalsIgnoreCase(r.getStatus()))
                        .count();

        long confirmedReservations =
                reservations.stream()
                        .filter(r ->
                                "CONFIRMED".equalsIgnoreCase(r.getStatus()))
                        .count();

        long cancelledReservations =
                reservations.stream()
                        .filter(r ->
                                "CANCELLED".equalsIgnoreCase(r.getStatus()))
                        .count();

        long totalRooms = roomRepository.count();
        long totalUsers = userRepository.count();

        model.addAttribute("totalReservations", totalReservations);
        model.addAttribute("pendingReservations", pendingReservations);
        model.addAttribute("confirmedReservations", confirmedReservations);
        model.addAttribute("cancelledReservations", cancelledReservations);
        model.addAttribute("totalRooms", totalRooms);
        model.addAttribute("totalUsers", totalUsers);

        return "admin/dashboard";
    }

    @GetMapping("/reservations")
    public String reservations(
            HttpSession session,
            Model model) {

        User loggedInUser =
                (User) session.getAttribute("user");

        if (loggedInUser == null) {
            return "redirect:/login";
        }

        if (!isAdmin(loggedInUser)) {
            return "redirect:/rooms";
        }

        List<Reservation> reservations =
                reservationRepository.findAll();

        model.addAttribute("reservations", reservations);

        return "admin/reservations";
    }

    @GetMapping("/rooms")
    public String rooms(HttpSession session) {

        User loggedInUser =
                (User) session.getAttribute("user");

        if (loggedInUser == null) {
            return "redirect:/login";
        }

        if (!isAdmin(loggedInUser)) {
            return "redirect:/rooms";
        }

        return "admin/rooms";
    }
    
    @GetMapping("/room-types")
    public String roomTypes(HttpSession session) {

        User u = (User) session.getAttribute("user");

        if (u == null) {
            return "redirect:/login";
        }

        if (!isAdmin(u)) {
            return "redirect:/rooms";
        }

        return "admin/room-types";
    }
    
    @GetMapping("/customers")
    public String customers(HttpSession session) {

        User u = (User) session.getAttribute("user");

        if (u == null) {
            return "redirect:/login";
        }

        if (!isAdmin(u)) {
            return "redirect:/rooms";
        }

        return "admin/customers";
    }

    private boolean isAdmin(User user) {

        if (user == null) {
            return false;
        }

        if ("ADMIN".equalsIgnoreCase(user.getRole())
                || "ROLE_ADMIN".equalsIgnoreCase(user.getRole())) {
            return true;
        }

        if (user.getRoles() != null) {
            return user.getRoles()
                    .stream()
                    .anyMatch(role ->
                            "ADMIN".equalsIgnoreCase(role.getName())
                                    || "ROLE_ADMIN".equalsIgnoreCase(role.getName()));
        }

        return false;
    }
}

