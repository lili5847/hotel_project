<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Room Details - Hotel</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        body {
            background: #f8f9fa;
        }

        .navbar-brand {
            font-weight: 700;
        }

        .room-image {
            height: 380px;
            background: linear-gradient(135deg, #e9ecef, #dee2e6);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 15px;
        }

        .room-image i {
            font-size: 100px;
            color: #6c757d;
        }

        .room-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        .price {
            font-size: 28px;
            font-weight: 700;
            color: #198754;
        }

        .info-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
        }

        .amenities {
            white-space: pre-line;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">

        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="bi bi-building"></i>
            Hotel
        </a>

        <button
            class="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">

            <ul class="navbar-nav ms-auto">

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/">
                        Home
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/rooms">
                        Rooms
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/login">
                        Login
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/register">
                        Register
                    </a>
                </li>

            </ul>

        </div>
    </div>
</nav>


<div class="container py-5">

    <c:choose>

        <c:when test="${not empty room}">

            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/"
                   class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i>
                    Back to Rooms
                </a>
            </div>

            <div class="card room-card">

                <div class="card-body p-4 p-lg-5">

                    <div class="row g-5">

                        <!-- Room image -->
                        <div class="col-lg-6">

                            <div class="room-image">
                                <i class="bi bi-door-open"></i>
                            </div>

                        </div>


                        <!-- Room information -->
                        <div class="col-lg-6">

                            <div class="mb-3">

                                <span class="badge bg-success">
                                    ${room.status}
                                </span>

                            </div>

                            <h1 class="fw-bold mb-2">
                                Room ${room.roomNumber}
                            </h1>

                            <h4 class="text-muted mb-4">
                                ${room.roomType.typeName}
                            </h4>


                            <div class="price mb-4">

                                $${room.roomType.price}

                                <small class="text-muted fs-6">
                                    / night
                                </small>

                            </div>


                            <p class="text-muted mb-4">
                                ${room.description}
                            </p>


                            <div class="row g-3 mb-4">

                                <div class="col-md-6">

                                    <div class="info-box">

                                        <div class="text-muted small">
                                            Room Number
                                        </div>

                                        <strong>
                                            ${room.roomNumber}
                                        </strong>

                                    </div>

                                </div>


                                <div class="col-md-6">

                                    <div class="info-box">

                                        <div class="text-muted small">
                                            Floor
                                        </div>

                                        <strong>
                                            ${room.floor}
                                        </strong>

                                    </div>

                                </div>


                                <div class="col-md-6">

                                    <div class="info-box">

                                        <div class="text-muted small">
                                            Capacity
                                        </div>

                                        <strong>
                                            ${room.roomType.capacity}
                                            guests
                                        </strong>

                                    </div>

                                </div>


                                <div class="col-md-6">

                                    <div class="info-box">

                                        <div class="text-muted small">
                                            Status
                                        </div>

                                        <strong>
                                            ${room.status}
                                        </strong>

                                    </div>

                                </div>

                            </div>


                            <c:if test="${not empty room.roomType.amenities}">

                                <div class="mb-4">

                                    <h5 class="fw-bold">
                                        <i class="bi bi-stars"></i>
                                        Amenities
                                    </h5>

                                    <p class="amenities text-muted">
                                        ${room.roomType.amenities}
                                    </p>

                                </div>

                            </c:if>



								<a href="${ctx}/reservations/book?roomId=${room.roomId}"
								   class="btn btn-primary">
								    Book Now
								</a>



                                <a
                                    href="${pageContext.request.contextPath}/"
                                    class="btn btn-outline-secondary btn-lg">

                                    Back

                                </a>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </c:when>


        <c:otherwise>

            <div class="card room-card text-center">

                <div class="card-body py-5">

                    <i class="bi bi-exclamation-circle text-warning"
                       style="font-size: 60px;"></i>

                    <h2 class="mt-3">
                        Room Not Found
                    </h2>

                    <p class="text-muted">
                        The room you are looking for does not exist.
                    </p>

                    <a
                        href="${pageContext.request.contextPath}/"
                        class="btn btn-primary">

                        Back to Rooms

                    </a>

                </div>

            </div>

        </c:otherwise>

    </c:choose>

</div>


<footer class="bg-dark text-white text-center py-4 mt-5">

    <div class="container">

        <p class="mb-0">
            &copy; 2026 Hotel Reservation System
        </p>

    </div>

</footer>


<script>

    function bookRoom(roomId) {

        const token = localStorage.getItem("token");

        if (!token) {
            window.location.href =
                "${pageContext.request.contextPath}/login";
            return;
        }

        window.location.href =
            "${pageContext.request.contextPath}/?bookRoom=" + roomId;
    }

</script>

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>

