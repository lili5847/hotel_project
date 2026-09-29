package com.hotel.service;

import com.hotel.model.Room;
import com.hotel.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RoomService {

    @Autowired
    private RoomRepository roomRepository;

    public List<Room> getAllRooms() {
        return roomRepository.findAll();
    }

    public Page<Room> getRoomsWithPagination(int page, int size, String sortBy) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(sortBy));
        return roomRepository.findAll(pageable);
    }

    public Room getRoomById(Integer id) {
        return roomRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("រកមិនឃើញបន្ទប់ដែលមាន ID: " + id));
    }

    public List<Room> getRoomsByStatus(String status) {
        return roomRepository.findByStatus(status);
    }

    public Room createRoom(Room room) {
        return roomRepository.save(room);
    }

    public Room updateRoom(Integer id, Room roomDetails) {
        Room existingRoom = getRoomById(id);
        existingRoom.setRoomNumber(roomDetails.getRoomNumber());
        existingRoom.setFloor(roomDetails.getFloor());
        existingRoom.setStatus(roomDetails.getStatus());
        existingRoom.setDescription(roomDetails.getDescription());
        if (roomDetails.getRoomType() != null) {
            existingRoom.setRoomType(roomDetails.getRoomType());
        }
        return roomRepository.save(existingRoom);
    }

    public void deleteRoom(Integer id) {
        if (!roomRepository.existsById(id)) {
            throw new RuntimeException("រកមិនឃើញបន្ទប់សម្រាប់លុបឡើយ");
        }
        roomRepository.deleteById(id);
    }
}