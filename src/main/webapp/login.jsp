<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - City Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #007bff 0%, #00d4ff 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }
        .hospital-logo {
            font-size: 50px;
            text-align: center;
            display: block;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<!-- Splash Screen -->
<div id="app-splash" style="position:fixed; top:0; left:0; width:100%; height:100%; background:#0d6efd; color:white; display:flex; flex-direction:column; align-items:center; justify-content:center; z-index:999999; transition: opacity 0.8s;">
    <i class="fas fa-hospital-symbol fa-4x mb-3 animate-pulse"></i>
    <h1 class="fw-bold">CITYCARE HOSPITAL</h1>
    <p class="small text-light">Loading Secure Environment...</p>
</div>

<script>
    window.addEventListener("load", () => {
        setTimeout(() => {
            const splash = document.getElementById("app-splash");
            splash.style.opacity = "0";
            setTimeout(() => splash.remove(), 800);
        }, 2000); // 2 seconds
    });
</script>
<div class="login-card">
    <span class="hospital-logo">🏥</span>
    <h3 class="text-center mb-4">Hospital Portal</h3>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger p-2 small text-center"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if ("true".equals(request.getParameter("registered"))) { %>
    <div class="alert alert-success p-2 small text-center">Registration Successful! Please login.</div>
    <% } %>

    <div class="mt-3 text-center">
        <span class="small text-muted">New patient?</span>
        <a href="register.jsp" class="small fw-bold text-primary text-decoration-none">Create Account</a>
    </div>
    <form action="login" method="post">
        <div class="mb-3">
            <label for="username" class="form-label">Email Address</label>
            <input type="email" class="form-control" id="username" name="username" placeholder="" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <button type="submit" class="btn btn-primary w-100 py-2">Login</button>
    </form>

    <div class="mt-4 pt-3 border-top text-center">
        <p class="text-muted x-small" style="font-size: 0.8rem;">
            &copy; 2026 City Hospital Healthcare Systems.<br>
            Authorized Personnel Only.
        </p>
        <a href="forgot-password.jsp" class="text-decoration-none small">Forgot Password?</a>    </div>
</div> <!-- End of login-card -->

</body>
</html>