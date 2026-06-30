<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.hospital.model.*" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null || !"patient".equals(user.getRole())) {
    response.sendRedirect("login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Patient Portal | CityCare</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <style>
    body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; transition: 0.3s; }
    .navbar-custom { background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .card-custom { border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); background: white; }

    /* --- CHATBOT UI --- */
    #chat-toggle { position: fixed; bottom: 30px; right: 30px; width: 60px; height: 60px; background: #0d6efd; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; cursor: pointer; z-index: 9999; box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
    #ai-chat-window { position: fixed; bottom: 100px; right: 30px; width: 320px; z-index: 9999; background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }

    #chat-body {
      height: 300px; overflow-y: auto; background: #f8f9fa;
      display: flex; flex-direction: column; padding: 15px;
    }
    /* AI Messages (Left) */
    .bot-msg {
      background: #e9ecef; color: #333; padding: 10px; border-radius: 10px;
      margin-bottom: 10px; font-size: 0.85rem; align-self: flex-start; width: 85%;
    }
    /* User Messages (Right) */
    .user-msg {
      background: #0d6efd; color: white; padding: 10px; border-radius: 10px;
      margin-bottom: 10px; font-size: 0.85rem; align-self: flex-end; width: 85%;
      text-align: right;
    }
  </style>
</head>
<body>

<nav class="navbar navbar-custom py-3 mb-5">
  <div class="container">
    <a class="navbar-brand fw-bold text-primary" href="#"><i class="fas fa-stethoscope me-2"></i>City Hospital</a>
    <div class="d-flex align-items-center">
      <span class="me-3 small fw-bold text-secondary"><%= user.getFullName() %></span>
      <a href="logout" class="btn btn-sm btn-outline-danger rounded-pill px-3">Logout</a>
    </div>
  </div>
</nav>

<div class="container">
  <div class="row g-4">
    <div class="col-lg-4">
      <div class="card-custom p-4">
        <h5 class="fw-bold text-success mb-4"><i class="fas fa-calendar-plus me-2"></i>Book Appointment</h5>
        <form action="patient-dashboard" method="post">
          <div class="mb-3">
            <label for="deptSelect" class="form-label small fw-bold">Department</label>
            <select class="form-select" id="deptSelect" onchange="loadDoctors(this.value)" required>
              <option value="">-- Choose Department --</option>
              <% List<Department> depts = (List<Department>) request.getAttribute("departments");
                if(depts != null) { for(Department d : depts) { %>
              <option value="<%= d.getId() %>"><%= d.getName() %></option>
              <% } } %>
            </select>
          </div>
          <div class="mb-3">
            <label for="doctorSelect" class="form-label small fw-bold">Doctor</label>
            <select class="form-select" id="doctorSelect" name="doctorId" required>
              <option value="">-- Select Dept First --</option>
            </select>
          </div>
          <div class="row">
            <div class="col-6 mb-3">
              <label for="date" class="form-label small fw-bold">Date</label>
              <input type="date" class="form-control" id="date" name="appointmentDate" required>
            </div>
            <div class="col-6 mb-3">
              <label for="time" class="form-label small fw-bold">Time</label>
              <select class="form-select" id="time" name="timeSlot" required>
                <option value="09:00 AM">09:00 AM</option>
                <option value="11:00 AM">11:00 AM</option>
                <option value="03:00 PM">03:00 PM</option>
              </select>
            </div>
          </div>
          <div class="mb-3">
            <label for="prob" class="form-label small fw-bold">Problem</label>
            <textarea class="form-control" id="prob" name="problem" rows="2" required></textarea>
          </div>
          <button type="submit" class="btn btn-success w-100 py-2 fw-bold">Confirm Booking</button>
        </form>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card-custom p-4">
        <h5 class="fw-bold text-primary mb-4"><i class="fas fa-history me-2"></i>My History</h5>
        <table class="table align-middle">
          <thead><tr><th>Physician</th><th>Time</th><th>Status</th></tr></thead>
          <tbody>
          <% List<Appointment> hist = (List<Appointment>) request.getAttribute("history");
            if(hist != null) { for(Appointment app : hist) { %>
          <tr>
            <td><strong> <%= app.getDoctorName() %></strong></td>
            <td><%= app.getAppointmentDate() %></td>
            <td><span class="badge bg-primary bg-opacity-10 text-primary rounded-pill"><%= app.getStatus() %></span></td>
          </tr>
          <% } } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- AI Chatbot UI -->
<div id="chat-toggle" onclick="toggleChat()"><i class="fas fa-robot"></i></div>
<div id="ai-chat-window" class="d-none">
  <div class="card-header bg-primary text-white d-flex justify-content-between p-3">
    <span>AI Symptom Guide</span>
    <i class="fas fa-times cursor-pointer" onclick="toggleChat()"></i>
  </div>
  <div id="chat-body">
    <div class="bot-msg">Hello! Describe your symptoms and I will suggest a department.</div>
  </div>
  <div class="p-2 border-top bg-white">
    <div class="input-group">
      <input type="text" id="user-input" class="form-control form-control-sm" placeholder="Symptoms...">
      <button class="btn btn-primary btn-sm" onclick="askAI()">Send</button>
    </div>
  </div>
</div>

<script>
  function loadDoctors(id) { fetch("get-doctors?deptId=" + id).then(r => r.text()).then(d => document.getElementById("doctorSelect").innerHTML = d); }

  function toggleChat() { document.getElementById("ai-chat-window").classList.toggle("d-none"); }

  async function askAI() {
    const inputField = document.getElementById("user-input");
    const chatBody = document.getElementById("chat-body");
    const msg = inputField.value.trim();
    if(!msg) return;

    // 1. ADD USER MESSAGE (Right side)
    chatBody.insertAdjacentHTML('beforeend', '<div class="user-msg">' + msg + '</div>');
    inputField.value = "";

    // 2. ADD ANALYZING BUBBLE (Left side)
    const loadingId = "load-" + Date.now();
    chatBody.insertAdjacentHTML('beforeend', '<div id="' + loadingId + '" class="bot-msg">AI is analyzing...</div>');
    chatBody.scrollTop = chatBody.scrollHeight;

    try {
      const response = await fetch("chat-ai", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ message: msg })
      });

      const data = await response.json();

      // 3. TARGET THE BUBBLE BY ID AND CHANGE THE TEXT
      const bubble = document.getElementById(loadingId);
      if(bubble) {
        bubble.innerHTML = "<strong>AI:</strong> " + data.answer;
      }

    } catch (error) {
      document.getElementById(loadingId).innerText = "Error connecting to AI.";
    }
    chatBody.scrollTop = chatBody.scrollHeight;
  }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>