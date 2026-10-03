package com.hotel.dto;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

public class ReservationRequest {

    @NotNull(message = "សូមជ្រើសរើស ID របស់សមាជិក (User ID)")
    private Integer userId;

    @NotNull(message = "សូមជ្រើសរើស ID របស់បន្ទប់ (Room ID)")
    private Integer roomId;

    @NotNull(message = "សូមបញ្ចូលថ្ងៃចូលស្នាក់នៅ")
    @FutureOrPresent(message = "ថ្ងៃចូលស្នាក់នៅត្រូវតែជាថ្ងៃនេះ ឬថ្ងៃអនាគត")
    private LocalDate checkInDate;

    @NotNull(message = "សូមបញ្ចូលថ្ងៃចាកចេញ")
    @Future(message = "ថ្ងៃចាកចេញត្រូវតែជាថ្ងៃអនាគត")
    private LocalDate checkOutDate;

    private Integer guests;

    private String specialRequests;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public LocalDate getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(LocalDate checkInDate) {
        this.checkInDate = checkInDate;
    }

    public LocalDate getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(LocalDate checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public Integer getGuests() {
        return guests;
    }

    public void setGuests(Integer guests) {
        this.guests = guests;
    }

    public String getSpecialRequests() {
        return specialRequests;
    }

    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
    }
}

