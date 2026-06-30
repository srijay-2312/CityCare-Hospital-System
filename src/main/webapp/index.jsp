<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>CityCare Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: #0d6efd;
            color: white;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
            margin: 0;
            overflow: hidden;
        }
        .pulse { animation: pulse-animation 2s infinite; }
        @keyframes pulse-animation {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>

<div class="text-center">
    <i class="fas fa-heartbeat fa-5x mb-3 pulse"></i>
    <h1 class="display-3 fw-bold">CITYCARE PORTAL</h1>
    <p class="lead opacity-75">Your Health, Our Priority</p>
</div>

<script>
    // Wait exactly 2 seconds, then go to the login page
    setTimeout(function() {
        // Using relative path to stay within your project context
        window.location.href = "login";
    }, 2000);
</script>
</body>
</html>