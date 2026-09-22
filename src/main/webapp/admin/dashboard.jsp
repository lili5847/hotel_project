<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Dashboard" />

<%-- ============================================================
     BACKEND 0: ACCESS CONTROL
     This page must only be reachable through AdminDashboardServlet,
     mapped to /admin/dashboard, and protected by an AdminFilter that:
       1. checks sessionScope.user exists          -> else redirect to /login?required=1
       2. checks sessionScope.user.role == "ADMIN" -> else respond 403 or redirect home
     Do not open this JSP directly under WEB-INF for that reason;
     keep admin JSPs under WEB-INF/views/admin/ once the filter is in place.
     ============================================================ --%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Admin dashboard" />
</jsp:include>
<jsp:include page="/common/admin-sidebar.jsp" />

<%-- ============================================================
     BACKEND 1: DASHBOARD STATS
     AdminDashboardServlet should compute these and set them as
     request attributes before forwarding here, e.g.:
       request.setAttribute("totalRooms", roomDAO.countAll());
       request.setAttribute("availableRooms", roomDAO.countAvailable());
       request.setAttribute("todayCheckIns", reservationDAO.countCheckInsOn(LocalDate.now()));
       request.setAttribute("totalCustomers", userDAO.countByRole("CUSTOMER"));
     Until then, the ${empty ... ? 0 : ...} checks below just show 0
     instead of throwing an error, so the page is safe to preview now.
     ============================================================ --%>
<div class="row g-3 g-lg-4 mb-4">
    <div class="col-6 col-lg-3">
        <div class="stat-card">
            <span class="stat-icon bg-icon-teal"><i class="bi bi-door-open"></i></span>
            <div class="stat-value"><c:out value="${empty totalRooms ? 0 : totalRooms}" /></div>
            <div class="stat-label">Total rooms</div>
        </div>
    </div>
    <div class="col-6 col-lg-3">
        <div class="stat-card">
            <span class="stat-icon bg-icon-green"><i class="bi bi-check2-circle"></i></span>
            <div class="stat-value"><c:out value="${empty availableRooms ? 0 : availableRooms}" /></div>
            <div class="stat-label">Available today</div>
        </div>
    </div>
    <div class="col-6 col-lg-3">
        <div class="stat-card">
            <span class="stat-icon bg-icon-amber"><i class="bi bi-box-arrow-in-right"></i></span>
            <div class="stat-value"><c:out value="${empty todayCheckIns ? 0 : todayCheckIns}" /></div>
            <div class="stat-label">Check-ins today</div>
        </div>
    </div>
    <div class="col-6 col-lg-3">
        <div class="stat-card">
            <span class="stat-icon bg-icon-plum"><i class="bi bi-people"></i></span>
            <div class="stat-value"><c:out value="${empty totalCustomers ? 0 : totalCustomers}" /></div>
            <div class="stat-label">Customers</div>
        </div>
    </div>
</div>

<div class="row g-4">

    <!-- Recent reservations -->
    <div class="col-lg-8">
        <div class="panel">
            <div class="panel-header">
                <h2 class="h5 mb-0">Recent reservations</h2>
                <a href="${ctx}/admin/reservations" class="small">View all</a>
            </div>

            <%-- ============================================================
                 BACKEND 2: RECENT RESERVATIONS LIST
                 Set request.setAttribute("recentReservations", list) in
                 AdminDashboardServlet, where each item exposes at least:
                   getId(), getGuestName(), getRoomLabel(),
                   getCheckIn(), getCheckOut(), getStatus()
                 Suggested source: ReservationDAO.findRecent(10)
                 Status values used for the badge below: PENDING, CONFIRMED,
                 CHECKED_IN, CANCELLED — adjust the c:when list if your
                 enum/strings differ.
                 ============================================================ --%>
            <c:choose>
                <c:when test="${empty recentReservations}">
                    <div class="panel-empty">
                        <i class="bi bi-journal-x"></i>
                        <p class="mb-0">No reservations to show yet.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table admin-table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Guest</th>
                                    <th>Room</th>
                                    <th>Check-in</th>
                                    <th>Check-out</th>
                                    <th>Status</th>
                                    <th class="text-end">&nbsp;</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${recentReservations}">
                                    <tr>
                                        <td><c:out value="${r.guestName}" /></td>
                                        <td><c:out value="${r.roomLabel}" /></td>
                                        <td><c:out value="${r.checkIn}" /></td>
                                        <td><c:out value="${r.checkOut}" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.status == 'CONFIRMED'}">
                                                    <span class="badge status-badge status-confirmed">Confirmed</span>
                                                </c:when>
                                                <c:when test="${r.status == 'CHECKED_IN'}">
                                                    <span class="badge status-badge status-checked-in">Checked in</span>
                                                </c:when>
                                                <c:when test="${r.status == 'CANCELLED'}">
                                                    <span class="badge status-badge status-cancelled">Cancelled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge status-badge status-pending">Pending</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="${ctx}/admin/reservations?id=${r.id}" class="small">Manage</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Quick actions -->
    <div class="col-lg-4">
        <div class="panel h-100">
            <div class="panel-header">
                <h2 class="h5 mb-0">Quick actions</h2>
            </div>
            <div class="p-3 d-grid gap-2">
                <a href="${ctx}/admin/rooms?action=new" class="btn btn-outline-primary text-start">
                    <i class="bi bi-plus-circle me-2"></i>Add a room
                </a>
                <a href="${ctx}/admin/room-types?action=new" class="btn btn-outline-primary text-start">
                    <i class="bi bi-plus-circle me-2"></i>Add a room type
                </a>
                <a href="${ctx}/admin/reservations?status=PENDING" class="btn btn-outline-primary text-start">
                    <i class="bi bi-hourglass-split me-2"></i>Review pending reservations
                </a>
                <a href="${ctx}/admin/customers" class="btn btn-outline-primary text-start">
                    <i class="bi bi-people me-2"></i>Manage customers
                </a>
            </div>
        </div>
    </div>

</div>

<jsp:include page="/common/admin-footer.jsp" />