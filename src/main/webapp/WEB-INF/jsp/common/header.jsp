<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${empty param.title ? 'Welcome' : param.title}" /> | Hotel Reservation</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Newsreader:opsz,wght@6..72,500;6..72,600&family=Public+Sans:wght@400;500;600&display=swap" rel="stylesheet">

    <!-- Bootstrap 5.3 + Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <!-- Project styles -->
    <link href="${ctx}/assets/css/style.css" rel="stylesheet">
</head>
<body class="d-flex flex-column min-vh-100">

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${ctx}/index.jsp">
            <i class="bi bi-building fs-4 text-primary"></i>
            <span class="fw-bold">Hotel Reservation</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain" aria-controls="navbarMain" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${ctx}/index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${ctx}/rooms.jsp">Rooms</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${ctx}/about.jsp">About Us</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${ctx}/contact.jsp">Contact</a>
                </li>
            </ul>

            <!-- Dynamic User Authentication Nav -->
            <div class="d-flex align-items-center gap-2" id="navAuthArea">
                <a href="${ctx}/login.jsp" class="btn btn-outline-primary btn-sm">Log in</a>
                <a href="${ctx}/register.jsp" class="btn btn-primary btn-sm">Sign up</a>
            </div>
        </div>
    </div>
</nav>

<!-- ============================================================
     JAVASCRIPT FETCH API INTEGRATION FOR USER SESSION
     ============================================================ -->
<script>
    const ctxPath = "${ctx}";

    document.addEventListener("DOMContentLoaded", function () {
        checkUserAuthStatus();
    });

    function checkUserAuthStatus() {
        const token = localStorage.getItem('accessToken');
        if (!token) return;

        fetch(`${ctxPath}/api/auth/me`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (response.ok) return response.json();
                throw new Error('Not authenticated');
            })
            .then(user => {
                if (user && user.fullName) {
                    renderUserNav(user);
                }
            })
            .catch(error => {
                console.warn('Session expired or user not logged in via API:', error);
            });
    }

    function renderUserNav(user) {
        const navAuthArea = document.getElementById('navAuthArea');
        if (!navAuthArea) return;

        const isAdmin = user.role === 'ADMIN';
        const dashboardUrl = isAdmin ? `${ctxPath}/admin/dashboard.jsp` : `${ctxPath}/my-reservations.jsp`;

        navAuthArea.innerHTML = `
        <div class="dropdown">
            <button class="btn btn-outline-secondary btn-sm dropdown-toggle d-flex align-items-center gap-2" type="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-person-circle"></i>
                <span>\${escapeHtml(user.fullName)}</span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" href="${dashboardUrl}"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="#" onclick="handleHeaderLogout(event)"><i class="bi bi-box-arrow-right me-2"></i>Log out</a></li>
            </ul>
        </div>
    `;
    }

    function handleHeaderLogout(event) {
        event.preventDefault();
        const token = localStorage.getItem('accessToken');

        fetch(`${ctxPath}/api/auth/logout`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .finally(() => {
                localStorage.removeItem('accessToken');
                sessionStorage.clear();
                window.location.href = `${ctxPath}/login.jsp`;
            });
    }

    function escapeHtml(str) {
        return String(str || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }
</script>