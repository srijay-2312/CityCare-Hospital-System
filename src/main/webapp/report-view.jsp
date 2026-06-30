<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.hospital.model.*, java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <title>Appointment Report - City Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: white; padding: 50px; }
        .report-header { border-bottom: 2px solid #000; margin-bottom: 30px; padding-bottom: 10px; }
        @media print {
            .no-print { display: none; }
            body { padding: 0; }
        }
    </style>
</head>
<body>

<div class="no-print mb-4">
    <button onclick="window.print()" class="btn btn-primary">🖨️ Print Report</button>
    <a href="admin-dashboard" class="btn btn-outline-secondary">Back to Dashboard</a>
</div>

<div class="report-header d-flex justify-content-between align-items-center">
    <div>
        <h1 class="fw-bold">CITY HOSPITAL</h1>
        <p class="text-muted">Official Appointment Schedule Report</p>
    </div>
    <div class="text-end">
        <p><strong>Date:</strong> <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new Date()) %></p>
        <p><strong>Status:</strong> All Records</p>
    </div>
</div>

<table class="table table-bordered mt-4">
    <thead class="table-dark">
    <tr>
        <th>ID</th>
        <th>Patient Name</th>
        <th>Doctor</th>
        <th>Date</th>
        <th>Status</th>
        <th>Description</th>
    </tr>
    </thead>
    <tbody>
    <%
        List<Appointment> list = (List<Appointment>) request.getAttribute("reportData");
        if (list != null) {
            for (Appointment app : list) {
    %>
    <tr>
        <td>#<%= app.getId() %></td>
        <td><strong><%= app.getPatientName() %></strong></td>
        <td>Dr. <%= app.getDoctorName() %></td>
        <td><%= app.getAppointmentDate() %></td>
        <td><%= app.getStatus() %></td>
        <td class="small"><%= app.getProblem() %></td>
    </tr>
    <% } } %>
    </tbody>
</table>

<div class="mt-5 text-center small text-muted">
    <p>This is a computer-generated report. End of records.</p>
</div>

</body>
</html>