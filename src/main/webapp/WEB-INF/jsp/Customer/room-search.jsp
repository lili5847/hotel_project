<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>
<%--<%@ taglib prefix="c" uri="jakarta.tags.core" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="km">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <title>ស្វែងរកបន្ទប់ - Hotel Reservation</title>--%>
<%--    <!-- Bootstrap 5 CSS -->--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--    <!-- Font Awesome Icons -->--%>
<%--    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">--%>
<%--    <style>--%>
<%--        body { font-family: 'Kantumruy Pro', sans-serif; background-color: #f8f9fa; }--%>
<%--        .hero-section { background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('https://images.unsplash.com/photo-1566073771259-6a8506099945') center/cover; color: white; padding: 60px 0; }--%>
<%--        .card-room { transition: transform 0.2s; border: none; border-radius: 12px; }--%>
<%--        .card-room:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>

<%--<!-- Header / Navbar -->--%>
<%--<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">--%>
<%--    <div class="container">--%>
<%--        <a class="navbar-brand fw-bold" href="/rooms"><i class="fa-solid fa-hotel me-2"></i>GRAND HOTEL</a>--%>
<%--        <div class="collapse navbar-collapse" id="navbarNav">--%>
<%--            <ul class="navbar-brand ms-auto navbar-nav">--%>
<%--                <li class="nav-item"><a class="nav-link active" href="/rooms">បន្ទប់ទាំងអស់</a></li>--%>
<%--                <li class="nav-item"><a class="nav-link" href="/reservations/my-bookings">ការកក់របស់ខ្ញុំ</a></li>--%>
<%--                <li class="nav-item"><a class="btn btn-outline-light ms-2" href="/login">ចូលប្រើប្រាស់</a></li>--%>
<%--            </ul>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</nav>--%>

<%--<!-- Hero Search Bar -->--%>
<%--<div class="hero-section text-center mb-5">--%>
<%--    <div class="container">--%>
<%--        <h1 class="fw-bold mb-3">ស្វែងរកបន្ទប់ស្នាក់នៅដ៏សមស្របសម្រាប់អ្នក</h1>--%>
<%--        <p class="lead">បទពិសោធន៍ស្នាក់នៅកម្រិតបរមសុខជាមួយសេវាកម្មដ៏ល្អឥតខ្ចោះ</p>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- Room Cards Container -->--%>
<%--<div class="container mb-5">--%>
<%--    <div class="row g-4">--%>
<%--        <c:forEach var="room" items="${rooms}">--%>
<%--            <div class="col-md-4">--%>
<%--                <div class="card card-room h-100 shadow-sm">--%>
<%--                    <img src="https://images.unsplash.com/photo-1611892440504-42a792e24d32" class="card-img-top" style="height: 220px; object-fit: cover;" alt="Room">--%>
<%--                    <div class="card-body">--%>
<%--                        <div class="d-flex justify-content-between align-items-center mb-2">--%>
<%--                            <span class="badge bg-primary fs-6">${room.roomType.typeName}</span>--%>
<%--                            <span class="fw-bold text-success fs-5">$${room.roomType.price}/យប់</span>--%>
<%--                        </div>--%>
<%--                        <h5 class="card-title fw-bold">បន្ទប់លេខ ${room.roomNumber}</h5>--%>
<%--                        <p class="card-text text-muted">${room.description}</p>--%>
<%--                        <div class="text-secondary small mb-3">--%>
<%--                            <i class="fa-solid fa-layer-group me-1"></i>ជាន់ទី ${room.floor} |--%>
<%--                            <i class="fa-solid fa-wifi me-1"></i>${room.roomType.amenities}--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                    <div class="card-footer bg-transparent border-0 pb-3">--%>
<%--                        <a href="/reservations/book?roomId=${room.roomId}" class="btn btn-dark w-100 fw-bold">--%>
<%--                            <i class="fa-regular fa-calendar-check me-2"></i>កក់បន្ទប់នេះ--%>
<%--                        </a>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </c:forEach>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>--%>
<%--</body>--%>
<%--</html>--%>