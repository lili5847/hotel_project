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

        <%-- Error Banner --%>
        <div id="errorBanner" class="alert alert-danger ${empty error ? 'd-none' : ''}" role="alert">
            <span id="errorMessage"><c:out value="${error}" /></span>
        </div>

        <div class="panel mb-4">
            <div class="panel-header">
                <h2 class="h6 mb-0">Room</h2>
            </div>
            <div class="p-3 d-flex gap-3 align-items-center">
                <%-- BACKEND: room.images[0], same as room-details.jsp gallery source --%>
                <c:url var="thumbUrl" value="/assets/img/${room.images[0]}" />
                <img id="roomThumb" src="${thumbUrl}" alt="${room.name}" class="confirm-thumb" onerror="this.remove()">
                <div>
                    <span id="roomTypeBadge" class="badge room-type-badge mb-1"><c:out value="${room.typeLabel}" /></span>
                    <div id="roomName" class="fw-semibold"><c:out value="${room.name}" /></div>
                    <div class="small text-body-secondary">&#36;<span id="roomPrice"><c:out value="${room.price}" /></span> / night</div>
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
                        <div id="checkInDate" class="fw-medium"><c:out value="${booking.checkIn}" /></div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="small text-body-secondary">Check-out</div>
                        <div id="checkOutDate" class="fw-medium"><c:out value="${booking.checkOut}" /></div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="small text-body-secondary">Guests</div>
                        <div id="guestCount" class="fw-medium"><c:out value="${booking.guests}" /></div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="small text-body-secondary">Bed type</div>
                        <div id="bedOption" class="fw-medium"><c:out value="${booking.bedOption}" /></div>
                    </div>
                </div>
            </div>
        </div>

        <%-- GUEST INFO --%>
        <div class="panel mb-4">
            <div class="panel-header">
                <h2 class="h6 mb-0">Booking under</h2>
            </div>
            <div class="p-3">
                <div id="guestFullName" class="fw-medium"><c:out value="${sessionScope.user.fullName}" /></div>
                <div id="guestEmail" class="small text-body-secondary"><c:out value="${sessionScope.user.email}" /></div>
            </div>
        </div>

        <%-- PRICE BREAKDOWN --%>
        <div class="panel mb-4">
            <div class="panel-header">
                <h2 class="h6 mb-0">Price summary</h2>
            </div>
            <div class="p-3">
                <div class="d-flex justify-content-between small mb-2">
                    <span><span id="bookingNights"><c:out value="${booking.nights}" /></span> night(s) &times; &#36;<span id="nightlyRate"><c:out value="${pricing.nightlyRate}" /></span></span>
                    <span>&#36;<span id="pricingSubtotal"><c:out value="${pricing.subtotal}" /></span></span>
                </div>
                <div class="d-flex justify-content-between small mb-2 text-body-secondary">
                    <span>Taxes and fees</span>
                    <span>&#36;<span id="pricingTaxes"><c:out value="${pricing.taxes}" /></span></span>
                </div>
                <hr>
                <div class="d-flex justify-content-between fw-semibold fs-5">
                    <span>Total</span>
                    <span>&#36;<span id="pricingTotal"><c:out value="${pricing.total}" /></span></span>
                </div>
            </div>
        </div>

        <%-- CONFIRM SUBMIT FORM WITH FETCH API INTEGRATION --%>
        <form id="confirmBookingForm" action="${ctx}/booking/confirm" method="post" onsubmit="handleConfirmBooking(event)" class="d-flex flex-column flex-sm-row gap-2 justify-content-end">
            <input type="hidden" id="bookingTokenInput" name="bookingToken" value="${bookingToken}">
            <a href="${ctx}/rooms?id=${room.id}" class="btn btn-outline-secondary order-2 order-sm-1">Cancel</a>
            <button type="submit" id="submitBtn" class="btn btn-primary btn-lg order-1 order-sm-2">
                <i class="bi bi-check2-circle me-1"></i>Confirm reservation
            </button>
        </form>

    </div>
</main>

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION FOR SPRING BOOT BACKEND
============================================================ -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        fetchDraftBookingDetails();
    });

    function fetchDraftBookingDetails() {
        const token = localStorage.getItem('token') || localStorage.getItem('accessToken');
        const bookingToken = document.getElementById('bookingTokenInput').value;

        if (!token || !bookingToken) return;

        fetch('${ctx}/api/booking/details?bookingToken=' + encodeURIComponent(bookingToken), {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (response.ok) return response.json();
                throw new Error('Unable to retrieve pending booking details');
            })
            .then(data => {
                if (data) {
                    // Update UI elements dynamically from Spring Boot response
                    if (data.room) {
                        document.getElementById('roomName').textContent = data.room.name;
                        document.getElementById('roomPrice').textContent = data.room.price;
                        document.getElementById('roomTypeBadge').textContent = data.room.typeLabel;
                    }
                    if (data.booking) {
                        document.getElementById('checkInDate').textContent = data.booking.checkIn;
                        document.getElementById('checkOutDate').textContent = data.booking.checkOut;
                        document.getElementById('guestCount').textContent = data.booking.guests;
                        document.getElementById('bedOption').textContent = data.booking.bedOption;
                        document.getElementById('bookingNights').textContent = data.booking.nights;
                    }
                    if (data.pricing) {
                        document.getElementById('nightlyRate').textContent = data.pricing.nightlyRate;
                        document.getElementById('pricingSubtotal').textContent = data.pricing.subtotal;
                        document.getElementById('pricingTaxes').textContent = data.pricing.taxes;
                        document.getElementById('pricingTotal').textContent = data.pricing.total;
                    }
                    if (data.user) {
                        document.getElementById('guestFullName').textContent = data.user.fullName;
                        document.getElementById('guestEmail').textContent = data.user.email;
                    }
                }
            })
            .catch(error => {
                console.warn('Draft booking fetch skipped/failed:', error);
            });
    }

    function handleConfirmBooking(event) {
        event.preventDefault();

        const token = localStorage.getItem('token') || localStorage.getItem('accessToken');
        const bookingToken = document.getElementById('bookingTokenInput').value;
        const submitBtn = document.getElementById('submitBtn');
        const errorBanner = document.getElementById('errorBanner');
        const errorMessage = document.getElementById('errorMessage');

        // Show loading state
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Processing...';
        errorBanner.classList.add('d-none');

        fetch('${ctx}/api/booking/confirm', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            },
            body: JSON.stringify({
                bookingToken: bookingToken
            })
        })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                return response.json().then(err => {
                    throw new Error(err.message || 'Booking confirmation failed');
                });
            })
            .then(data => {
                // Redirect on success to my reservations page
                window.location.href = '${ctx}/reservations?flash=booked';
            })
            .catch(error => {
                // Reset button and show error
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="bi bi-check2-circle me-1"></i>Confirm reservation';

                errorMessage.textContent = error.message || 'An error occurred during booking confirmation. Please try again.';
                errorBanner.classList.remove('d-none');
            });
    }
</script>

<jsp:include page="/common/footer.jsp" />