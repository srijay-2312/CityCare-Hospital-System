package com.hospital.web;

import com.hospital.dao.UserDAO;
import com.hospital.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.hospital.model.PasswordUtil;
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() { userDAO = new UserDAO(); }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email= request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");


        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setUsername(username);
        newUser.setPassword(PasswordUtil.hashPassword(password));
        // Try to register the user
        if (userDAO.registerUser(newUser)) {
            response.sendRedirect("login.jsp?registered=true");
        } else {
            // This is where we go if the username already exists
            response.sendRedirect("register.jsp?error=taken");
        }
    }
}