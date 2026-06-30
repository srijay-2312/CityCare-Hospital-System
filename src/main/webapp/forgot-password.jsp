<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reset Password - City Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #6c757d 0%, #495057 100%); height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Inter', sans-serif; }
        .reset-card { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.2); width: 100%; max-width: 400px; }
    </style>
</head>
<body>
<div class="reset-card">
    <h4 class="text-center fw-bold mb-3">Recover Account</h4>
    <p class="text-center text-muted small mb-4">Enter details to set a new password</p>

    <form action="forgot-password" method="post">
        <div class="mb-3">
            <label class="form-label small fw-bold">Username</label>
            <input type="text" class="form-control" name="username" required>
        </div>
        <div class="mb-3">
            <label class="form-label small fw-bold">Your Registered Full Name</label>
            <input type="text" class="form-control" name="fullName" required>
        </div>
        <div class="mb-3">
            <label class="form-label small fw-bold">New Password</label>
            <input type="password" class="form-control" name="newPassword" required>
        </div>
        <button type="submit" class="btn btn-dark w-100 py-2 fw-bold">Reset Password</button>
    </form>

    <div class="mt-4 text-center">
        <a href="login.jsp" class="small text-decoration-none">Back to Login</a>
    </div>
</div>
</body>
</html>