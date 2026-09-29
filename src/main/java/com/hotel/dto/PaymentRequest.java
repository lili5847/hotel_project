package com.hotel.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class PaymentRequest {

    @NotNull(message = "សូមបញ្ចូល ID នៃការកក់ (Reservation ID)")
    private Integer reservationId;

    @NotNull(message = "សូមបញ្ចូលចំនួនទឹកប្រាក់")
    @Min(value = 0, message = "ទឹកប្រាក់ត្រូវតែធំជាង 0")
    private Double amount;

    @NotBlank(message = "សូមជ្រើសរើសវិធីសាស្ត្រទូទាត់ (ឧ. KHQR, CREDIT_CARD, CASH)")
    private String paymentMethod;

    private String transactionId; // លេខកូដប្រតិបត្តិការ (ឧ. លេខ Tran ID ពី ABA/KHQR)

    // Getters and Setters
    public Integer getReservationId() { return reservationId; }
    public void setReservationId(Integer reservationId) { this.reservationId = reservationId; }

    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }
}