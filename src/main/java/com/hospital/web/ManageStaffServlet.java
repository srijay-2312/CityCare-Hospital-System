package com.hospital.web;

import com.hospital.dao.DoctorDAO;
import com.hospital.model.Department;
import com.hospital.model.Doctor;
import com.hospital.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manage-staff")
public class ManageStaffServlet extends HttpServlet {
    private DoctorDAO doctorDAO = new DoctorDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Security check
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }

        // FIXED DELETE LOGIC
        String action = request.getParameter("action");
        if ("deleteDoc".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                doctorDAO.deleteDoctor(id);
            }
            response.sendRedirect("manage-staff");
            return;
        }

        // Load lists for the UI
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        List<Department> departments = doctorDAO.getAllDepartments();

        request.setAttribute("doctors", doctors);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("manage-staff.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String type = request.getParameter("type");

        if ("doctor".equals(type)) {
            String name =  request.getParameter("name");
            String spec = request.getParameter("spec");
            int deptId = Integer.parseInt(request.getParameter("deptId"));
            doctorDAO.addDoctor(name, spec, deptId);
        } else if ("dept".equals(type)) {
            String deptName = request.getParameter("name");
            doctorDAO.addDepartment(deptName);
        }

        response.sendRedirect("manage-staff");
    }
}