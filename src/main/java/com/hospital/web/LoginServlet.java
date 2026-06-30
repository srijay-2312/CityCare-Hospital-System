package com.hospital.web;

import com.hospital.dao.UserDAO;
import com.hospital.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    // Displays the login page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    // Handles the login form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String emailInput = request.getParameter("username"); // Matches the 'id' in your login.jsp
        String passInput = request.getParameter("password");

        User user = userDAO.login(emailInput, passInput);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // This is the important part - using the full path
            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient-dashboard");
            }
        } else {
            request.setAttribute("error", "Invalid login details");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}