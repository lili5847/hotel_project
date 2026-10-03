
package com.hotel.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.time.LocalDateTime;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {

    private boolean success;
    private int status;
    private String message;
    private T data;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime timestamp;

    public ApiResponse() {
        this.timestamp = LocalDateTime.now();
    }

    public ApiResponse(
            boolean success,
            int status,
            String message,
            T data) {

        this.success = success;
        this.status = status;
        this.message = message;
        this.data = data;
        this.timestamp = LocalDateTime.now();
    }

    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(
                true,
                200,
                "Success",
                data
        );
    }

    public static <T> ApiResponse<T> success(
            String message,
            T data) {

        return new ApiResponse<>(
                true,
                200,
                message,
                data
        );
    }

    public static <T> ApiResponse<T> error(
            int status,
            String message) {

        return new ApiResponse<>(
                false,
                status,
                message,
                null
        );
    }

    public static <T> ApiResponse<T> error(
            int status,
            String message,
            T data) {

        return new ApiResponse<>(
                false,
                status,
                message,
                data
        );
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
}

