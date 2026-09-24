package com.hotel.controller;

import com.hotel.model.Room;
import com.hotel.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rooms")
public class RoomRestController {

    @Autowired
    private RoomRepository roomRepository;

    // ១. ទាញយកបញ្ជីបន្ទប់ទាំងអស់ជា JSON Format
    @GetMapping
    public ResponseEntity<List<Room>> getAllRooms() {
        List<Room> rooms = roomRepository.findAll();
        return ResponseEntity.ok(rooms);
    }

    // ២. Filter ស្វែងរកបន្ទប់តាម Room Type ID
    @GetMapping("/type/{typeId}")
    public ResponseEntity<List<Room>> getRoomsByType(@PathVariable Integer typeId) {
        List<Room> rooms = roomRepository.findByRoomTypeRoomTypeId(typeId);
        return ResponseEntity.ok(rooms);
    }

    // ៣. Filter ស្វែងរកបន្ទប់តាម Status (AVAILABLE, BOOKED, etc.)
    @GetMapping("/status/{status}")
    public ResponseEntity<List<Room>> getRoomsByStatus(@PathVariable String status) {
        List<Room> rooms = roomRepository.findByStatus(status.toUpperCase());
        return ResponseEntity.ok(rooms);
    }
}