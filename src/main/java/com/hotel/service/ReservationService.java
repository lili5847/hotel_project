package com.hotel.service;

import com.hotel.dto.ReservationRequest;
import com.hotel.model.Customer;
import com.hotel.model.Reservation;
import com.hotel.model.Room;
import com.hotel.repository.CustomerRepository;
import com.hotel.repository.ReservationRepository;
import com.hotel.repository.RoomRepository;

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

    @Transactional
    public Reservation createReservation(ReservationRequest request) {

        if (request == null) {
            throw new IllegalArgumentException("Reservation request មិនអាចទទេបានទេ!");
        }

        Integer userId = request.getUserId();
        Integer roomId = request.getRoomId();
        LocalDate checkIn = request.getCheckInDate();
        LocalDate checkOut = request.getCheckOutDate();
        Integer guests = request.getGuests();

        if (userId == null) {
            throw new IllegalArgumentException("User ID ត្រូវតែមាន!");
        }

        if (roomId == null) {
            throw new IllegalArgumentException("Room ID ត្រូវតែមាន!");
        }

        if (checkIn == null || checkOut == null) {
            throw new IllegalArgumentException("Check-in និង Check-out ត្រូវតែមាន!");
        }

        if (!checkOut.isAfter(checkIn)) {
            throw new IllegalArgumentException("Check-out ត្រូវតែធំជាង Check-in!");
        }

        Customer customer = customerRepository
                .findByUserUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException(
                        "រកមិនឃើញ Customer សម្រាប់ User ID: " + userId));

        Room room = roomRepository
                .findById(roomId)
                .orElseThrow(() -> new IllegalArgumentException(
                        "រកមិនឃើញបន្ទប់ ID: " + roomId));

        if (room.getRoomType() == null) {
            throw new IllegalArgumentException("បន្ទប់នេះមិនទាន់មាន Room Type!");
        }

        if (room.getRoomType().getPrice() == null) {
            throw new IllegalArgumentException("Room Type នេះមិនទាន់មានតម្លៃ!");
        }

        if (guests == null || guests < 1) {
            throw new IllegalArgumentException("ចំនួនភ្ញៀវត្រូវតែយ៉ាងហោចណាស់ 1 នាក់!");
        }

        Integer capacity = room.getRoomType().getCapacity();

        if (capacity != null && guests > capacity) {
            throw new IllegalArgumentException(
                    "ចំនួនភ្ញៀវលើសពីសមត្ថភាពបន្ទប់។ អតិបរមា " + capacity + " នាក់!");
        }

        boolean booked = reservationRepository.isRoomBookedOverlap(roomId, checkIn, checkOut);

        if (booked) {
            throw new IllegalArgumentException("បន្ទប់នេះត្រូវបានកក់រួចហើយសម្រាប់កាលបរិច្ឆេទនេះ!");
        }

        long nights = ChronoUnit.DAYS.between(checkIn, checkOut);

        if (nights <= 0) {
            throw new IllegalArgumentException("ចំនួនថ្ងៃស្នាក់នៅមិនត្រឹមត្រូវ!");
        }

        Double pricePerNight = room.getRoomType().getPrice();
        Double totalAmount = nights * pricePerNight;

        Reservation reservation = new Reservation();
        reservation.setCustomer(customer);
        reservation.setRoom(room);
        reservation.setCheckIn(checkIn);
        reservation.setCheckOut(checkOut);
        reservation.setGuests(guests);
        reservation.setTotalAmount(totalAmount);
        reservation.setStatus("PENDING");

        return reservationRepository.save(reservation);
    }

    public List<Reservation> getAllReservations() {
        return reservationRepository.findAll();
    }

    public List<Reservation> getReservationsByCustomer(Integer customerId) {
        return reservationRepository.findByCustomerCustId(customerId);
    }

    public List<Reservation> getReservationsByUserId(Long userId) {

        if (userId == null) {
            throw new IllegalArgumentException("User ID មិនអាចទទេបានទេ!");
        }

        Customer customer = customerRepository
                .findByUserUserId(userId.intValue())
                .orElseThrow(() -> new IllegalArgumentException(
                        "រកមិនឃើញ Customer សម្រាប់ User ID: " + userId));

        return reservationRepository.findByCustomerCustId(customer.getCustId());
    }

    /**
     * Cancel a reservation only when it belongs to the specified customer.
     */
    @Transactional
    public void cancelReservation(Integer bookingId, Integer customerId) {

        if (bookingId == null) {
            throw new IllegalArgumentException("Booking ID ត្រូវតែមាន!");
        }

        if (customerId == null) {
            throw new IllegalArgumentException("Customer ID ត្រូវតែមាន!");
        }

        Reservation reservation = reservationRepository
                .findById(bookingId)
                .orElseThrow(() -> new IllegalArgumentException(
                        "រកមិនឃើញការកក់ ID: " + bookingId));

        if (reservation.getCustomer() == null
                || reservation.getCustomer().getCustId() == null
                || !reservation.getCustomer().getCustId().equals(customerId)) {
            throw new IllegalArgumentException("អ្នកមិនមានសិទ្ធិលុបការកក់នេះទេ!");
        }

        if ("CANCELLED".equalsIgnoreCase(reservation.getStatus())) {
            throw new IllegalArgumentException("ការកក់នេះត្រូវបានលុបរួចហើយ!");
        }

        reservation.setStatus("CANCELLED");
        reservationRepository.save(reservation);
    }

    /**
     * Cancel a reservation using the logged-in user's ID.
     */
    @Transactional
    public void cancelReservationByUserId(Integer bookingId, Integer userId) {

        if (userId == null) {
            throw new IllegalArgumentException("User ID ត្រូវតែមាន!");
        }

        Customer customer = customerRepository
                .findByUserUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException(
                        "រកមិនឃើញ Customer សម្រាប់ User ID: " + userId));

        cancelReservation(bookingId, customer.getCustId());
    }
}