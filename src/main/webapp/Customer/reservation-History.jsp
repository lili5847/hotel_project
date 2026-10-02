<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

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

        <%-- Alert Banner for Flash / Dynamic Messages --%>
        <div id="flashAlert" class="alert ${param.flash == 'booked' ? 'alert-success' : (param.flash == 'cancelled' ? 'alert-warning' : 'd-none')}" role="alert">
        <span id="flashAlertMessage">
            <c:choose>
                <c:when test="${param.flash == 'booked'}">Your reservation is confirmed. See it below.</c:when>
                <c:when test="${param.flash == 'cancelled'}">Your reservation has been cancelled.</c:when>
            </c:choose>
        </span>
        </div>

        <%-- Navigation Tabs --%>
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

        <%-- Reservation List (Real Backend Version) --%>
        <div id="reservationList">
            <c:choose>
                <c:when test="${empty reservations}">
                    <div class="panel">
                        <div class="panel-empty py-5 text-center">
                            <i class="bi bi-journal-x fs-1 text-muted"></i>
                            <p class="mb-2 mt-2">
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
                        <div class="reservation-card panel mb-3" id="reservation-card-${r.id}">
                            <div class="row g-0 align-items-stretch">
                                <div class="col-4 col-md-3">
                                    <c:url var="thumbUrl" value="/assets/img/${r.image}" />
                                    <img src="${thumbUrl}" alt="${r.roomName}" class="reservation-thumb-img w-100 h-100 object-fit-cover" onerror="this.parentElement.classList.add('reservation-thumb')">
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
                                                <button type="button"
                                                        id="cancelBtn-${r.id}"
                                                        class="btn btn-sm btn-outline-danger mt-md-2"
                                                        onclick="cancelReservation(${r.id})">
                                                    Cancel
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</main>

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION FOR RESERVATION CANCELLATION
============================================================ -->
<script>
    function cancelReservation(reservationId) {
        if (!confirm('Are you sure you want to cancel this reservation?')) {
            return;
        }

        const cancelBtn = document.getElementById('cancelBtn-' + reservationId);
        if (cancelBtn) {
            cancelBtn.disabled = true;
            cancelBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>';
        }

        fetch('${ctx}/api/reservations/cancel', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id: reservationId })
        })
            .then(async response => {
                const data = await response.json().catch(() => ({}));
                if (response.ok) {
                    return data;
                } else {
                    throw { status: response.status, data: data };
                }
            })
            .then(data => {
                // Show success banner
                const flashAlert = document.getElementById('flashAlert');
                const flashAlertMessage = document.getElementById('flashAlertMessage');
                flashAlert.className = 'alert alert-warning';
                flashAlertMessage.textContent = 'Your reservation has been cancelled.';

                // Reload current tab page to refresh server data state
                window.location.reload();
            })
            .catch(error => {
                if (cancelBtn) {
                    cancelBtn.disabled = false;
                    cancelBtn.innerHTML = 'Cancel';
                }

                const flashAlert = document.getElementById('flashAlert');
                const flashAlertMessage = document.getElementById('flashAlertMessage');
                flashAlert.className = 'alert alert-danger';
                flashAlertMessage.textContent = (error.data && error.data.message)
                    ? error.data.message
                    : 'Failed to cancel the reservation. Please try again.';
            });
    }
</script>

<jsp:include page="/common/footer.jsp" />