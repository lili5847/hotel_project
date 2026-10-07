
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:include page="/WEB-INF/jsp/common/admin-header.jsp">
    <jsp:param name="title" value="Dashboard"/>
</jsp:include>

<jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp"/>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h2 class="fw-bold">Admin Dashboard</h2>
        <p class="text-muted mb-0">
            Hotel reservation management
        </p>
    </div>
</div>

<div class="row g-4">

    <div class="col-md-6 col-xl-4">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted">Total Reservations</div>
                <h2 class="fw-bold">${totalReservations}</h2>
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-4">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted">Pending</div>
                <h2 class="fw-bold text-warning">
                    ${pendingReservations}
                </h2>
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-4">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted">Confirmed</div>
                <h2 class="fw-bold text-success">
                    ${confirmedReservations}
                </h2>
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-4">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted">Cancelled</div>
                <h2 class="fw-bold text-danger">
                    ${cancelledReservations}
                </h2>
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-4">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted">Total Rooms</div>
                <h2 class="fw-bold">${totalRooms}</h2>
            </div>
        </div>
    </div>

    <div class="col-md-6 col-xl-4">
        <div class="card border-0 shadow-sm">
            <div class="card-body">
                <div class="text-muted">Total Users</div>
                <h2 class="fw-bold">${totalUsers}</h2>
            </div>
        </div>
    </div>

</div>

<div class="card mt-4 border-0 shadow-sm">
    <div class="card-body">

        <h5 class="fw-bold mb-3">
            Quick Actions
        </h5>

        <a href="${pageContext.request.contextPath}/admin/reservations"
           class="btn btn-primary me-2">

            <i class="bi bi-calendar-check me-1"></i>
            Manage Reservations

        </a>

        <a href="${pageContext.request.contextPath}/admin/rooms"
           class="btn btn-outline-primary">

            <i class="bi bi-door-open me-1"></i>
            Manage Rooms

        </a>

    </div>
</div>

<jsp:include page="/WEB-INF/jsp/common/admin-footer.jsp"/>
