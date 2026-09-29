package com.hotel.dto;

import com.hotel.model.Room;

public class RoomResponseDto {

    private Integer id;
    private String roomNumber;
    private String status;
    private Double price;
    private String typeName;
    // Constructors
    public RoomResponseDto() {}

    public RoomResponseDto(Integer id, String roomNumber, String status, Double price, String typeName) {
        this.id = id;
        this.roomNumber = roomNumber;
        this.status = status;
        this.price = price;
        this.typeName = typeName;
    }

    // Static Converter Method (ងាយស្រួលបំប្លែងពី Room Entity មក DTO)
    public static RoomResponseDto fromEntity(Room room) {
        if (room == null) return null;

        RoomResponseDto dto = new RoomResponseDto();
        dto.setId(room.getRoomId());
        dto.setRoomNumber(room.getRoomNumber());
        dto.setStatus(room.getStatus());

        if (room.getRoomType() != null) {
            dto.setPrice(room.getRoomType().getPrice());
            dto.setTypeName(room.getRoomType().getTypeName());
        }

        return dto;
    }

    // Getters & Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }
}