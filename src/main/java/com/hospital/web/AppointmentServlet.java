package com.hospital.web;

import com.hospital.dao.AppointmentDAO;
import com.hospital.dao.DoctorDAO; // New Import
import com.hospital.model.Appointment;
import com.hospital.model.Department; // New Import
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/appointment")
public class AppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO; // New DAO

    public void init() {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO(); // Initialize
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String patientName = request.getParameter("patientName");

        // UPGRADE: Get doctorId (int) instead of doctorName (String)
        String doctorIdStr = request.getParameter("doctorId");

        String date = request.getParameter("appointmentDate");
        String problem = request.getParameter("problem");
        String status = request.getParameter("status");

        if (status == null || status.isEmpty()) {
            status = "Scheduled";
        }

        Appointment app = new Appointment();
        app.setPatientName(patientName);
        app.setAppointmentDate(date);
        app.setProblem(problem);
        app.setStatus(status);

        if (idStr != null && !idStr.isEmpty()) {
            app.setId(Integer.parseInt(idStr));
            appointmentDAO.updateAppointment(app);
        } else {
            // UPGRADE: Use the new method that handles doctorId
            int doctorId = Integer.parseInt(doctorIdStr);
            appointmentDAO.insertAppointmentWithDoctor(app, 0, doctorId);
        }

        response.sendRedirect("appointment");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String searchKeyword = request.getParameter("search");

        if (action != null && idStr != null) {
            int id = Integer.parseInt(idStr);
            if (action.equals("delete")) {
                appointmentDAO.deleteAppointment(id);
            } else if (action.equals("edit")) {
                Appointment existingApp = appointmentDAO.getAppointment(id);
                request.setAttribute("appointment", existingApp);
            }
        }

        List<Appointment> listAppointments;
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            listAppointments = appointmentDAO.searchAppointments(searchKeyword);
        } else {
            listAppointments = appointmentDAO.getAllAppointments();
        }

        // UPGRADE: Fetch departments so the public form can show the dropdown
        List<Department> departments = doctorDAO.getAllDepartments();
        request.setAttribute("departments", departments);

        request.setAttribute("listAppointments", listAppointments);
        request.getRequestDispatcher("appointment-form.jsp").forward(request, response);
    }
}