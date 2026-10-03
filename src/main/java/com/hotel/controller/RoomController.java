
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

    @GetMapping({"/", "/rooms"})
    public String getAllRooms(Model model) {

        List<Room> rooms = roomRepository.findAll();

        model.addAttribute("rooms", rooms);

        return "Customer/room-search";
    }
    
   
    @GetMapping("/room-detail")
    public String getRoomDetail(
            @RequestParam("id") Integer id,
            Model model) {

        Room room = roomRepository.findById(id).orElse(null);

        model.addAttribute("room", room);

        return "Customer/room-details";
    }
}

