<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.hospital.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    List<Department> depts = (List<Department>) request.getAttribute("departments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Staff | City Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root { --sidebar-w: 260px; }
        body { background: #f4f7f6; font-family: 'Inter', sans-serif; }
        .sidebar { width: var(--sidebar-w); height: 100vh; position: fixed; background: #1e2937; color: white; }
        .main { margin-left: var(--sidebar-w); padding: 40px; }
        .nav-link { color: #a0aec0; padding: 15px 25px; text-decoration: none; display: block;}
        .nav-link.active { background: #0d6efd; color: white; }
        .card-custom { border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); background: white; }
    </style>
</head>
<body>

<div class="sidebar shadow">
    <div class="p-4 border-bottom border-secondary text-center">
        <h4 class="fw-bold">CityCare Admin</h4>
    </div>
    <nav class="mt-3">
        <a class="nav-link" href="admin-dashboard"><i class="fas fa-columns me-2"></i> Dashboard</a>
        <a class="nav-link active" href="manage-staff"><i class="fas fa-user-md me-2"></i> Manage Staff</a>
        <a class="nav-link text-danger mt-5" href="logout"><i class="fas fa-power-off me-2"></i> Logout</a>
    </nav>
</div>

<div class="main">
    <h2 class="fw-bold mb-4">Staff Control Center</h2>
    <div class="row g-4">
        <!-- Forms Column -->
        <div class="col-md-4">
            <div class="card-custom p-4 mb-4">
                <h5 class="fw-bold text-success mb-3">Add New Physician</h5>
                <form action="manage-staff" method="post">
                    <input type="hidden" name="type" value="doctor">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Name</label>
                        <input type="text" class="form-control" name="name" placeholder="John Smith" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Department</label>
                        <select class="form-select" name="deptId" required>
                            <% if(depts != null) { for(Department d : depts) { %>
                            <option value="<%= d.getId() %>"><%= d.getName() %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Specialization</label>
                        <input type="text" class="form-control" name="spec" placeholder="Cardiology" required>
                    </div>
                    <button type="submit" class="btn btn-success w-100">Save Doctor</button>
                </form>
            </div>

            <div class="card-custom p-4">
                <h5 class="fw-bold text-primary mb-3">Add Department</h5>
                <form action="manage-staff" method="post">
                    <input type="hidden" name="type" value="dept">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Name</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Create</button>
                </form>
            </div>
        </div>

        <!-- Table Column -->
        <div class="col-md-8">
            <div class="card-custom p-4 h-100">
                <h5 class="fw-bold mb-4">Active Staff Directory</h5>
                <table class="table align-middle">
                    <thead><tr><th>Doctor Name</th><th>Specialization</th><th class="text-end">Action</th></tr></thead>
                    <tbody>
                    <% if (doctors != null) { for (Doctor d : doctors) { %>
                    <tr>
                        <td><strong><%= d.getFullName() %></strong></td>
                        <td><span class="badge bg-info bg-opacity-10 text-info"><%= d.getSpecialization() %></span></td>
                        <td class="text-end">
                            <a href="manage-staff?action=deleteDoc&id=<%= d.getId() %>" class="btn btn-sm text-danger border-0" onclick="return confirm('Remove doctor?')"><i class="fas fa-trash"></i></a>
                        </td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>