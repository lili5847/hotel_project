package com.hotel.repository;

import com.hotel.model.Room;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, Integer> {

    @Override
    @EntityGraph(attributePaths = {"roomType"})
    List<Room> findAll();

    @EntityGraph(attributePaths = {"roomType"})
    List<Room> findByStatus(String status);

    List<Room> findByRoomTypeRoomTypeId(Integer roomTypeId);

    @EntityGraph(attributePaths = {"roomType"})
    @Query("""
        SELECT r
        FROM Room r
        JOIN r.roomType rt
        WHERE (:guests IS NULL OR rt.capacity >= :guests)
          AND (:minPrice IS NULL OR rt.price >= :minPrice)
          AND (:maxPrice IS NULL OR rt.price <= :maxPrice)
          AND (:status IS NULL OR :status = '' OR r.status = :status)
          AND (
              :typeCount = 0
              OR rt.typeName IN :types
          )
        """)
    Page<Room> searchRooms(
            @Param("guests") Integer guests,
            @Param("minPrice") Double minPrice,
            @Param("maxPrice") Double maxPrice,
            @Param("status") String status,
            @Param("types") List<String> types,
            @Param("typeCount") int typeCount,
            Pageable pageable
    );
}