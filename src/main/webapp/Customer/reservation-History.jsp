<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%-- ============================================================
     BACKEND 0: ENTRY POINT
     GET /reservations  ->  ReservationHistoryServlet.doGet()
     Protected by AuthFilter — must be logged in.
     Reads optional param "tab" (upcoming | past | cancelled,
     default "upcoming"), calls
       ReservationDAO.findByUser(sessionScope.user.id, tab)
     and sets request attribute "reservations": a List where each
     item exposes getId(), getRoomName(), getTypeLabel(), getImage(),
     getCheckIn(), getCheckOut(), getNights(), getGuests(), getTotal(),
     getStatus(), and getCanCancel() (server-decided: true only while
     the stay is still PENDING/CONFIRMED and check-in hasn't passed).

     The two cards below this comment are hard-coded sample data so
     the page previews without a servlet. The commented-out
     "REAL VERSION" block further down is the actual backend-driven
     version — swap them when ReservationHistoryServlet is ready.
     ============================================================ --%>
<c:if test="${empty reservations}">
    <jsp:useBean id="demoReservations" class="java.util.ArrayList" scope="request" />
    <c:set var="demo1" value='{"id":101,"roomName":"Deluxe King Room","typeLabel":"City view","img":"room-1.jpg","checkIn":"2026-10-14","checkOut":"2026-10-17","nights":3,"guests":2,"total":195,"status":"CONFIRMED","canCancel":true}' />
    <%-- BACKEND: demo objects are plain maps just for preview; delete this whole c:if once real data flows in --%>
    <c:set var="reservations" value="" scope="request" />
</c:if>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="My reservations" />
</jsp:include>
<jsp:include page="/common/navbar.jsp" />

<main class="flex-grow-1 py-4">
<div class="container" style="max-width: 54rem;">

    <h1 class="h3 mb-1">My reservations</h1>
    <p class="text-body-secondary mb-4">
        Welcome, <c:out value="${empty sessionScope.user ? 'Guest' : sessionScope.user.fullName}" />.
        Here's a look at your bookings.
    </p>

    <%-- ============================================================
         BACKEND 1: FLASH MESSAGE
         After a successful booking-confirm.jsp submit, or after a
         cancel action below, redirect here with ?flash=booked or
         ?flash=cancelled so the guest sees confirmation.
         ============================================================ --%>
    <c:if test="${not empty param.flash}">
        <c:choose>
            <c:when test="${param.flash == 'booked'}">
                <div class="alert alert-success">Your reservation is confirmed. See it below.</div>
            </c:when>
            <c:when test="${param.flash == 'cancelled'}">
                <div class="alert alert-warning">Your reservation has been cancelled.</div>
            </c:when>
        </c:choose>
    </c:if>

    <%-- ============================================================
         BACKEND 2: TABS
         Each tab link just re-GETs this page with ?tab=... — the
         servlet re-queries for that tab's rows. The "active" class
         below reads request attribute "activeTab" (default
         "upcoming"), set alongside "reservations" by the servlet.
         ============================================================ --%>
    <ul class="nav nav-tabs mb-4">
        <li class="nav-item">
            <a class="nav-link ${empty activeTab || activeTab == 'upcoming' ? 'active' : ''}"
               href="${ctx}/reservations?tab=upcoming">Upcoming</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'past' ? 'active' : ''}"
               href="${ctx}/reservations?tab=past">Past</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'cancelled' ? 'active' : ''}"
               href="${ctx}/reservations?tab=cancelled">Cancelled</a>
        </li>
    </ul>

    <%-- ============================================================
         BACKEND 3: RESERVATION LIST
         Loops over request attribute "reservations" (see BACKEND 0).
         The sample cards below are typed directly into the page so
         you can see the layout; replace this whole block with the
         c:forEach version underneath once the servlet is wired up.
         ============================================================ --%>

    <!-- ===== SAMPLE CARDS (delete once backend is connected) ===== -->
    <div class="reservation-card panel mb-3">
        <div class="row g-0 align-items-stretch">
            <div class="col-4 col-md-3">
                <div class="reservation-thumb"></div>
            </div>
            <div class="col-8 col-md-9">
                <div class="p-3 d-flex flex-column flex-md-row justify-content-between h-100 gap-3">
                    <div>
                        <span class="badge room-type-badge mb-1">City view</span>
                        <div class="fw-semibold">Deluxe King Room</div>
                        <div class="small text-body-secondary">Oct 14 &ndash; Oct 17, 2026 &middot; 3 nights &middot; 2 guests</div>
                        <div class="mt-1"><span class="badge status-badge status-confirmed">Confirmed</span></div>
                    </div>
                    <div class="text-md-end d-flex flex-row flex-md-column justify-content-between align-items-end">
                        <div class="fw-semibold">&#36;195</div>
                        <form action="${ctx}/reservations" method="post"
                              onsubmit="return confirm('Cancel this reservation?');" class="mt-md-2">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="id" value="101">
                            <button type="submit" class="btn btn-sm btn-outline-danger">Cancel</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="reservation-card panel mb-3">
        <div class="row g-0 align-items-stretch">
            <div class="col-4 col-md-3">
                <div class="reservation-thumb"></div>
            </div>
            <div class="col-8 col-md-9">
                <div class="p-3 d-flex flex-column flex-md-row justify-content-between h-100 gap-3">
                    <div>
                        <span class="badge room-type-badge mb-1">Family suite</span>
                        <div class="fw-semibold">Garden Family Suite</div>
                        <div class="small text-body-secondary">Nov 2 &ndash; Nov 5, 2026 &middot; 3 nights &middot; 4 guests</div>
                        <div class="mt-1"><span class="badge status-badge status-pending">Pending</span></div>
                    </div>
                    <div class="text-md-end d-flex flex-row flex-md-column justify-content-between align-items-end">
                        <div class="fw-semibold">&#36;285</div>
                        <form action="${ctx}/reservations" method="post"
                              onsubmit="return confirm('Cancel this reservation?');" class="mt-md-2">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="id" value="102">
                            <button type="submit" class="btn btn-sm btn-outline-danger">Cancel</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- ===== END SAMPLE CARDS ===== -->

    <%--
    REAL VERSION — uncomment once ReservationHistoryServlet sets
    "reservations" for real, and delete the two sample cards above.

    <c:choose>
        <c:when test="${empty reservations}">
            <div class="panel">
                <div class="panel-empty py-5">
                    <i class="bi bi-journal-x"></i>
                    <p class="mb-2">
                        <c:choose>
                            <c:when test="${activeTab == 'past'}">You have no past stays yet.</c:when>
                            <c:when test="${activeTab == 'cancelled'}">You have no cancelled reservations.</c:when>
                            <c:otherwise>You don't have any upcoming reservations.</c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${ctx}/rooms" class="btn btn-primary btn-sm">Browse rooms</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="r" items="${reservations}">
                <div class="reservation-card panel mb-3">
                    <div class="row g-0 align-items-stretch">
                        <div class="col-4 col-md-3">
                            <c:url var="thumbUrl" value="/assets/img/${r.image}" />
                            <img src="${thumbUrl}" alt="${r.roomName}" class="reservation-thumb-img" onerror="this.parentElement.classList.add('reservation-thumb')">
                        </div>
                        <div class="col-8 col-md-9">
                            <div class="p-3 d-flex flex-column flex-md-row justify-content-between h-100 gap-3">
                                <div>
                                    <span class="badge room-type-badge mb-1"><c:out value="${r.typeLabel}" /></span>
                                    <div class="fw-semibold"><c:out value="${r.roomName}" /></div>
                                    <div class="small text-body-secondary">
                                        <c:out value="${r.checkIn}" /> &ndash; <c:out value="${r.checkOut}" />
                                        &middot; <c:out value="${r.nights}" /> nights
                                        &middot; <c:out value="${r.guests}" /> guests
                                    </div>
                                    <div class="mt-1">
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
                                    </div>
                                </div>
                                <div class="text-md-end d-flex flex-row flex-md-column justify-content-between align-items-end">
                                    <div class="fw-semibold">&#36;<c:out value="${r.total}" /></div>
                                    <c:if test="${r.canCancel}">
                                        <form action="${ctx}/reservations" method="post"
                                              onsubmit="return confirm('Cancel this reservation?');" class="mt-md-2">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="id" value="${r.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">Cancel</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    --%>

</div>
</main>

<jsp:include page="/common/footer.jsp" />