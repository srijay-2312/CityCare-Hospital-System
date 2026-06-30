<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.Appointment" %>
<%
    Appointment app = (Appointment) request.getAttribute("app");
    if (app == null) { response.sendRedirect("patient-dashboard"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Appointment Receipt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { padding: 40px; background: #eee; }
        .receipt { max-width: 400px; background: white; margin: 0 auto; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); border-top: 10px solid #0d6efd; }
        @media print { .no-print { display: none; } body { background: white; padding: 0; } .receipt { box-shadow: none; border: 1px solid #ddd; } }
    </style>
</head>
<body>
<div class="receipt text-center">
    <h2 class="fw-bold">CITY HOSPITAL</h2>
    <p class="text-muted small">Appointment Receipt</p>
    <hr>
    <div class="text-start mt-4">
        <p><strong>Patient:</strong> <%= app.getPatientName() %></p>
        <p><strong>Doctor:</strong> <%= app.getDoctorName() %></p>
        <p><strong>Date:</strong> <%= app.getAppointmentDate() %></p>
        <p><strong>Time:</strong> <%= app.getTimeSlot() %></p>
        <p><strong>Reason:</strong> <%= app.getProblem() %></p>
        <p><strong>Status:</strong> <span class="badge bg-primary"><%= app.getStatus() %></span></p>
    </div>
    <hr>
    <div class="no-print mt-4">
        <button onclick="window.print()" class="btn btn-primary btn-sm w-100">Print Ticket</button>
    </div>
</div>
</body>
</html>