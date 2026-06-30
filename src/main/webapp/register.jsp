<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up - City Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #198754 0%, #20c997 100%); height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Inter', sans-serif; }
        .register-card { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.2); width: 100%; max-width: 450px; }
    </style>
</head>
<body>

<div class="register-card">
    <h3 class="text-center fw-bold text-success mb-2">Create Account</h3>
    <p class="text-center text-muted small mb-4">Join City Hospital Patient Portal</p>
    <% if ("taken".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger p-2 small text-center">
        <i class="fas fa-exclamation-circle me-1"></i> Username already taken! Try another.
    </div>
    <% } %>

    <% if ("1".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger p-2 small text-center">Registration failed. Please try again.</div>
    <% } %>
    <form action="register" method="post">
        <div class="mb-3">
            <label class="form-label small fw-bold">Full Name</label>
            <input type="text" class="form-control" name="fullName" placeholder="e.g. John Doe" required>
        </div>
        <div class="mb-3">
            <label class="form-label small fw-bold">Username</label>
            <input type="text" class="form-control" name="username" required>
        </div>
        <div class="mb-3">
            <label class="form-label small fw-bold">Password</label>
            <input type="password" class="form-control" name="password" required>
        </div>
        <div class="mb-3">
            <!-- Added small fw-bold to match your other labels -->
            <label class="form-label small fw-bold">Email Address</label>
            <input type="email" class="form-control" name="email" required>
        </div>
        <button type="submit" class="btn btn-success w-100 py-2 fw-bold shadow-sm">Register Now</button>
    </form>

    <div class="mt-4 text-center">
        <span class="small text-muted">Already have an account?</span>
        <a href="login.jsp" class="small fw-bold text-success text-decoration-none">Login here</a>
    </div>
</div>

</body>
</html>