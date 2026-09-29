package com.hotel.controller;

import com.hotel.dto.ApiResponse;
import com.hotel.model.Room;
import com.hotel.service.RoomService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rooms")
@CrossOrigin(origins = "*")
@Tag(name = "Room APIs", description = "គ្រប់គ្រង និងស្វែងរកបន្ទប់សណ្ឋាគារ")
public class RoomRestController {

    @Autowired
    private RoomService roomService;

    // 1. មើលបញ្ជីបន្ទប់ទាំងអស់ (Public Access)
    @GetMapping
    @Operation(summary = "មើលបញ្ជីបន្ទប់ទាំងអស់", description = "ទាញយកបញ្ជីបន្ទប់ទាំងអស់ដែលមានក្នុងប្រព័ន្ធ")
    public ResponseEntity<ApiResponse<List<Room>>> getAllRooms() {
        List<Room> rooms = roomService.getAllRooms();
        return ResponseEntity.ok(ApiResponse.success("ទាញយកទិន្នន័យបន្ទប់ជោគជ័យ", rooms));
    }

    // 2. មើលបញ្ជីបន្ទប់តាម Pagination
    @GetMapping("/page")
    @Operation(summary = "ទាញយកបន្ទប់តាមទំព័រ (Pagination)", description = "ទាញយកបន្ទប់ដោយកំណត់ page, size, និង sortBy")
    public ResponseEntity<ApiResponse<Page<Room>>> getRoomsWithPagination(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "roomId") String sortBy) {

        Page<Room> roomPage = roomService.getRoomsWithPagination(page, size, sortBy);
        return ResponseEntity.ok(ApiResponse.success("ទាញយកទិន្នន័យជោគជ័យ", roomPage));
    }

    // 3. មើលព័ត៌មានបន្ទប់តាម ID
    @GetMapping("/{id}")
    @Operation(summary = "មើលព័ត៌មានបន្ទប់តាម ID")
    public ResponseEntity<ApiResponse<Room>> getRoomById(@PathVariable Integer id) {
        Room room = roomService.getRoomById(id);
        return ResponseEntity.ok(ApiResponse.success("ទាញយកទិន្នន័យបន្ទប់ជោគជ័យ", room));
    }

    // 4. ស្វែងរកបន្ទប់តាម Status (ឧ. AVAILABLE, OCCUPIED)
    @GetMapping("/status/{status}")
    @Operation(summary = "ស្វែងរកបន្ទប់តាម Status")
    public ResponseEntity<ApiResponse<List<Room>>> getRoomsByStatus(@PathVariable String status) {
        List<Room> rooms = roomService.getRoomsByStatus(status);
        return ResponseEntity.ok(ApiResponse.success("ទាញយកទិន្នន័យតាម Status ជោគជ័យ", rooms));
    }

    // 5. បន្ថែមបន្ទប់ថ្មី (សម្រាប់ ADMIN ប៉ុណ្ណោះ)
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "បន្ថែមបន្ទប់ថ្មី (សម្រាប់ ADMIN ប៉ុណ្ណោះ)")
    public ResponseEntity<ApiResponse<Room>> createRoom(@RequestBody Room room) {
        Room savedRoom = roomService.createRoom(room);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("បង្កើតបន្ទប់ថ្មីជោគជ័យ", savedRoom));
    }

    // 6. កែប្រែព័ត៌មានបន្ទប់ (សម្រាប់ ADMIN ប៉ុណ្ណោះ)
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "កែប្រែព័ត៌មានបន្ទប់ (សម្រាប់ ADMIN ប៉ុណ្ណោះ)")
    public ResponseEntity<ApiResponse<Room>> updateRoom(@PathVariable Integer id, @RequestBody Room roomDetails) {
        Room updatedRoom = roomService.updateRoom(id, roomDetails);
        return ResponseEntity.ok(ApiResponse.success("កែប្រែព័ត៌មានបន្ទប់ជោគជ័យ", updatedRoom));
    }

    // 7. លុบบន្ទប់ (សម្រាប់ ADMIN ប៉ុណ្ណោះ)
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "លុบบន្ទប់ (សម្រាប់ ADMIN ប៉ុណ្ណោះ)")
    public ResponseEntity<ApiResponse<String>> deleteRoom(@PathVariable Integer id) {
        roomService.deleteRoom(id);
        return ResponseEntity.ok(ApiResponse.success("លុบบន្ទប់ជោគជ័យ", null));
    }
}