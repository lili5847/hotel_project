package com.hotel.dao;

import com.hotel.model.Room;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<Room> searchRooms(String checkIn, String checkOut, int guests, String[] types,
                                  Double minPrice, Double maxPrice, String sort, int page, int pageSize) {
        List<Room> list = new ArrayList<>();

        // Dynamic SQL Logic:
        // SELECT * FROM rooms WHERE guest_capacity >= guests
        // AND price >= minPrice AND price <= maxPrice
        // AND type IN ('POOL_VIEW', ...)
        // ORDER BY ... LIMIT pageSize OFFSET (page-1)*pageSize

        // TODO: អនុវត្ត JDBC Connection និង ResultSet mapping ចូលក្នុង list

        return list;
    }

    public int getSearchResultCount(String checkIn, String checkOut, int guests, String[] types,
                                    Double minPrice, Double maxPrice) {
        // SELECT COUNT(*) FROM rooms WHERE ...
        return 0;
    }
}