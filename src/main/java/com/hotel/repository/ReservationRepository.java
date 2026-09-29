package com.hotel.repository;

import com.hotel.model.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Integer> {

    // ស្វែងរកតាម Customer ID
    List<Reservation> findByCustomerCustId(Integer custId);

    // អ្នកប្រើ userId ជំនួស Customer អាចបើកប្រើ line
    // List<Reservation> findByUserId(Integer userId);

    // រកតាម Status នៃការកក់
    List<Reservation> findByStatus(String status);

    // ពិនិត្យមើលថាតើមានការកក់ដែលជាន់កាលបរិច្ឆេទគ្នានៅលើបន្ទប់តែមួយដែរឬទេ
    @Query("SELECT COUNT(r) > 0 FROM Reservation r WHERE r.room.roomId = :roomId " +
            "AND r.status IN ('PENDING', 'CONFIRMED') " +
            "AND (:checkInDate < r.checkOutDate AND :checkOutDate > r.checkInDate)")
    boolean isRoomBookedOverlap(@Param("roomId") Integer roomId,
                                @Param("checkInDate") LocalDate checkInDate,
                                @Param("checkOutDate") LocalDate checkOutDate);
}