package com.hotel.repository;

import com.hotel.model.Room;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, Integer> {

    // ១. Fetch យក Room ព្រមជាមួយ RoomType ក្នុង Query តែមួយ (លុបបាត់ N+1 Problem ពេលទាញយកបន្ទប់ទាំងអស់)
    @Override
    @EntityGraph(attributePaths = {"roomType"})
    List<Room> findAll();

    // ២. Fetch យក RoomType មកជាមួយដែរ ពេល Search តាម Status
    @EntityGraph(attributePaths = {"roomType"})
    List<Room> findByStatus(String status);

    // ៣. ស្វែងរកតាម RoomType ID
    List<Room> findByRoomTypeRoomTypeId(Integer roomTypeId);
}