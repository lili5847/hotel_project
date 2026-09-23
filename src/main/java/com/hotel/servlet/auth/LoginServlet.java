package com.hotel.servlet.auth;

import com.hotel.dao.UserDAO;
import com.hotel.User;
import com.hotel.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/customer/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String redirect = req.getParameter("redirect");

        User user = null;
        try {
            if (email != null) {
                user = (User) userDAO.findByEmail(email.trim());
            }
        } catch (SQLException e) {
            req.setAttribute("error", "Something went wrong. Please try again.");
            req.getRequestDispatcher("/customer/login.jsp").forward(req, resp);
            return;
        }

        // One generic message for both "no such email" and "wrong password" —
        // never reveal which one was wrong.
        boolean valid = user != null && PasswordUtil.matches(password, user.getPasswordHash());

        if (!valid) {
            req.setAttribute("error", "Incorrect email or password.");
            req.getRequestDispatcher("/customer/login.jsp").forward(req, resp);
            return;
        }

        if (!user.isActive()) {
            req.setAttribute("error", "This account has been suspended. Contact the front desk for help.");
            req.getRequestDispatcher("/customer/login.jsp").forward(req, resp);
            return;
        }

        // Prevent session fixation: rotate the session ID on privilege change.
        HttpSession session = req.getSession(true);
        session.invalidate();
        session = req.getSession(true);

        // Never put the password hash where a JSP could accidentally print it.
        user.setPasswordHash(null);
        session.setAttribute("user", user);

        // Only follow "redirect" if it's a safe internal path — otherwise this
        // param could be abused to bounce users to an external site.
        if (redirect != null && redirect.startsWith("/") && !redirect.startsWith("//")) {
            resp.sendRedirect(req.getContextPath() + redirect);
        } else if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }
}