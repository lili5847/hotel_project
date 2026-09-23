package com.hotel.servlet.auth;

import com.hotel.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/customer/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        Map<String, String> errors = new HashMap<>();

        if (fullName.isEmpty()) errors.put("fullName", "Enter your full name.");
        if (email.isEmpty() || !EMAIL_PATTERN.matcher(email).matches()) {
            errors.put("email", "Enter a valid email address.");
        }
        if (phone.isEmpty()) errors.put("phone", "Enter your phone number.");
        if (password == null || password.length() < 8) {
            errors.put("password", "Use at least 8 characters.");
        }
        if (password != null && !password.equals(confirmPassword)) {
            errors.put("confirmPassword", "Passwords do not match.");
        }

        // Only hit the database if the basic fields are valid — no point
        // checking email uniqueness on an already-invalid submission.
        if (errors.isEmpty()) {
            try {
                if (userDAO.emailExists(email)) {
                    errors.put("email", "This email is already registered.");
                }
            } catch (SQLException e) {
                req.setAttribute("error", "Something went wrong. Please try again.");
                req.setAttribute("errors", errors);
                req.getRequestDispatcher("/customer/register.jsp").forward(req, resp);
                return;
            }
        }

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("/customer/register.jsp").forward(req, resp);
            return;
        }

        try {
            int newId = userDAO.register(fullName, email, phone, password);
            if (newId == -1) {
                // Rare race condition: someone else registered the same email
                // between our emailExists() check and the insert.
                errors.put("email", "This email is already registered.");
                req.setAttribute("errors", errors);
                req.getRequestDispatcher("/customer/register.jsp").forward(req, resp);
                return;
            }
        } catch (SQLException e) {
            req.setAttribute("error", "Something went wrong. Please try again.");
            req.getRequestDispatcher("/customer/register.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/login?registered=1");
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }
}