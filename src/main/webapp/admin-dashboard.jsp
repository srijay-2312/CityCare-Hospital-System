<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.hospital.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login");
        return;
    }
    @SuppressWarnings("unchecked")
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    String currentStatus = (String) request.getAttribute("currentStatus");
    if (currentStatus == null) currentStatus = "Scheduled";

    Integer countScheduled = (Integer) request.getAttribute("countScheduled");
    Integer countCompleted = (Integer) request.getAttribute("countCompleted");
    Integer countPending = (Integer) request.getAttribute("countPending");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | CityCare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root { --sidebar-w: 260px; }
        body { background: #f4f7f6; font-family: 'Inter', sans-serif; overflow-x: hidden; }
        .sidebar { width: var(--sidebar-w); height: 100vh; position: fixed; background: #1e2937; color: white; z-index: 1000; }
        .main { margin-left: var(--sidebar-w); padding: 40px; }
        .nav-link { color: #a0aec0; padding: 15px 25px; display: block; text-decoration: none; }
        .nav-link.active { background: #0d6efd; color: white; border-radius: 0 25px 25px 0; margin-right: 15px; }
        .card-custom { border: none; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.03); background: white; }
    </style>
</head>
<body>

<div class="sidebar shadow">
    <div class="p-4 text-center border-bottom border-secondary">
        <h4 class="fw-bold text-white"><i class="fas fa-hospital-alt me-2 text-primary"></i>CityCare</h4>
    </div>
    <nav class="mt-4">
        <a class="nav-link active" href="admin-dashboard"><i class="fas fa-th-large me-3"></i> Dashboard</a>
        <a class="nav-link" href="manage-staff"><i class="fas fa-user-md me-3"></i> Manage Staff</a>
        <a class="nav-link" href="admin-dashboard?action=report" target="_blank"><i class="fas fa-file-medical me-3"></i> Reports</a>
        <div class="mt-5 border-top border-secondary pt-3">
            <a class="nav-link text-danger" href="logout"><i class="fas fa-power-off me-3"></i> Sign Out</a>
        </div>
    </nav>
</div>

<div class="main">
    <div class="d-flex justify-content-between align-items-center mb-5">
        <div>
            <h2 class="fw-bold">Management Portal</h2>
            <p class="text-muted">Welcome back, Admin <%= user.getFullName() %></p>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card-custom p-4 text-center h-100">
                <!-- Ternary Logic replaces out.print to stop the error -->
                <p class="text-muted small fw-bold text-uppercase mb-1">
                    <%= "Pending".equals(currentStatus) ? "New Requests" : ("Scheduled".equals(currentStatus) ? "Active Queue" : "Completed Records") %>
                </p>
                <h1 class="fw-bold m-0"><%= (appointments != null) ? appointments.size() : 0 %></h1>
                <div style="height: 120px;" class="mt-3">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
        </div>
        <div class="col-md-8">
            <div class="card-custom p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <ul class="nav nav-pills bg-light p-1 rounded-pill">
                        <li class="nav-item">
                            <a class="nav-link rounded-pill <%= "Pending".equals(currentStatus) ? "active" : "" %>"
                               href="admin-dashboard?viewStatus=Pending">New Requests</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link rounded-pill <%= "Scheduled".equals(currentStatus) ? "active" : "" %>"
                               href="admin-dashboard?viewStatus=Scheduled">Queue</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link rounded-pill <%= "Completed".equals(currentStatus) ? "active" : "" %>"
                               href="admin-dashboard?viewStatus=Completed">History</a>
                        </li>
                    </ul>
                </div>

                <div class="table-responsive">
                    <table class="table align-middle" id="appointmentTable">
                        <thead class="text-muted small text-uppercase">
                        <tr><th>Patient</th><th>Physician</th><th>Schedule</th><th class="text-end">Actions</th></tr>
                        </thead>
                        <tbody>
                        <% if (appointments != null) { for (Appointment app : appointments) { %>
                        <tr id="row-<%= app.getId() %>" class="border-bottom">
                            <td class="py-3"><strong><%= app.getPatientName() %></strong></td>
                            <td><span class="badge bg-primary bg-opacity-10 text-primary fw-bold"><%= app.getDoctorName() %></span></td>
                            <td><%= app.getAppointmentDate() %> | <small class="text-muted"><%= app.getTimeSlot() %></small></td>
                            <td class="text-end">
                                <% if ("Pending".equals(currentStatus)) { %>
                                <button onclick="handleAction(<%= app.getId() %>, 'approve')" class="btn btn-sm btn-primary rounded-pill px-3 me-2">Approve</button>
                                <% } %>
                                <% if ("Scheduled".equals(currentStatus)) { %>
                                <button onclick="handleAction(<%= app.getId() %>, 'complete')" class="btn btn-sm btn-success rounded-pill px-3 me-2">Mark Done</button>
                                <% } %>
                                <button onclick="handleAction(<%= app.getId() %>, 'delete')" class="btn btn-sm text-danger border-0"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function handleAction(id, actionType) {
        let title = actionType === 'approve' ? 'Approve Appointment?' : (actionType === 'complete' ? 'Mark Done?' : 'Delete?');
        Swal.fire({ title: title, showCancelButton: true, confirmButtonText: 'Yes' }).then((result) => {
            if (result.isConfirmed) {
                fetch('admin-dashboard?action=' + actionType + '&id=' + id)
                    .then(res => res.text())
                    .then(data => {
                        if(data.trim() === 'success') {
                            const row = document.getElementById('row-' + id);
                            row.style.opacity = "0"; row.style.transform = "translateX(50px)";
                            setTimeout(() => { row.remove(); }, 400);
                            Swal.fire({ icon: 'success', title: 'Done!', timer: 1000, showConfirmButton: false });
                        }
                    });
            }
        });
    }

    const ctx = document.getElementById('statusChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['New', 'Queue', 'History'],
            datasets: [{
                data: [<%= countPending %>, <%= countScheduled %>, <%= countCompleted %>],
                backgroundColor: ['#ffc107', '#0d6efd', '#198754'],
                borderWidth: 0
            }]
        },
        options: { maintainAspectRatio: false, plugins: { legend: { display: false } }, cutout: '70%' }
    });
</script>
</body>
</html>