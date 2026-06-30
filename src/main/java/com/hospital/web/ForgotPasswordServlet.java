package com.hospital.web;

import com.hospital.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String newPassword = request.getParameter("newPassword");

        if (userDAO.resetPassword(username, fullName, newPassword)) {
            // Success: Send to login with a specific flag
            response.sendRedirect("login.jsp?reset=success");
        } else {
            // Fail: Details didn't match
            response.sendRedirect("forgot-password.jsp?error=invalid");
        }
    }
}