<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1">

<title>Hotel Rooms</title>

<!-- Bootstrap -->
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<!-- Bootstrap Icons -->
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    rel="stylesheet">


<style>

    body {
        background: #f7f8fa;
    }

    .navbar-brand {
        font-weight: 700;
    }

    .hero {
        background: linear-gradient(135deg, #0d6efd, #6f42c1);
        color: white;
        padding: 70px 0 90px;
    }

    .search-card {
        background: white;
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 10px 35px rgba(0, 0, 0, .15);
        margin-top: -50px;
        position: relative;
        z-index: 10;
    }

    .room-card {
        background: white;
        border-radius: 15px;
        overflow: hidden;
        border: 1px solid #e5e7eb;
        height: 100%;
        transition: .2s;
    }

    .room-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 30px rgba(0, 0, 0, .10);
    }

    .room-image {
        height: 200px;
        background: linear-gradient(135deg, #0d6efd, #6f42c1);
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .room-image i {
        font-size: 70px;
        opacity: .85;
    }

    .room-price {
        font-size: 1.4rem;
        font-weight: 700;
        color: #0d6efd;
    }

    .room-info {
        color: #6c757d;
        font-size: .9rem;
    }

    .status-badge {
        font-size: .75rem;
    }

    .empty-box {
        background: white;
        border-radius: 15px;
        padding: 60px 20px;
        text-align: center;
        border: 1px solid #e5e7eb;
    }

    footer {
        margin-top: 80px;
    }

</style>


</head>

<body>

<!-- ===================================================== -->

<!-- NAVBAR -->

<!-- ===================================================== -->

<nav class="navbar navbar-expand-lg bg-white border-bottom">


<div class="container">

    <a class="navbar-brand"
       href="${ctx}/">

        <i class="bi bi-building me-2"></i>

        Hotel

    </a>


    <button
        class="navbar-toggler"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#navbarMenu">

        <span class="navbar-toggler-icon"></span>

    </button>


    <div
        class="collapse navbar-collapse"
        id="navbarMenu">

        <ul class="navbar-nav ms-auto">

            <li class="nav-item">

                <a
                    class="nav-link active"
                    href="${ctx}/">

                    Home

                </a>

            </li>


            <li class="nav-item">

                <a
                    class="nav-link"
                    href="${ctx}/rooms">

                    Rooms

                </a>

            </li>


            <li class="nav-item">

                <a
                    class="nav-link"
                    href="${ctx}/login">

                    Login

                </a>

            </li>


            <li class="nav-item">

                <a
                    class="nav-link"
                    href="${ctx}/register">

                    Register

                </a>

            </li>

        </ul>

    </div>

</div>

</nav>

<!-- ===================================================== -->

<!-- HERO -->

<!-- ===================================================== -->

<section class="hero">


<div class="container text-center">

    <h1 class="display-4 fw-bold">

        Find Your Perfect Room

    </h1>


    <p class="lead mt-3">

        Comfortable rooms for a relaxing stay.

    </p>

</div>


</section>

<!-- ===================================================== -->

<!-- SIMPLE SEARCH -->

<!-- ===================================================== -->

<div class="container">


<div class="search-card">

    <form action="${ctx}/rooms"
          method="get">

        <div class="row g-3 align-items-end">


            <div class="col-md-4">

                <label
                    for="checkIn"
                    class="form-label fw-semibold">

                    Check-in

                </label>

                <input
                    type="date"
                    id="checkIn"
                    name="checkIn"
                    class="form-control">

            </div>


            <div class="col-md-4">

                <label
                    for="checkOut"
                    class="form-label fw-semibold">

                    Check-out

                </label>

                <input
                    type="date"
                    id="checkOut"
                    name="checkOut"
                    class="form-control">

            </div>


            <div class="col-md-2">

                <label
                    for="guests"
                    class="form-label fw-semibold">

                    Guests

                </label>

                <select
                    id="guests"
                    name="guests"
                    class="form-select">

                    <option value="1">1 Guest</option>
                    <option value="2">2 Guests</option>
                    <option value="3">3 Guests</option>
                    <option value="4">4 Guests</option>
                    <option value="5">5 Guests</option>
                    <option value="6">6 Guests</option>

                </select>

            </div>


            <div class="col-md-2">

                <button
                    type="submit"
                    class="btn btn-primary w-100">

                    <i class="bi bi-search me-1"></i>

                    Search

                </button>

            </div>

        </div>

    </form>

</div>


</div>

<!-- ===================================================== -->

<!-- ROOMS -->

<!-- ===================================================== -->

<main class="container py-5">

```
<div class="d-flex
            justify-content-between
            align-items-center
            mb-4">

    <div>

        <h2 class="fw-bold mb-1">

            Available Rooms

        </h2>


        <c:choose>

            <c:when test="${empty rooms}">

                <p class="text-muted mb-0">

                    No rooms available.

                </p>

            </c:when>


            <c:otherwise>

                <p class="text-muted mb-0">

                    ${rooms.size()} room(s) available

                </p>

            </c:otherwise>

        </c:choose>

    </div>

</div>



<!-- ================================================= -->
<!-- NO ROOMS -->
<!-- ================================================= -->

<c:if test="${empty rooms}">

    <div class="empty-box">

        <i
            class="bi bi-door-closed"
            style="font-size: 60px; color: #6c757d;">
        </i>


        <h4 class="mt-4">

            No Rooms Found

        </h4>


        <p class="text-muted">

            There are currently no rooms available.

        </p>


        <a
            href="${ctx}/"
            class="btn btn-primary">

            Back to Home

        </a>

    </div>

</c:if>



<!-- ================================================= -->
<!-- ROOM LIST -->
<!-- ================================================= -->

<c:if test="${not empty rooms}">

    <div class="row g-4">


        <c:forEach
            var="room"
            items="${rooms}">


            <div class="col-md-6 col-lg-4">


                <div class="room-card">


                    <!-- IMAGE -->

                    <div class="room-image">

                        <i class="bi bi-building"></i>

                    </div>



                    <!-- BODY -->

                    <div class="p-4">


                        <!-- TITLE -->

                        <div class="d-flex
                                    justify-content-between
                                    align-items-start">

                            <div>

                                <h4 class="mb-1">

                                    ${room.roomType.typeName}

                                </h4>


                                <div class="text-muted">

                                    Room ${room.roomNumber}

                                </div>

                            </div>


                            <c:choose>

                                <c:when
                                    test="${room.status == 'AVAILABLE'}">

                                    <span
                                        class="badge bg-success status-badge">

                                        Available

                                    </span>

                                </c:when>


                                <c:otherwise>

                                    <span
                                        class="badge bg-secondary status-badge">

                                        ${room.status}

                                    </span>

                                </c:otherwise>

                            </c:choose>

                        </div>



                        <hr>



                        <!-- PRICE -->

                        <div class="room-price">

                            $${room.roomType.price}

                            <span
                                class="text-muted fs-6 fw-normal">

                                / night

                            </span>

                        </div>



                        <!-- INFO -->

                        <div class="room-info mt-3">


                            <div class="mb-2">

                                <i
                                    class="bi bi-people me-2">
                                </i>

                                ${room.roomType.capacity}
                                guest(s)

                            </div>


                            <div class="mb-2">

                                <i
                                    class="bi bi-layers me-2">
                                </i>

                                Floor ${room.floor}

                            </div>


                            <c:if
                                test="${not empty room.roomType.amenities}">

                                <div>

                                    <i
                                        class="bi bi-stars me-2">
                                    </i>

                                    ${room.roomType.amenities}

                                </div>

                            </c:if>

                        </div>



                        <!-- DESCRIPTION -->

                        <c:if
                            test="${not empty room.description}">

                            <p class="text-muted small mt-3 mb-0">

                                ${room.description}

                            </p>

                        </c:if>




						<!-- BUTTONS -->
						<div class="d-grid gap-2 mt-4">
						
						    <!-- View Details -->
						    <a href="${pageContext.request.contextPath}/room-detail?id=${room.roomId}"
						       class="btn btn-outline-primary">
						        <i class="bi bi-eye me-1"></i>
						        View Details
						    </a>
						
						    <!-- Book Room -->
						    <c:choose>
						
						        <c:when test="${room.status == 'AVAILABLE'}">
						
						            <a href="${pageContext.request.contextPath}/reservations/book?roomId=${room.roomId}"
						               class="btn btn-success">
						                <i class="bi bi-calendar-check me-1"></i>
						                Book Now
						            </a>
						
						        </c:when>
						
						        <c:otherwise>
						
						            <button type="button"
						                    class="btn btn-secondary"
						                    disabled>
						                <i class="bi bi-lock me-1"></i>
						                Not Available
						            </button>
						
						        </c:otherwise>
						
						    </c:choose>
						
						</div>

                    </div>

                </div>

            </div>
    </div>


        </c:forEach>

    </div>

</c:if>


</main>

<!-- ===================================================== -->

<!-- FOOTER -->

<!-- ===================================================== -->

<footer class="bg-dark text-white py-5">


<div class="container text-center">

    <i
        class="bi bi-building"
        style="font-size: 30px;">
    </i>


    <h5 class="mt-2">

        Hotel Reservation System

    </h5>


    <p class="text-secondary mb-0">

        Comfortable rooms. Easy reservations.

    </p>


    <small class="text-secondary">

        © 2026 Hotel. All rights reserved.

    </small>

</div>

</footer>

<!-- Bootstrap JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

<!-- ===================================================== -->

<!-- BOOKING JAVASCRIPT -->

<!-- ===================================================== -->

<script>

async function bookRoom(roomId) {

    /*
     * Check whether the customer is logged in.
     */

    const token =
        localStorage.getItem('token');


    if (!token) {

        alert(
            'សូម Login ជាមុនសិន ដើម្បីកក់បន្ទប់។'
        );

        window.location.href =
            '${ctx}/login';

        return;
    }


    /*
     * Get dates from the search area.
     */

    const checkInElement =
        document.getElementById('checkIn');

    const checkOutElement =
        document.getElementById('checkOut');

    const guestsElement =
        document.getElementById('guests');


    const checkIn =
        checkInElement
            ? checkInElement.value
            : '';


    const checkOut =
        checkOutElement
            ? checkOutElement.value
            : '';


    const guests =
        guestsElement
            ? parseInt(guestsElement.value)
            : 1;


    /*
     * Validate dates.
     */

    if (!checkIn || !checkOut) {

        alert(
            'សូមជ្រើសរើសថ្ងៃ Check-in និង Check-out ជាមុនសិន។'
        );

        return;
    }


    if (checkIn >= checkOut) {

        alert(
            'Check-out ត្រូវតែបន្ទាប់ពី Check-in។'
        );

        return;
    }


    /*
     * Send reservation to backend.
     */

    const reservationData = {

        roomId: Number(roomId),

        checkIn: checkIn,

        checkOut: checkOut,

        guests: guests

    };


    try {

        const response = await fetch(
            '${ctx}/api/reservations',
            {

                method: 'POST',

                headers: {

                    'Content-Type':
                        'application/json',

                    'Authorization':
                        'Bearer ' + token

                },

                body:
                    JSON.stringify(reservationData)

            }
        );


        /*
         * Successful booking.
         */

        if (response.ok) {

            alert(
                'ការកក់បន្ទប់ទទួលបានជោគជ័យ!'
