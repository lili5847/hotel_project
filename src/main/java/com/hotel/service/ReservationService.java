package com.hotel.service;

import com.hotel.dto.ReservationRequest;
import com.hotel.model.Customer;
import com.hotel.model.Reservation;
import com.hotel.model.Room;
import com.hotel.repository.CustomerRepository;
import com.hotel.repository.ReservationRepository;
import com.hotel.repository.RoomRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
public class ReservationService {

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private CustomerRepository customerRepository;

    // ១. បង្កើតការកក់បន្ទប់ (Create Booking)
    @Transactional
    public Reservation createReservation(LocalDate checkIn, LocalDate checkOut, Integer roomId, Integer customerId, Integer guests) {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new IllegalArgumentException("រកមិនឃើញព័ត៌មានអតិថិជនឡើយ!"));

        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new IllegalArgumentException("រកមិនឃើញបន្ទប់នេះឡើយ!"));

        // គណនាចំនួនថ្ងៃស្នាក់នៅ និងតម្លៃសរុប
        long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
        if (nights <= 0) {
            throw new IllegalArgumentException("កាលបរិច្ឆេទ Check-out ត្រូវតែធំជាង Check-in!");
        }

        Double pricePerNight = room.getRoomType().getPrice();
        Double totalAmount = nights * pricePerNight;

        // បង្កើត Object Reservation ថ្មី
        Reservation reservation = new Reservation();
        reservation.setCustomer(customer);
        reservation.setRoom(room);
        reservation.setCheckIn(checkIn);
        reservation.setCheckOut(checkOut);
        reservation.setGuests(guests);
        reservation.setTotalAmount(totalAmount);
        reservation.setStatus("PENDING"); // ស្ថានភាពរង់ចាំការទូទាត់ប្រាក់

        // ប្តូរ status បន្ទប់ទៅជា BOOKED
        room.setStatus("BOOKED");
        roomRepository.save(room);

        return reservationRepository.save(reservation);
    }

    // ២. ស្វែងរកការកក់តាមអតិថិជន
    public List<Reservation> getReservationsByCustomer(Integer customerId) {
        return reservationRepository.findByCustomerCustId(customerId);
    }

    // ៣. បោះបង់ការកក់ (Cancel Booking)
    @Transactional
    public void cancelReservation(Integer bookingId) {
        Reservation reservation = reservationRepository.findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("រកមិនឃើញការកក់នេះឡើយ!"));

        reservation.setStatus("CANCELLED");

        // ផ្លាស់ប្តូរស្ថានភាពបន្ទប់ឱ្យទំនេរវិញ
        Room room = reservation.getRoom();
        if (room != null) {
            room.setStatus("AVAILABLE");
            roomRepository.save(room);
        }

        reservationRepository.save(reservation);
    }

    public List<Reservation> getReservationsByUserId(Long userId) {
        return null;
    }

    public Reservation createReservation(@Valid ReservationRequest request) {
        return null;
    }
}