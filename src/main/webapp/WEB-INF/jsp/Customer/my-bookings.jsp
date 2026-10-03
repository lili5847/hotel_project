<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">


<title>My Bookings - Hotel Reservation</title>

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    rel="stylesheet">

<style>
    body {
        background: #f5f7fa;
    }

    .page-header {
        background: linear-gradient(135deg, #0d6efd, #084298);
        color: white;
        padding: 50px 0;
    }

    .booking-card {
        border: none;
        border-radius: 16px;
        box-shadow: 0 4px 18px rgba(0, 0, 0, 0.08);
        overflow: hidden;
    }

    .booking-card:hover {
        transform: translateY(-2px);
        transition: 0.2s ease;
    }

    .booking-header {
        background: #f8f9fa;
        border-bottom: 1px solid #dee2e6;
        padding: 18px 20px;
    }

    .booking-body {
        padding: 20px;
    }

    .info-label {
        color: #6c757d;
        font-size: 0.85rem;
        margin-bottom: 3px;
    }

    .info-value {
        font-weight: 600;
    }

    .status-badge {
        font-size: 0.8rem;
        padding: 7px 12px;
        border-radius: 20px;
    }

    .empty-box {
        background: white;
        border-radius: 16px;
        padding: 60px 20px;
        text-align: center;
        box-shadow: 0 4px 18px rgba(0, 0, 0, 0.06);
    }
</style>

</head>

<body>

<%
String ctx = request.getContextPath();
%>

<nav class="navbar navbar-expand-lg bg-white shadow-sm">
    <div class="container">

    <a class="navbar-brand fw-bold text-primary"
       href="<%= ctx %>/rooms">
        <i class="bi bi-building me-2"></i>
        Hotel Reservation
    </a>

    <button class="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarNav">

        <ul class="navbar-nav ms-auto">

            <li class="nav-item">
                <a class="nav-link"
                   href="<%= ctx %>/rooms">
                    <i class="bi bi-house me-1"></i>
                    Rooms
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link active"
                   href="<%= ctx %>/reservations/my-bookings">
                    <i class="bi bi-calendar-check me-1"></i>
                    My Bookings
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link"
                   href="<%= ctx %>/login">
                    <i class="bi bi-box-arrow-right me-1"></i>
                    Login
                </a>
            </li>

        </ul>

    </div>
</div>


</nav>

<section class="page-header">
    <div class="container">


    <h1 class="fw-bold mb-2">
        <i class="bi bi-calendar-check me-2"></i>
        My Bookings
    </h1>

    <p class="mb-0 opacity-75">
        View and manage your hotel reservations.
    </p>

</div>


</section>

<div class="container py-5">

<c:choose>

    <c:when test="${not empty reservations}">

        <div class="row g-4">

            <c:forEach var="reservation"
                       items="${reservations}">

                <div class="col-12">

                    <div class="booking-card">

                        <div class="booking-header">

                            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">

                                <div>
                                    <span class="text-muted">
                                        Booking ID:
                                    </span>

                                    <strong>
                                        #${reservation.bookingId}
                                    </strong>
                                </div>

                                <c:choose>

                                    <c:when test="${reservation.status == 'CONFIRMED'}">
                                        <span class="badge bg-success status-badge">
                                            <i class="bi bi-check-circle me-1"></i>
                                            Confirmed
                                        </span>
                                    </c:when>

                                    <c:when test="${reservation.status == 'CANCELLED'}">
                                        <span class="badge bg-danger status-badge">
                                            <i class="bi bi-x-circle me-1"></i>
                                            Cancelled
                                        </span>
                                    </c:when>

                                    <c:when test="${reservation.status == 'PENDING'}">
                                        <span class="badge bg-warning text-dark status-badge">
                                            <i class="bi bi-clock me-1"></i>
                                            Pending
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="badge bg-secondary status-badge">
                                            ${reservation.status}
                                        </span>
                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </div>

                        <div class="booking-body">

                            <div class="row g-4">

                                <div class="col-md-4">

                                    <div class="info-label">
                                        <i class="bi bi-door-open me-1"></i>
                                        Room
                                    </div>

                                    <div class="info-value">

                                        <c:choose>

                                            <c:when test="${not empty reservation.room}">

                                                Room ${reservation.room.roomNumber}

                                                <c:if test="${not empty reservation.room.roomType}">
                                                    <div class="text-muted small mt-1">
                                                        ${reservation.room.roomType.typeName}
                                                    </div>
                                                </c:if>

                                            </c:when>

                                            <c:otherwise>
                                                Room information unavailable
                                            </c:otherwise>

                                        </c:choose>

                                    </div>

                                </div>

                                <div class="col-md-2">

                                    <div class="info-label">
                                        <i class="bi bi-calendar-event me-1"></i>
                                        Check-in
                                    </div>

                                    <div class="info-value">
                                        ${reservation.checkIn}
                                    </div>

                                </div>

                                <div class="col-md-2">

                                    <div class="info-label">
                                        <i class="bi bi-calendar-event me-1"></i>
                                        Check-out
                                    </div>

                                    <div class="info-value">
                                        ${reservation.checkOut}
                                    </div>

                                </div>

                                <div class="col-md-2">

                                    <div class="info-label">
                                        <i class="bi bi-people me-1"></i>
                                        Guests
                                    </div>

                                    <div class="info-value">
                                        ${reservation.guests}
                                    </div>

                                </div>

                                <div class="col-md-2">

                                    <div class="info-label">
                                        <i class="bi bi-cash-stack me-1"></i>
                                        Total
                                    </div>

                                    <div class="info-value text-primary">
                                        $${reservation.totalAmount}
                                    </div>

                                </div>

                            </div>

                            <div class="border-top mt-4 pt-3">

                                <div class="d-flex justify-content-end">

                                    <c:if test="${reservation.status != 'CANCELLED'}">

                                        <form method="post"
                                              action="<%= ctx %>/reservations/cancel"
                                              onsubmit="return confirm('Are you sure you want to cancel this booking?');">

                                            <input type="hidden"
                                                   name="bookingId"
                                                   value="${reservation.bookingId}">

                                            <button type="submit"
                                                    class="btn btn-outline-danger">

                                                <i class="bi bi-x-circle me-1"></i>
                                                Cancel Booking

                                            </button>

                                        </form>

                                    </c:if>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            </c:forEach>

        </div>

    </c:when>

    <c:otherwise>

        <div class="empty-box">

            <div class="display-1 text-muted mb-4">
                <i class="bi bi-calendar-x"></i>
            </div>

            <h3 class="fw-bold">
                No Bookings Yet
            </h3>

            <p class="text-muted mb-4">
                You don't have any hotel reservations yet.
            </p>

            <a href="<%= ctx %>/rooms"
               class="btn btn-primary">

                <i class="bi bi-search me-1"></i>
                Browse Rooms

            </a>

        </div>

    </c:otherwise>

</c:choose>


</div>

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>
