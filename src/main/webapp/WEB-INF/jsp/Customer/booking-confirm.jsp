
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Book Room - Hotel Reservation</title>

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
            padding: 45px 0;
        }

        .booking-card {
            background: white;
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .room-image {
            width: 100%;
            height: 320px;
            object-fit: cover;
            display: block;
        }

        .room-image-placeholder {
            height: 320px;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            font-size: 5rem;
        }

        .summary-label {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .summary-value {
            font-weight: 600;
        }

        .total-price {
            font-size: 1.4rem;
            font-weight: 700;
            color: #0d6efd;
        }

    </style>

</head>

<body>

<%
    String ctx = request.getContextPath();
%>

<!-- NAVBAR -->

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

        <div class="collapse navbar-collapse"
             id="navbarNav">

            <ul class="navbar-nav ms-auto">

                <li class="nav-item">

                    <a class="nav-link"
                       href="<%= ctx %>/rooms">

                        <i class="bi bi-house me-1"></i>
                        Rooms

                    </a>

                </li>

                <li class="nav-item">

                    <a class="nav-link"
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


<!-- HEADER -->

<section class="page-header">

    <div class="container">

        <h1 class="fw-bold mb-2">

            <i class="bi bi-calendar-plus me-2"></i>
            Book Your Room

        </h1>

        <p class="mb-0 opacity-75">

            Complete the information below to make your reservation.

        </p>

    </div>

</section>


<!-- CONTENT -->

<div class="container py-5">

    <c:if test="${not empty error}">

        <div class="alert alert-danger">

            <i class="bi bi-exclamation-triangle me-2"></i>

            ${error}

        </div>

    </c:if>


    <c:choose>

        <c:when test="${not empty room}">

            <div class="row g-4">

                <!-- ROOM INFORMATION -->

                <div class="col-lg-6">

                    <div class="booking-card">

                        <c:choose>

                            <c:when test="${not empty room.roomType
                                           and not empty room.roomType.imageUrl}">

                                <img
                                    src="<%= ctx %>${room.roomType.imageUrl}"
                                    alt="Room ${room.roomNumber}"
                                    class="room-image">

                            </c:when>

                            <c:otherwise>

                                <div class="room-image-placeholder">

                                    <i class="bi bi-door-open"></i>

                                </div>

                            </c:otherwise>

                        </c:choose>


                        <div class="p-4">

                            <span class="badge bg-primary mb-2">

                                ${room.roomType.typeName}

                            </span>

                            <h3 class="fw-bold">

                                Room ${room.roomNumber}

                            </h3>

                            <p class="text-muted mb-3">

                                ${room.description}

                            </p>


                            <div class="row g-3">

                                <div class="col-6">

                                    <div class="summary-label">

                                        <i class="bi bi-building me-1"></i>
                                        Floor

                                    </div>

                                    <div class="summary-value">

                                        ${room.floor}

                                    </div>

                                </div>


                                <div class="col-6">

                                    <div class="summary-label">

                                        <i class="bi bi-cash-stack me-1"></i>
                                        Price / Night

                                    </div>

                                    <div class="summary-value text-primary">

                                        $${room.roomType.price}

                                    </div>

                                </div>


                                <div class="col-12">

                                    <div class="summary-label">

                                        <i class="bi bi-info-circle me-1"></i>
                                        Status

                                    </div>

                                    <div class="summary-value">

                                        ${room.status}

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- BOOKING FORM -->

                <div class="col-lg-6">

                    <div class="booking-card">

                        <div class="p-4">

                            <h3 class="fw-bold mb-4">

                                Reservation Details

                            </h3>


                            <form
                                method="post"
                                action="<%= ctx %>/reservations/book">


                                <input
                                    type="hidden"
                                    name="roomId"
                                    value="${room.roomId}">


                                <!-- CHECK IN -->

                                <div class="mb-3">

                                    <label
                                        for="checkIn"
                                        class="form-label fw-semibold">

                                        Check-in Date

                                    </label>

                                    <input
                                        type="date"
                                        class="form-control"
                                        id="checkIn"
                                        name="checkIn"
                                        required>

                                </div>


                                <!-- CHECK OUT -->

                                <div class="mb-3">

                                    <label
                                        for="checkOut"
                                        class="form-label fw-semibold">

                                        Check-out Date

                                    </label>

                                    <input
                                        type="date"
                                        class="form-control"
                                        id="checkOut"
                                        name="checkOut"
                                        required>

                                </div>


                                <!-- GUESTS -->

                                <div class="mb-4">

                                    <label
                                        for="guests"
                                        class="form-label fw-semibold">

                                        Number of Guests

                                    </label>

                                    <input
                                        type="number"
                                        class="form-control"
                                        id="guests"
                                        name="guests"
                                        min="1"
                                        max="10"
                                        value="1"
                                        required>

                                </div>


                                <!-- PRICE -->

                                <div class="border-top pt-3 mb-4">

                                    <div class="d-flex justify-content-between mb-2">

                                        <span class="text-muted">

                                            Price per night

                                        </span>

                                        <strong>

                                            $${room.roomType.price}

                                        </strong>

                                    </div>

                                    <div class="d-flex justify-content-between mb-2">

                                        <span class="text-muted">

                                            Nights

                                        </span>

                                        <strong id="nights">

                                            0

                                        </strong>

                                    </div>

                                    <div class="d-flex justify-content-between">

                                        <span class="fw-semibold">

                                            Estimated Total

                                        </span>

                                        <span
                                            class="total-price">

                                            $<span id="total">0.00</span>

                                        </span>

                                    </div>

                                </div>


                                <!-- BUTTONS -->

                                <div class="d-flex gap-2">

                                    <a
                                        href="<%= ctx %>/room-detail?id=${room.roomId}"
                                        class="btn btn-outline-secondary flex-fill">

                                        <i class="bi bi-arrow-left me-1"></i>
                                        Back

                                    </a>


                                    <button
                                        type="submit"
                                        class="btn btn-primary flex-fill">

                                        <i class="bi bi-check-circle me-1"></i>
                                        Confirm Booking

                                    </button>

                                </div>

                            </form>

                        </div>

                    </div>

                </div>

            </div>

        </c:when>


        <c:otherwise>

            <div class="alert alert-warning">

                <i class="bi bi-exclamation-triangle me-2"></i>

                Room information could not be found.

                <a
                    href="<%= ctx %>/rooms"
                    class="alert-link">

                    Return to rooms

                </a>

            </div>

        </c:otherwise>

    </c:choose>

</div>


<script>

    const checkIn = document.getElementById("checkIn");
    const checkOut = document.getElementById("checkOut");
    const nightsElement = document.getElementById("nights");
    const totalElement = document.getElementById("total");

    const pricePerNight =
        Number("${room.roomType.price}") || 0;


    function calculateTotal() {

        if (!checkIn || !checkOut) {
            return;
        }

        const start = new Date(checkIn.value);
        const end = new Date(checkOut.value);

        if (!checkIn.value || !checkOut.value || end <= start) {

            nightsElement.textContent = "0";
            totalElement.textContent = "0.00";

            return;
        }

        const difference =
            end.getTime() - start.getTime();

        const nights =
            Math.ceil(difference / (1000 * 60 * 60 * 24));

        nightsElement.textContent = nights;

        totalElement.textContent =
            (nights * pricePerNight).toFixed(2);
    }


    if (checkIn && checkOut) {

        checkIn.addEventListener(
            "change",
            calculateTotal
        );

        checkOut.addEventListener(
            "change",
            calculateTotal
        );

    }

</script>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>

