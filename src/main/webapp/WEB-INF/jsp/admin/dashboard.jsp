<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>

<html lang="en">

<head>

```
<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Admin Dashboard - Hotel Reservation</title>

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
        color: #adb5bd;
        text-decoration: none;
        display: block;
        padding: 12px 20px;
    }

    .sidebar a:hover,
    .sidebar a.active {
        background: #343a40;
        color: white;
    }

    .stat-card {
        border: none;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    }

    .stat-icon {
        font-size: 2rem;
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

        <a href="<%= ctx %>/admin"
           class="active">

            <i class="bi bi-speedometer2 me-2"></i>
            Dashboard

        </a>

        <a href="<%= ctx %>/admin/reservations">

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

        <a href="<%= ctx %>/login">

            <i class="bi bi-box-arrow-right me-2"></i>
            Logout

        </a>

    </div>


    <!-- MAIN CONTENT -->

    <div class="col-md-9 col-lg-10">

        <div class="p-4">

            <div class="d-flex justify-content-between
                        align-items-center mb-4">

                <div>

                    <h2 class="fw-bold">
                        Admin Dashboard
                    </h2>

                    <p class="text-muted mb-0">
                        Hotel reservation management
                    </p>

                </div>

            </div>


            <!-- STATISTICS -->

            <div class="row g-4">


                <div class="col-md-6 col-xl-4">

                    <div class="card stat-card">

                        <div class="card-body">

                            <div class="d-flex
                                        justify-content-between">

                                <div>

                                    <div class="text-muted">
                                        Total Reservations
                                    </div>

                                    <h2 class="fw-bold">
                                        ${totalReservations}
                                    </h2>

                                </div>

                                <div class="stat-icon
                                            text-primary">

                                    <i class="bi bi-calendar-check"></i>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>


                <div class="col-md-6 col-xl-4">

                    <div class="card stat-card">

                        <div class="card-body">

                            <div class="d-flex
                                        justify-content-between">

                                <div>

                                    <div class="text-muted">
                                        Pending
                                    </div>

                                    <h2 class="fw-bold text-warning">
                                        ${pendingReservations}
                                    </h2>

                                </div>

                                <div class="stat-icon
                                            text-warning">

                                    <i class="bi bi-clock"></i>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>


                <div class="col-md-6 col-xl-4">

                    <div class="card stat-card">

                        <div class="card-body">

                            <div class="d-flex
                                        justify-content-between">

                                <div>

                                    <div class="text-muted">
                                        Confirmed
                                    </div>

                                    <h2 class="fw-bold text-success">
                                        ${confirmedReservations}
                                    </h2>

                                </div>

                                <div class="stat-icon
                                            text-success">

                                    <i class="bi bi-check-circle"></i>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>


                <div class="col-md-6 col-xl-4">

                    <div class="card stat-card">

                        <div class="card-body">

                            <div class="d-flex
                                        justify-content-between">

                                <div>

                                    <div class="text-muted">
                                        Cancelled
                                    </div>

                                    <h2 class="fw-bold text-danger">
                                        ${cancelledReservations}
                                    </h2>

                                </div>

                                <div class="stat-icon
                                            text-danger">

                                    <i class="bi bi-x-circle"></i>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>


                <div class="col-md-6 col-xl-4">

                    <div class="card stat-card">

                        <div class="card-body">

                            <div class="d-flex
                                        justify-content-between">

                                <div>

                                    <div class="text-muted">
                                        Total Rooms
                                    </div>

                                    <h2 class="fw-bold">
                                        ${totalRooms}
                                    </h2>

                                </div>

                                <div class="stat-icon
                                            text-info">

                                    <i class="bi bi-door-open"></i>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>


                <div class="col-md-6 col-xl-4">

                    <div class="card stat-card">

                        <div class="card-body">

                            <div class="d-flex
                                        justify-content-between">

                                <div>

                                    <div class="text-muted">
                                        Total Users
                                    </div>

                                    <h2 class="fw-bold">
                                        ${totalUsers}
                                    </h2>

                                </div>

                                <div class="stat-icon
                                            text-secondary">

                                    <i class="bi bi-people"></i>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- QUICK ACTIONS -->

            <div class="card mt-4 border-0 shadow-sm">

                <div class="card-body">

                    <h5 class="fw-bold mb-3">
                        Quick Actions
                    </h5>

                    <a href="<%= ctx %>/admin/reservations"
                       class="btn btn-primary me-2">

                        <i class="bi bi-calendar-check me-1"></i>
                        Manage Reservations

                    </a>

                    <a href="<%= ctx %>/admin/rooms"
                       class="btn btn-outline-primary">

                        <i class="bi bi-door-open me-1"></i>
                        Manage Rooms

                    </a>

                </div>

            </div>

        </div>

    </div>

</div>

</div>

</body>
</html>
