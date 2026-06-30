<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.hospital.model.Appointment" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospital Management System</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { background-color: #007bff; }
        .card { border: none; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .table-container { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-dark mb-4">
    <div class="container">
        <a class="navbar-brand" href="appointment">🏥 City Hospital Appointment System</a>
    </div>
</nav>

<%
    Appointment existingApp = (Appointment) request.getAttribute("appointment");
    @SuppressWarnings("unchecked")
    List<Appointment> list = (List<Appointment>) request.getAttribute("listAppointments");
%>

<div class="container">
    <div class="row">
        <!-- Left Side: Form -->
        <div class="col-md-4">
            <div class="card p-4">
                <h4 class="mb-3 text-primary"><%= (existingApp != null) ? "Edit Appointment" : "New Appointment" %></h4>
                <form action="appointment" method="post">
                    <% if (existingApp != null) { %>
                    <input type="hidden" name="id" value="<%= existingApp.getId() %>">
                    <% } %>

                    <div class="mb-3">
                        <label for="patientName" class="form-label">Patient Name</label>
                        <input type="text" class="form-control" id="patientName" name="patientName"
                               value="<%= (existingApp != null) ? existingApp.getPatientName() : "" %>" required>
                    </div>

                    <div class="mb-3">
                        <label for="doctorName" class="form-label">Doctor Name</label>
                        <input type="text" class="form-control" id="doctorName" name="doctorName"
                               value="<%= (existingApp != null) ? existingApp.getDoctorName() : "" %>" required>
                    </div>

                    <div class="mb-3">
                        <label for="appointmentDate" class="form-label">Appointment Date</label>
                        <input type="date" class="form-control" id="appointmentDate" name="appointmentDate"
                               value="<%= (existingApp != null) ? existingApp.getAppointmentDate() : "" %>" required>
                    </div>

                    <div class="mb-3">
                        <label for="problem" class="form-label">Problem Description</label>
                        <textarea class="form-control" id="problem" name="problem" rows="3"><%= (existingApp != null) ? existingApp.getProblem() : "" %></textarea>
                    </div>

                    <button type="submit" class="btn btn-success w-100"><%= (existingApp != null) ? "Update Record" : "Save Appointment" %></button>

                    <% if (existingApp != null) { %>
                    <a href="appointment" class="btn btn-link w-100 mt-2 text-secondary text-decoration-none">Cancel Edit</a>
                    <% } %>
                </form>
            </div>
        </div>

        <!-- Right Side: Search and Table -->
        <div class="col-md-8">
            <div class="table-container">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="text-primary">Appointment Records</h4>
                    <!-- Search Form -->
                    <form action="appointment" method="get" class="d-flex gap-2">
                        <input type="text" class="form-control form-control-sm" name="search" placeholder="Search Patient..."
                               value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        <button class="btn btn-primary btn-sm" type="submit">Search</button>
                        <% if (request.getParameter("search") != null) { %>
                        <a href="appointment" class="btn btn-outline-secondary btn-sm">Clear</a>
                        <% } %>


                    </form>
                </div>

                <p class="text-muted small">Total Found: <%= (list != null) ? list.size() : 0 %></p>

                <table class="table table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (list != null) { for (Appointment app : list) { %>
                    <tr>
                        <td><%= app.getId() %></td>
                        <td><strong><%= app.getPatientName() %></strong></td>
                        <td>Dr. <%= app.getDoctorName() %></td>
                        <td>
                            <%= (app.getAppointmentDate() != null && app.getAppointmentDate().contains("-")) ?
                                    app.getAppointmentDate().split("-")[2] + "/" +
                                    app.getAppointmentDate().split("-")[1] + "/" +
                                    app.getAppointmentDate().split("-")[0] : app.getAppointmentDate() %>
                        </td>
                        <td>
                            <a href="appointment?action=edit&id=<%= app.getId() %>" class="btn btn-sm btn-outline-primary">Edit</a>
                            <a href="appointment?action=delete&id=<%= app.getId() %>"
                               class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this record?')">Delete</a>
                        </td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>