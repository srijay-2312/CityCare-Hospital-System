package com.hospital.web;

import com.hospital.dao.DoctorDAO;
import com.hospital.model.Doctor;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/get-doctors")
public class GetDoctorsServlet extends HttpServlet {
    private DoctorDAO doctorDAO = new DoctorDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String deptIdStr = request.getParameter("deptId");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        if (deptIdStr != null && !deptIdStr.isEmpty()) {
            int deptId = Integer.parseInt(deptIdStr);
            List<Doctor> doctors = doctorDAO.getDoctorsByDepartment(deptId);

            out.println("<option value=''>-- Select Doctor --</option>");
            for (Doctor doc : doctors) {
                // REMOVED "Dr." prefix here because it is already in the DB
                out.println("<option value='" + doc.getId() + "'>" + doc.getFullName() + " (" + doc.getSpecialization() + ")</option>");
            }
        } else {
            out.println("<option value=''>-- Select Dept First --</option>");
        }
    }
}