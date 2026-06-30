package com.hospital.web;

import com.hospital.dao.*;
import com.hospital.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private UserDAO userDAO;

    public void init() {
        appointmentDAO = new AppointmentDAO();
        userDAO = new UserDAO();
        // This log will help us confirm the cloud database connection
        System.out.println(">>> DATABASE CONNECTED TO: " + System.getenv("DB_URL"));
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // 1. Security Check
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        // 2. Handle AJAX Actions (Approve, Complete, Delete)
        if (action != null && idStr != null) {
            int id = Integer.parseInt(idStr);
            System.out.println(">>> CLOUD TRACE: Received action [" + action + "] for ID: " + id);

            if ("approve".equals(action) || "complete".equals(action)) {
                handleStatusChange(id, action, response);
                return;
            }

            if ("delete".equals(action)) {
                appointmentDAO.deleteAppointment(id);
                response.getWriter().write("success");
                return;
            }
        }

        // 3. Handle Report Generation
        if ("report".equals(action)) {
            request.setAttribute("reportData", appointmentDAO.getAllAppointments());
            request.getRequestDispatcher("report-view.jsp").forward(request, response);
            return;
        }

        // 4. Load Dashboard UI Data
        loadDashboardData(request, response);
    }

    private void handleStatusChange(int id, String action, HttpServletResponse response) throws IOException {
        Appointment app = appointmentDAO.getAppointment(id);
        if (app != null) {
            String newStatus = action.equals("approve") ? "Scheduled" : "Completed";
            String emailSubject = action.equals("approve") ? "Appointment Confirmed" : "Treatment Completed";

            app.setStatus(newStatus);
            appointmentDAO.updateAppointment(app);

            // Email Trigger Logic
            User p = userDAO.getUserById(app.getPatientId());
            if (p != null && p.getEmail() != null) {
                String patientEmail = p.getEmail();
                System.out.println(">>> CLOUD TRACE: Found Email: " + patientEmail);

                new Thread(() -> {
                    try {
                        EmailUtil.sendEmail(patientEmail, emailSubject, "Hello " + p.getFullName() + ", your appointment status is now: " + newStatus);
                    } catch (Exception ex) {
                        System.out.println(">>> CLOUD TRACE ERROR: Thread Mail Fail: " + ex.getMessage());
                    }
                }).start();
            } else {
                System.out.println(">>> CLOUD TRACE ERROR: No email found for patient ID: " + app.getPatientId());
            }

            response.getWriter().write("success");
        }
    }

    private void loadDashboardData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String viewStatus = request.getParameter("viewStatus");
        if (viewStatus == null) viewStatus = "Pending";

        request.setAttribute("appointments", appointmentDAO.getAppointmentsByStatus(viewStatus));
        request.setAttribute("currentStatus", viewStatus);

        // Populate stats for the charts
        request.setAttribute("countPending", appointmentDAO.getAppointmentsByStatus("Pending").size());
        request.setAttribute("countScheduled", appointmentDAO.getAppointmentsByStatus("Scheduled").size());
        request.setAttribute("countCompleted", appointmentDAO.getAppointmentsByStatus("Completed").size());

        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }
}