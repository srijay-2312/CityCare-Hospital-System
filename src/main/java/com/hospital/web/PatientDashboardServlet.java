package com.hospital.web;

import com.hospital.dao.AppointmentDAO;
import com.hospital.dao.DoctorDAO;
import com.hospital.model.Appointment;
import com.hospital.model.Department;
import com.hospital.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/patient-dashboard")
public class PatientDashboardServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }

        // Handle receipt printing
        if ("print".equals(request.getParameter("action"))) {
            Appointment app = appointmentDAO.getAppointment(Integer.parseInt(request.getParameter("id")));
            request.setAttribute("app", app);
            request.getRequestDispatcher("appointment-receipt.jsp").forward(request, response);
            return;
        }

        // Load dashboard data
        List<Appointment> history = appointmentDAO.getAppointmentsByPatient(user.getId());
        List<Department> departments = doctorDAO.getAllDepartments();

        request.setAttribute("history", history);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("patient-dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        String date = request.getParameter("appointmentDate");
        String timeSlot = request.getParameter("timeSlot");
        String problem = request.getParameter("problem");

        // Check if slot is taken
        if (!appointmentDAO.isSlotAvailable(doctorId, date, timeSlot)) {
            response.sendRedirect("patient-dashboard?error=slot_taken");
            return;
        }

        // Create appointment with PENDING status
        Appointment newApp = new Appointment();
        newApp.setPatientName(user.getFullName());
        newApp.setAppointmentDate(date);
        newApp.setTimeSlot(timeSlot);
        newApp.setProblem(problem);
        newApp.setStatus("Pending"); // Start as Pending

        // Save to DB (No email trigger here)
        appointmentDAO.insertAppointmentWithDoctor(newApp, user.getId(), doctorId);

        response.sendRedirect("patient-dashboard?success=1");
    }
}