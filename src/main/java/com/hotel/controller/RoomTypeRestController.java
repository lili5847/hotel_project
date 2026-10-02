package com.hotel.controller;

import com.hotel.dto.ApiResponse;
import com.hotel.model.RoomType;
import com.hotel.repository.RoomTypeRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/room-types")
@CrossOrigin(origins = "*")
@Tag(name = "Room Type APIs", description = "Manage room types")
public class RoomTypeRestController {

    @Autowired
    private RoomTypeRepository roomTypeRepository;

    @GetMapping
    @Operation(summary = "List all room types")
    public ResponseEntity<ApiResponse<List<RoomType>>> getAllRoomTypes() {
        return ResponseEntity.ok(ApiResponse.success("Room types loaded", roomTypeRepository.findAll()));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Create a room type (ADMIN only)")
    public ResponseEntity<ApiResponse<RoomType>> createRoomType(@RequestBody RoomType roomType) {
        roomType.setRoomTypeId(null); // let the database generate the id
        RoomType saved = roomTypeRepository.save(roomType);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Room type created", saved));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Update a room type (ADMIN only)")
    public ResponseEntity<ApiResponse<RoomType>> updateRoomType(@PathVariable Integer id,
                                                                @RequestBody RoomType details) {
        RoomType existing = roomTypeRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Room type not found"));

        existing.setTypeName(details.getTypeName());
        existing.setDescription(details.getDescription());
        existing.setPrice(details.getPrice());
        existing.setCapacity(details.getCapacity());
        existing.setAmenities(details.getAmenities());

        return ResponseEntity.ok(ApiResponse.success("Room type updated", roomTypeRepository.save(existing)));
    }

    // No DELETE on purpose: RoomType.rooms uses CascadeType.ALL, so deleting a type
    // would also delete every room that uses it.
}
