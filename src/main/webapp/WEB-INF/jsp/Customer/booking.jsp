
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Book Room - Hotel Reservation</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>

        body {
            background-color: #f5f7fa;
        }

        .booking-container {
            max-width: 1100px;
            margin: 50px auto;
        }

        .booking-card {
            border: none;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.08);
        }

        .room-image {
            min-height: 420px;
            background: linear-gradient(
                135deg,
                #e9ecef,
                #ced4da
            );

            display: flex;
            align-items: center;
            justify-content: center;

            overflow: hidden;
        }

        .room-image img {
            width: 100%;
            height: 420px;
            object-fit: cover;
        }

        .room-image-placeholder {
            font-size: 90px;
            color: #6c757d;
        }

        .room-info {
            padding: 30px;
        }

        .booking-form {
            padding: 30px;
        }

        .price {
            font-size: 28px;
            font-weight: 700;
            color: #198754;
        }

        .form-label {
            font-weight: 600;
        }

        .summary-box {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
        }

        .total-price {
            font-size: 24px;
            font-weight: 700;
            color: #198754;
        }

        .btn-book {
            padding: 12px;
            font-size: 17px;
            font-weight: 600;
        }

    </style>

</head>


<body>


<!-- NAVBAR -->

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">

    <div class="container">

        <a class="navbar-brand"
           href="${pageContext.request.contextPath}/rooms">

            <i class="bi bi-building me-2"></i>
            Hotel Reservation

        </a>


        <button
            class="navbar-toggler"
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
                       href="${pageContext.request.contextPath}/rooms">

                        <i class="bi bi-house me-1"></i>
                        Rooms

                    </a>

                </li>


                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/reservations/my-bookings">

                        <i class="bi bi-calendar-check me-1"></i>
                        My Bookings

                    </a>

                </li>

            </ul>

        </div>

    </div>

</nav>



<div class="container booking-container">


    <!-- ERROR -->

    <c:if test="${not empty error}">

        <div class="alert alert-danger alert-dismissible fade show"
             role="alert">

            <i class="bi bi-exclamation-triangle-fill me-2"></i>

            ${error}

            <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert">
            </button>

        </div>

    </c:if>



    <!-- ROOM NOT FOUND -->

    <c:if test="${empty room}">

        <div class="card booking-card">

            <div class="card-body text-center p-5">

                <i class="bi bi-door-closed text-danger"
                   style="font-size: 70px;">
                </i>

                <h2 class="mt-3">
                    Room Not Found
                </h2>

                <p class="text-muted">
                    The selected room could not be found.
                </p>

                <a
                    href="${pageContext.request.contextPath}/rooms"
                    class="btn btn-primary">

                    <i class="bi bi-arrow-left me-1"></i>
                    Back to Rooms

                </a>

            </div>

        </div>

    </c:if>



    <!-- ROOM FOUND -->

    <c:if test="${not empty room}">

        <div class="card booking-card">

            <div class="row g-0">


                <!-- ROOM INFORMATION -->

                <div class="col-lg-6">


                    <!-- ROOM IMAGE -->

                    <div class="room-image">

                        <c:choose>
						    <c:when test="${not empty room.roomType.imageUrl}">
						        <img src="${pageContext.request.contextPath}${room.roomType.imageUrl}"
						             alt="Room ${room.roomNumber}"
						             class="room-image">
						    </c:when>
						
						    <c:otherwise>
						        <div class="room-image-placeholder">
						            <i class="bi bi-door-open"></i>
						        </div>
						    </c:otherwise>
						</c:choose>

                    </div>


                    <div class="room-info">

                        <div class="d-flex justify-content-between align-items-start">

                            <div>

                                <h2 class="fw-bold mb-2">
                                    Room ${room.roomNumber}
                                </h2>

                                <h5 class="text-primary">
                                    ${room.roomType.typeName}
                                </h5>

                            </div>


                            <c:choose>

                                <c:when test="${room.status == 'AVAILABLE'}">

                                    <span class="badge bg-success">
                                        Available
                                    </span>

                                </c:when>

                                <c:otherwise>

                                    <span class="badge bg-secondary">
                                        ${room.status}
                                    </span>

                                </c:otherwise>

                            </c:choose>

                        </div>


                        <hr>


                        <!-- PRICE -->

                        <div class="mb-3">

                            <small class="text-muted">
                                Price per night
                            </small>

                            <div class="price">
                                $${room.roomType.price}
                            </div>

                        </div>


                        <!-- CAPACITY -->

                        <div class="mb-3">

                            <i class="bi bi-people me-2"></i>

                            <strong>Capacity:</strong>

                            ${room.roomType.capacity}
                            guests

                        </div>


                        <!-- FLOOR -->

                        <div class="mb-3">

                            <i class="bi bi-building me-2"></i>

                            <strong>Floor:</strong>

                            ${room.floor}

                        </div>


                        <!-- AMENITIES -->

                        <c:if test="${not empty room.roomType.amenities}">

                            <div class="mb-3">

                                <i class="bi bi-stars me-2"></i>

                                <strong>Amenities:</strong>

                                <div class="text-muted mt-1">

                                    ${room.roomType.amenities}

                                </div>

                            </div>

                        </c:if>


                        <!-- DESCRIPTION -->

                        <c:if test="${not empty room.description}">

                            <div class="mt-4">

                                <h6 class="fw-bold">
                                    Description
                                </h6>

                                <p class="text-muted">
                                    ${room.description}
                                </p>

                            </div>

                        </c:if>

                    </div>

                </div>



                <!-- BOOKING FORM -->

                <div class="col-lg-6">

                    <div class="booking-form">

                        <h3 class="fw-bold mb-4">

                            <i class="bi bi-calendar-check me-2"></i>

                            Book This Room

                        </h3>


                        <form
                            method="post"
                            action="${pageContext.request.contextPath}/reservations/book"
                            id="bookingForm">


                            <!-- ROOM ID -->

                            <input
                                type="hidden"
                                name="roomId"
                                value="${room.roomId}">


                            <!-- CHECK-IN -->

                            <div class="mb-3">

                                <label
                                    for="checkIn"
                                    class="form-label">

                                    Check-in Date

                                </label>

                                <input
                                    type="date"
                                    id="checkIn"
                                    name="checkIn"
                                    class="form-control"
                                    required>

                                <div class="form-text">
                                    Select your arrival date.
                                </div>

                            </div>


                            <!-- CHECK-OUT -->

                            <div class="mb-3">

                                <label
                                    for="checkOut"
                                    class="form-label">

                                    Check-out Date

                                </label>

                                <input
                                    type="date"
                                    id="checkOut"
                                    name="checkOut"
                                    class="form-control"
                                    required>

                                <div class="form-text">
                                    Select your departure date.
                                </div>

                            </div>


                            <!-- GUESTS -->

                            <div class="mb-4">

                                <label
                                    for="guests"
                                    class="form-label">

                                    Number of Guests

                                </label>

                                <input
                                    type="number"
                                    id="guests"
                                    name="guests"
                                    class="form-control"
                                    value="1"
                                    min="1"
                                    max="${room.roomType.capacity}"
                                    required>

                                <div class="form-text">

                                    Maximum:
                                    ${room.roomType.capacity}
                                    guests

                                </div>

                            </div>


                            <!-- SUMMARY -->

                            <div class="summary-box mb-4">

                                <h6 class="fw-bold mb-3">
                                    Booking Summary
                                </h6>


                                <div class="d-flex justify-content-between mb-2">

                                    <span>
                                        Room
                                    </span>

                                    <strong>
                                        ${room.roomNumber}
                                    </strong>

                                </div>


                                <div class="d-flex justify-content-between mb-2">

                                    <span>
                                        Room Type
                                    </span>

                                    <strong>
                                        ${room.roomType.typeName}
                                    </strong>

                                </div>


                                <div class="d-flex justify-content-between">

                                    <span>
                                        Price / Night
                                    </span>

                                    <strong>
                                        $${room.roomType.price}
                                    </strong>

                                </div>


                                <hr>


                                <div class="d-flex justify-content-between">

                                    <span class="fw-bold">
                                        Estimated Total
                                    </span>

                                    <span
                                        id="totalPrice"
                                        class="total-price">

                                        $0.00

                                    </span>

                                </div>


                                <small class="text-muted">

                                    Total is calculated from
                                    check-in and check-out dates.

                                </small>

                            </div>


                            <!-- BUTTONS -->

                            <div class="d-grid gap-2">

                                <button
                                    type="submit"
                                    class="btn btn-success btn-book">

                                    <i class="bi bi-check-circle me-2"></i>

                                    Confirm Booking

                                </button>


                                <a
                                    href="${pageContext.request.contextPath}/room-detail?id=${room.roomId}"
                                    class="btn btn-outline-secondary">

                                    <i class="bi bi-arrow-left me-1"></i>

                                    Back to Room

                                </a>

                            </div>


                        </form>

                    </div>

                </div>

            </div>

        </div>

    </c:if>

</div>



<script>

    const checkInInput =
        document.getElementById("checkIn");

    const checkOutInput =
        document.getElementById("checkOut");

    const totalPriceElement =
        document.getElementById("totalPrice");

    const pricePerNight =
        Number("${room.roomType.price}");

    const capacity =
        Number("${room.roomType.capacity}");


    const today =
        new Date().toISOString().split("T")[0];


    if (checkInInput) {

        checkInInput.min = today;

    }


    if (checkOutInput) {

        checkOutInput.min = today;

    }


    if (checkInInput) {

        checkInInput.addEventListener(
            "change",
            function () {

                if (checkOutInput) {

                    checkOutInput.min =
                        this.value;

                    if (
                        checkOutInput.value &&
                        checkOutInput.value <= this.value
                    ) {

                        checkOutInput.value = "";

                    }

                }

                calculateTotal();

            }
        );

    }


    if (checkOutInput) {

        checkOutInput.addEventListener(
            "change",
            calculateTotal
        );

    }


    function calculateTotal() {

        if (
            !checkInInput ||
            !checkOutInput ||
            !checkInInput.value ||
            !checkOutInput.value
        ) {

            if (totalPriceElement) {

                totalPriceElement.textContent =
                    "$0.00";

            }

            return;

        }


        const checkIn =
            new Date(checkInInput.value);

        const checkOut =
            new Date(checkOutInput.value);


        const difference =
            checkOut - checkIn;


        const nights =
            difference /
            (1000 * 60 * 60 * 24);


        if (nights <= 0) {

            totalPriceElement.textContent =
                "$0.00";

            return;

        }


        const total =
            nights * pricePerNight;


        totalPriceElement.textContent =
            "$" + total.toFixed(2);

    }


    const bookingForm =
        document.getElementById("bookingForm");


    if (bookingForm) {

        bookingForm.addEventListener(
            "submit",
            function (event) {

                const checkIn =
                    checkInInput.value;

                const checkOut =
                    checkOutInput.value;

                const guests =
                    Number(
                        document.getElementById("guests").value
                    );


                if (!checkIn || !checkOut) {

                    event.preventDefault();

                    alert(
                        "Please select both check-in and check-out dates."
                    );

                    return;

                }


                if (checkOut <= checkIn) {

                    event.preventDefault();

                    alert(
                        "Check-out date must be after check-in date."
                    );

                    return;

                }


                if (
                    guests < 1 ||
                    guests > capacity
                ) {

                    event.preventDefault();

                    alert(
                        "Number of guests must be between 1 and "
                        + capacity
                        + "."
                    );

                    return;

                }

            }
        );

    }

</script>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>
