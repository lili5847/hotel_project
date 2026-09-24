package com.hotel.controller;

import com.hotel.model.Room;
import com.hotel.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class RoomController {

    @Autowired
    private RoomRepository roomRepository;

    // ១. បង្ហាញបញ្ជីបន្ទប់ទាំងអស់ ឬស្វែងរកតាមស្ថានភាពបន្ទប់
    @GetMapping({"/", "/rooms"})
    public String getAllRooms(@RequestParam(value = "status", required = false) String status, Model model) {
        List<Room> rooms;
        if (status != null && !status.isEmpty()) {
            rooms = roomRepository.findByStatus(status);
        } else {
            rooms = roomRepository.findAll();
        }
        model.addAttribute("rooms", rooms);
        return "Customer/room-search.jsp";
    }

    // ២. មើលព័ត៌មានលម្អិតនៃបន្ទប់ (Room Detail)
    @GetMapping("/room-detail")
    public String getRoomDetail(@RequestParam("id") Integer id, Model model) {
        Room room = roomRepository.findById(id).orElse(null);
        model.addAttribute("room", room);
        return "Customer/room-details.jsp";
    }
}