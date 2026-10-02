package com.hotel.controller;

import com.hotel.dao.RoomDAO;
import com.hotel.model.Room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet("/rooms")
public class RoomSearchServlet extends HttpServlet {

    private RoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO(); // Initialize ជាមួយ Database connection
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. ទទួលយក Parameters ពី Form
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        String guestsStr = request.getParameter("guests");
        String[] selectedTypes = request.getParameterValues("type"); // ទទួល Checkboxes ច្រើន
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String sort = request.getParameter("sort");
        String pageStr = request.getParameter("page");

        // 2. Parse ទិន្នន័យ (ជាមួយ Default values)
        int guests = (guestsStr != null && !guestsStr.isEmpty()) ? Integer.parseInt(guestsStr) : 1;
        Double minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Double.parseDouble(minPriceStr) : null;
        Double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : null;
        int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
        int pageSize = 6; // បង្ហាញ ៦ បន្ទប់ក្នុងមួយទំព័រ

        if (sort == null || sort.isEmpty()) {
            sort = "recommended";
        }

        // 3. ហៅ DAO ដើម្បី Search ទិន្នន័យ និងរាប់ចំនួនសរុប
        List<Room> rooms = roomDAO.searchRooms(checkIn, checkOut, guests, selectedTypes, minPrice, maxPrice, sort, page, pageSize);
        int resultCount = roomDAO.getSearchResultCount(checkIn, checkOut, guests, selectedTypes, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) resultCount / pageSize);

        // 4. ផ្ញើទិន្នន័យត្រឡប់ទៅឱ្យ JSP
        request.setAttribute("rooms", rooms);
        request.setAttribute("resultCount", resultCount);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Echo ព័ត៌មានដែល User បាន Search មកវិញដើម្បីរក្សាស្ថានភាព Form (Keep form filled)
        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("guests", guests);
        request.setAttribute("selectedTypes", selectedTypes != null ? Arrays.asList(selectedTypes) : null);
        request.setAttribute("minPrice", minPriceStr);
        request.setAttribute("maxPrice", maxPriceStr);
        request.setAttribute("sort", sort);

        // 5. Forward ទៅកាន់ JSP ទំព័រ Customer/room-search.jsp
        request.getRequestDispatcher("/Customer/room-search.jsp").forward(request, response);
    }
}