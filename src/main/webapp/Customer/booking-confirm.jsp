<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%-- ============================================================
     BACKEND 0: ENTRY POINT
     Reached only after BookingServlet.doPost() (from room-details.jsp)
     validates availability and stores a pending booking, then forwards
     here (not a redirect, since the pending booking is request-scoped
     or session-scoped and doesn't need to survive a fresh GET).

     Also protect this page with AuthFilter — an unauthenticated user
     should never reach it directly by typing the URL.

     Required request attributes, all set by BookingServlet before
     forwarding:
       "room"    : same shape as in room-details.jsp — getId(),
                   getName(), getTypeLabel(), getImages(), getPrice()
       "booking" : a draft/pending object exposing getCheckIn(),
                   getCheckOut(), getNights(), getGuests(), getBedOption()
       "pricing" : exposing getNightlyRate(), getSubtotal(), getTaxes(),
                   getTotal() — the AUTHORITATIVE total, recalculated
                   server-side (never trust the JS estimate shown on
                   room-details.jsp)
       "bookingToken" : a one-time hidden token (session-bound random
                   string) so the confirm POST below can't be replayed
                   or forged from outside this page
     If "room" or "booking" is missing (e.g. someone bookmarks this
     URL), redirect back to /rooms before rendering anything past
     this comment.
     ============================================================ --%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Confirm your reservation" />
</jsp:include>
<jsp:include page="/common/navbar.jsp" />

<main class="flex-grow-1 py-4">
<div class="container" style="max-width: 48rem;">

    <nav class="small mb-3" aria-label="breadcrumb">
        <a href="${ctx}/rooms?id=${room.id}" class="text-decoration-none">
            <i class="bi bi-arrow-left me-1"></i>Back to room
        </a>
    </nav>

    <h1 class="h3 mb-4">Confirm your reservation</h1>

    <%-- ============================================================
         BACKEND 1: ERROR BANNER
         If the confirm POST below fails (room got booked by someone
         else in the meantime, session expired, etc.), BookingServlet
         forwards back here with "error" set, e.g.
           request.setAttribute("error", "This room is no longer available for those dates.");
         ============================================================ --%>
    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert"><c:out value="${error}" /></div>
    </c:if>

    <div class="panel mb-4">
        <div class="panel-header">
            <h2 class="h6 mb-0">Room</h2>
        </div>
        <div class="p-3 d-flex gap-3 align-items-center">
            <%-- BACKEND: room.images[0], same as room-details.jsp gallery source --%>
            <c:url var="thumbUrl" value="/assets/img/${room.images[0]}" />
            <img src="${thumbUrl}" alt="${room.name}" class="confirm-thumb" onerror="this.remove()">
            <div>
                <span class="badge room-type-badge mb-1"><c:out value="${room.typeLabel}" /></span>
                <div class="fw-semibold"><c:out value="${room.name}" /></div>
                <div class="small text-body-secondary">&#36;<c:out value="${room.price}" /> / night</div>
            </div>
        </div>
    </div>

    <div class="panel mb-4">
        <div class="panel-header">
            <h2 class="h6 mb-0">Stay details</h2>
        </div>
        <%-- BACKEND: everything in this block reads from "booking" --%>
        <div class="p-3">
            <div class="row g-3">
                <div class="col-6 col-md-3">
                    <div class="small text-body-secondary">Check-in</div>
                    <div class="fw-medium"><c:out value="${booking.checkIn}" /></div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="small text-body-secondary">Check-out</div>
                    <div class="fw-medium"><c:out value="${booking.checkOut}" /></div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="small text-body-secondary">Guests</div>
                    <div class="fw-medium"><c:out value="${booking.guests}" /></div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="small text-body-secondary">Bed type</div>
                    <div class="fw-medium"><c:out value="${booking.bedOption}" /></div>
                </div>
            </div>
        </div>
    </div>

    <%-- ============================================================
         BACKEND 2: GUEST INFO (read-only recap)
         Pulled from sessionScope.user, not re-entered here — this is
         just a confirmation of who the reservation is under. If your
         User model uses different getter names, adjust accordingly.
         ============================================================ --%>
    <div class="panel mb-4">
        <div class="panel-header">
            <h2 class="h6 mb-0">Booking under</h2>
        </div>
        <div class="p-3">
            <div class="fw-medium"><c:out value="${sessionScope.user.fullName}" /></div>
            <div class="small text-body-secondary"><c:out value="${sessionScope.user.email}" /></div>
        </div>
    </div>

    <%-- ============================================================
         BACKEND 3: PRICE BREAKDOWN
         Reads from "pricing", the authoritative server-calculated
         amounts. This replaces the quick JS estimate shown earlier
         on room-details.jsp.
         ============================================================ --%>
    <div class="panel mb-4">
        <div class="panel-header">
            <h2 class="h6 mb-0">Price summary</h2>
        </div>
        <div class="p-3">
            <div class="d-flex justify-content-between small mb-2">
                <span><c:out value="${booking.nights}" /> night(s) &times; &#36;<c:out value="${pricing.nightlyRate}" /></span>
                <span>&#36;<c:out value="${pricing.subtotal}" /></span>
            </div>
            <div class="d-flex justify-content-between small mb-2 text-body-secondary">
                <span>Taxes and fees</span>
                <span>&#36;<c:out value="${pricing.taxes}" /></span>
            </div>
            <hr>
            <div class="d-flex justify-content-between fw-semibold fs-5">
                <span>Total</span>
                <span>&#36;<c:out value="${pricing.total}" /></span>
            </div>
        </div>
    </div>

    <%-- ============================================================
         BACKEND 4: CONFIRM SUBMIT
         POST /booking/confirm  ->  BookingServlet (or a separate
         BookingConfirmServlet).doPost()
         Parameters sent: bookingToken only — every other detail
         (room, dates, guests, bed option, price) is looked up
         server-side from the pending booking tied to that token /
         the user's session, NOT re-read from hidden form fields.
         This stops a guest from editing hidden inputs in devtools to
         change the price or dates before confirming.
         On success:
           1. insert the row via ReservationDAO.create(...) with
              status PENDING (or CONFIRMED, if your workflow skips
              admin approval)
           2. clear the pending booking from session
           3. redirect to /reservations?flash=booked (reservation
              history page) or a dedicated booking-success view
         On failure (double-booked in the meantime, etc.):
           forward back here with "error" set, as shown above
         ============================================================ --%>
    <form action="${ctx}/booking/confirm" method="post" class="d-flex flex-column flex-sm-row gap-2 justify-content-end">
        <input type="hidden" name="bookingToken" value="${bookingToken}">
        <a href="${ctx}/rooms?id=${room.id}" class="btn btn-outline-secondary order-2 order-sm-1">Cancel</a>
        <button type="submit" class="btn btn-primary btn-lg order-1 order-sm-2">
            <i class="bi bi-check2-circle me-1"></i>Confirm reservation
        </button>
    </form>

</div>
</main>

<jsp:include page="/common/footer.jsp" />