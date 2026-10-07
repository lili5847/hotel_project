
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Reservations - Hotel Admin</title>

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

        .sidebar {
            min-height: 100vh;
            background: #212529;
        }

        .sidebar a {
            display: block;
            padding: 12px 20px;
            color: #adb5bd;
            text-decoration: none;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: #343a40;
            color: white;
        }

        .content {
            padding: 30px;
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .status-badge {
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
        }

        .table th {
            white-space: nowrap;
        }

        .table td {
            vertical-align: middle;
        }

    </style>

</head>

<body>

<%
    String ctx = request.getContextPath();
%>

<div class="container-fluid">

    <div class="row">

        <!-- SIDEBAR -->
        <div class="col-md-3 col-lg-2 px-0 sidebar">

            <div class="p-4 text-white">

                <h4>
                    <i class="bi bi-building me-2"></i>
                    Hotel Admin
                </h4>

            </div>

            <a href="<%= ctx %>/admin">
                <i class="bi bi-speedometer2 me-2"></i>
                Dashboard
            </a>

            <a href="<%= ctx %>/admin/reservations"
               class="active">
                <i class="bi bi-calendar-check me-2"></i>
                Reservations
            </a>

            <a href="<%= ctx %>/admin/rooms">
                <i class="bi bi-door-open me-2"></i>
                Rooms
            </a>

            <a href="<%= ctx %>/admin/room-types">
                <i class="bi bi-grid me-2"></i>
                Room Types
            </a>

            <a href="<%= ctx %>/admin/customers">
                <i class="bi bi-people me-2"></i>
                Customers
            </a>

            <hr class="text-secondary">

            <a href="<%= ctx %>/rooms">
                <i class="bi bi-house me-2"></i>
                Customer Site
            </a>

            <a href="<%= ctx %>/login"
               onclick="localStorage.removeItem('accessToken');
                        localStorage.removeItem('token');">

                <i class="bi bi-box-arrow-right me-2"></i>
                Logout

            </a>

        </div>


        <!-- CONTENT -->
        <div class="col-md-9 col-lg-10">

            <div class="content">

                <div class="mb-4">

                    <h2 class="fw-bold">
                        <i class="bi bi-calendar-check me-2"></i>
                        Reservations
                    </h2>

                    <p class="text-muted">
                        Manage hotel reservations
                    </p>

                </div>


                <div class="card">

                    <div class="card-body">

                        <div class="d-flex justify-content-between align-items-center mb-4">

                            <h5 class="fw-bold mb-0">
                                Reservation List
                            </h5>

                            <span id="reservationCount"
                                  class="badge bg-primary">
                                0 Reservations
                            </span>

                        </div>


                        <div id="alertBox"
                             class="alert d-none"
                             role="alert">
                        </div>


                        <div class="table-responsive">

                            <table class="table table-hover align-middle">

                                <thead class="table-light">

                                <tr>

                                    <th>ID</th>
                                    <th>Customer</th>
                                    <th>Room</th>
                                    <th>Check In</th>
                                    <th>Check Out</th>
                                    <th>Guests</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Action</th>

                                </tr>

                                </thead>

                                <tbody id="reservationTableBody">

                                <tr>

                                    <td colspan="9"
                                        class="text-center text-muted py-5">

                                        <div class="spinner-border text-primary mb-3">
                                        </div>

                                        <div>
                                            Loading reservations...
                                        </div>

                                    </td>

                                </tr>

                                </tbody>

                            </table>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>


<script>

    const contextPath = "<%= ctx %>";


    function getToken() {

        return localStorage.getItem("token")
            || localStorage.getItem("accessToken");

    }


    function showAlert(message, type) {

        const alertBox =
            document.getElementById("alertBox");

        alertBox.className =
            "alert alert-" + type;

        alertBox.textContent = message;

        alertBox.classList.remove("d-none");

        setTimeout(function () {

            alertBox.classList.add("d-none");

        }, 3000);

    }


    function getStatusBadge(status) {

        if (!status) {

            return `
                <span class="badge bg-secondary status-badge">
                    UNKNOWN
                </span>
            `;

        }

        if (status.toUpperCase() === "PENDING") {

            return `
                <span class="badge bg-warning text-dark status-badge">
                    <i class="bi bi-clock me-1"></i>
                    Pending
                </span>
            `;

        }

        if (status.toUpperCase() === "CONFIRMED") {

            return `
                <span class="badge bg-success status-badge">
                    <i class="bi bi-check-circle me-1"></i>
                    Confirmed
                </span>
            `;

        }

        if (status.toUpperCase() === "CANCELLED") {

            return `
                <span class="badge bg-danger status-badge">
                    <i class="bi bi-x-circle me-1"></i>
                    Cancelled
                </span>
            `;

        }

        return `
            <span class="badge bg-secondary status-badge">
                ${status}
            </span>
        `;

    }


    function getCustomerName(reservation) {

        if (reservation.customer) {

            if (reservation.customer.user) {

                return reservation.customer.user.fullName
                    || reservation.customer.user.username
                    || reservation.customer.user.email
                    || "Unknown";

            }

            return reservation.customer.fullName
                || reservation.customer.username
                || reservation.customer.email
                || "Unknown";

        }

        return "Unknown";

    }


    function getRoomNumber(reservation) {

        if (reservation.room) {

            return reservation.room.roomNumber
                || reservation.room.roomId
                || "Unknown";

        }

        return "Unknown";

    }


    function loadReservations() {

        const token = getToken();

        fetch(
            contextPath + "/api/reservations",
            {
                method: "GET",

                headers: {
                    "Authorization": "Bearer " + token,
                    "Content-Type": "application/json"
                }
            }
        )

        .then(response => {

            if (!response.ok) {

                throw new Error(
                    "Failed to load reservations. HTTP "
                    + response.status
                );

            }

            return response.json();

        })

        .then(result => {

            const reservations =
                result.data || [];

            const tableBody =
                document.getElementById(
                    "reservationTableBody"
                );

            const count =
                document.getElementById(
                    "reservationCount"
                );


            count.textContent =
                reservations.length +
                " Reservations";


            if (reservations.length === 0) {

                tableBody.innerHTML = `

                    <tr>

                        <td colspan="9"
                            class="text-center text-muted py-5">

                            <i class="bi bi-calendar-x display-5"></i>

                            <div class="mt-3">
                                No reservations found.
                            </div>

                        </td>

                    </tr>

                `;

                return;

            }


            tableBody.innerHTML = "";


            reservations.forEach(function (reservation) {

                const status =
                    reservation.status || "UNKNOWN";


                let actionHtml = "";


                if (status.toUpperCase() === "PENDING") {

                    actionHtml =

                        '<button type="button" ' +
                        'class="btn btn-success btn-sm" ' +
                        'onclick="confirmReservation(' +
                        reservation.bookingId +
                        ')">' +

                        '<i class="bi bi-check-circle me-1"></i>' +
                        'Confirm' +

                        '</button>';

                }


                if (status.toUpperCase() === "CONFIRMED") {

                    actionHtml =

                        '<span class="text-success fw-semibold">' +

                        '<i class="bi bi-check-circle me-1"></i>' +
                        'Confirmed' +

                        '</span>';

                }


                if (status.toUpperCase() === "CANCELLED") {

                    actionHtml =

                        '<span class="text-danger fw-semibold">' +

                        '<i class="bi bi-x-circle me-1"></i>' +
                        'Cancelled' +

                        '</span>';

                }


                const row =

                    '<tr>' +

                    '<td>' +
                    '<strong>#' +
                    reservation.bookingId +
                    '</strong>' +
                    '</td>' +

                    '<td>' +
                    getCustomerName(reservation) +
                    '</td>' +

                    '<td>' +
                    getRoomNumber(reservation) +
                    '</td>' +

                    '<td>' +
                    (reservation.checkIn || "-") +
                    '</td>' +

                    '<td>' +
                    (reservation.checkOut || "-") +
                    '</td>' +

                    '<td>' +
                    (reservation.guests || "-") +
                    '</td>' +

                    '<td>$' +
                    (reservation.totalAmount || "0.00") +
                    '</td>' +

                    '<td>' +
                    getStatusBadge(status) +
                    '</td>' +

                    '<td>' +
                    actionHtml +
                    '</td>' +

                    '</tr>';


                tableBody.insertAdjacentHTML(
                    "beforeend",
                    row
                );

            });

        })

        .catch(error => {

            console.error(error);

            document.getElementById(
                "reservationTableBody"
            ).innerHTML =

                '<tr>' +

                '<td colspan="9" ' +
                'class="text-center text-danger py-5">' +

                '<i class="bi bi-exclamation-triangle display-5"></i>' +

                '<div class="mt-3">' +
                'Failed to load reservations.' +
                '</div>' +

                '</td>' +

                '</tr>';

        });

    }


    function confirmReservation(bookingId) {

        if (!confirm(
            "Are you sure you want to confirm booking #"
            + bookingId
            + "?"
        )) {

            return;

        }


        const token = getToken();


        fetch(
            contextPath +
            "/api/reservations/" +
            bookingId +
            "/confirm",
            {
                method: "POST",

                headers: {
                    "Authorization": "Bearer " + token,
                    "Content-Type": "application/json"
                }
            }
        )

        .then(response => {

            if (!response.ok) {

                return response.text()
                    .then(text => {

                        throw new Error(
                            "HTTP " +
                            response.status +
                            ": " +
                            text
                        );

                    });

            }

            return response.json();

        })

        .then(result => {

            showAlert(
                "Booking #" +
                bookingId +
                " confirmed successfully!",
                "success"
            );

            loadReservations();

        })

        .catch(error => {

            console.error(error);

            showAlert(
                "Failed to confirm booking: " +
                error.message,
                "danger"
            );

        });

    }


    document.addEventListener(
        "DOMContentLoaded",
        function () {

            loadReservations();

        }
    );

</script>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>

