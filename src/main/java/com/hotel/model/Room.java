package com.hotel.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

@Entity
@Table(name = "ROOMS")
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "room_id")
    private Integer roomId;

    @ManyToOne(fetch = FetchType.LAZY) // 👈 ប្រើ LAZY Fetch ដើម្បីកុំឱ្យ Performance ធ្លាក់ (Load ទិន្នន័យតែពេលត្រូវការ)
    @JoinColumn(name = "room_type_id")
    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler", "rooms"}) // 👈 ការពារ Error ពេល Serialize LAZY Object ទៅជា JSON
    private RoomType roomType;

    @Column(name = "room_number", nullable = false)
    private String roomNumber;

    @Column(name = "floor")
    private Integer floor;

    @Column(name = "status")
    private String status;

    @Column(name = "description")
    private String description;

    public Room() {}

    // Getters and Setters
    public Integer getRoomId() { return roomId; }
    public void setRoomId(Integer roomId) { this.roomId = roomId; }

    public RoomType getRoomType() { return roomType; }
    public void setRoomType(RoomType roomType) { this.roomType = roomType; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public Integer getFloor() { return floor; }
    public void setFloor(Integer floor) { this.floor = floor; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

//    public String getTypeLabel() {
//        if ("POOL_VIEW".equals(type)) return "Pool view";
//        if ("CITY_VIEW".equals(type)) return "City view";
//        if ("FAMILY_SUITE".equals(type)) return "Family suite";
//        return type;
//    }
}
