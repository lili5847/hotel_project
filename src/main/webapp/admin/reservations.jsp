<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Reservations" />
</jsp:include>
<jsp:include page="/common/admin-sidebar.jsp" />

<!-- Dynamic Alert Container -->
<div id="alertContainer"></div>

<!-- Filter Panel -->
<div class="panel mb-4">
    <div class="panel-header">
        <h2 class="h5 mb-0">Filter reservations</h2>
    </div>
    <form id="filterForm" class="p-3" onsubmit="event.preventDefault(); loadReservations(1);">
        <div class="row g-3 align-items-end">
            <div class="col-md-3">
                <label for="q" class="form-label">Guest name or email</label>
                <input type="text" class="form-control" id="q" name="q" placeholder="Search guest">
            </div>
            <div class="col-md-2">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status">
                    <option value="">All statuses</option>
                    <option value="PENDING">Pending</option>
                    <option value="CONFIRMED">Confirmed</option>
                    <option value="CHECKED_IN">Checked in</option>
                    <option value="CANCELLED">Cancelled</option>
                </select>
            </div>
            <div class="col-md-2">
                <label for="from" class="form-label">From</label>
                <input type="date" class="form-control" id="from" name="from">
            </div>
            <div class="col-md-2">
                <label for="to" class="form-label">To</label>
                <input type="date" class="form-control" id="to" name="to">
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">
                    <i class="bi bi-funnel me-1"></i>Apply
                </button>
                <button type="button" class="btn btn-outline-secondary" onclick="resetFilters()">Reset</button>
            </div>
        </div>
    </form>
</div>

<!-- Reservations Table Panel -->
<div class="panel">
    <div class="panel-header">
        <h2 class="h5 mb-0">
            Reservations
            <span id="reservationCount" class="text-body-secondary fw-normal"></span>
        </h2>
    </div>

    <div class="table-responsive">
        <table class="table admin-table align-middle mb-0">
            <thead>
            <tr>
                <th>Guest</th>
                <th>Room</th>
                <th>Check-in</th>
                <th>Check-out</th>
                <th>Nights</th>
                <th>Total</th>
                <th>Status</th>
                <th class="text-end">Actions</th>
            </tr>
            </thead>
            <tbody id="reservationsTableBody">
            <tr>
                <td colspan="8" class="text-center py-4">Loading data...</td>
            </tr>
            </tbody>
        </table>
    </div>

    <!-- Dynamic Pagination -->
    <nav class="d-flex justify-content-center py-3" aria-label="Reservations pages">
        <ul class="pagination mb-0" id="pagination"></ul>
    </nav>
</div>

<jsp:include page="/common/admin-footer.jsp" />

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION FOR RESERVATIONS
============================================================ -->
<script>
    let currentPage = 1;

    document.addEventListener("DOMContentLoaded", function () {
        loadReservations(1);
    });

    function loadReservations(page = 1) {
        currentPage = page;
        const token = localStorage.getItem('accessToken');

        const q = document.getElementById('q').value;
        const status = document.getElementById('status').value;
        const from = document.getElementById('from').value;
        const to = document.getElementById('to').value;

        let params = new URLSearchParams();
        params.append('page', page);
        if (q) params.append('q', q);
        if (status) params.append('status', status);
        if (from) params.append('from', from);
        if (to) params.append('to', to);

        fetch(`${ctx}/api/admin/reservations?${params.toString()}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) throw new Error('Failed to fetch reservations');
                return response.json();
            })
            .then(data => {
                const reservations = Array.isArray(data) ? data : (data.content || data.data || []);
                const totalPages = data.totalPages || 1;

                renderReservationsTable(reservations);
                renderPagination(totalPages, currentPage);
            })
            .catch(error => {
                console.error('Error fetching reservations:', error);
                document.getElementById('reservationsTableBody').innerHTML = `
            <tr>
                <td colspan="8" class="text-center text-danger py-4">
                    Nakamaisyu ti panag-fetch ti datos dagiti reservation.
                </td>
            </tr>`;
            });
    }

    function renderReservationsTable(reservations) {
        const tbody = document.getElementById('reservationsTableBody');
        const countSpan = document.getElementById('reservationCount');

        countSpan.textContent = `(${reservations.length} shown)`;

        if (reservations.length === 0) {
            tbody.innerHTML = `
            <tr>
                <td colspan="8" class="text-center py-4">
                    <i class="bi bi-journal-x fs-3 text-secondary"></i>
                    <p class="mb-0 mt-2">No reservations match these filters.</p>
                </td>
            </tr>`;
            return;
        }

        let html = '';
        reservations.forEach(r => {
            let badgeClass = 'status-pending';
            let statusText = 'Pending';

            if (r.status === 'CONFIRMED') {
                badgeClass = 'status-confirmed';
                statusText = 'Confirmed';
            } else if (r.status === 'CHECKED_IN') {
                badgeClass = 'status-checked-in';
                statusText = 'Checked in';
            } else if (r.status === 'CANCELLED') {
                badgeClass = 'status-cancelled';
                statusText = 'Cancelled';
            }

            let actionsHtml = `<div class="d-inline-flex gap-1">`;

            if (r.status === 'PENDING') {
                actionsHtml += `
                <button type="button" class="btn btn-sm btn-outline-primary" title="Confirm" onclick="updateReservationStatus(${r.id}, 'confirm')">
                    <i class="bi bi-check2"></i>
                </button>`;
            }
            if (r.status === 'CONFIRMED') {
                actionsHtml += `
                <button type="button" class="btn btn-sm btn-outline-primary" title="Check in" onclick="updateReservationStatus(${r.id}, 'check_in')">
                    <i class="bi bi-box-arrow-in-right"></i>
                </button>`;
            }
            if (r.status !== 'CANCELLED' && r.status !== 'CHECKED_IN') {
                actionsHtml += `
                <button type="button" class="btn btn-sm btn-outline-danger" title="Cancel" onclick="updateReservationStatus(${r.id}, 'cancel')">
                    <i class="bi bi-x-lg"></i>
                </button>`;
            }

            actionsHtml += `
            <a href="${ctx}/admin/reservations?id=${r.id}" class="btn btn-sm btn-outline-secondary" title="View details">
                <i class="bi bi-eye"></i>
            </a>
        </div>`;

            html += `
            <tr>
                <td>
                    <div class="fw-medium">${r.guestName || 'N/A'}</div>
                    <div class="small text-body-secondary">${r.guestEmail || ''}</div>
                </td>
                <td>${r.roomLabel || 'N/A'}</td>
                <td>${r.checkIn || 'N/A'}</td>
                <td>${r.checkOut || 'N/A'}</td>
                <td>${r.nights || 0}</td>
                <td>&#36;${r.total || 0}</td>
                <td>
                    <span class="badge status-badge ${badgeClass}">${statusText}</span>
                </td>
                <td class="text-end text-nowrap">${actionsHtml}</td>
            </tr>`;
        });

        tbody.innerHTML = html;
    }

    function updateReservationStatus(id, action) {
        if (action === 'cancel' && !confirm('Cancel this reservation?')) return;

        const token = localStorage.getItem('accessToken');

        fetch(`${ctx}/api/admin/reservations/${id}/${action}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (response.ok) {
                    showAlert('Reservation status updated successfully!', 'success');
                    loadReservations(currentPage);
                } else {
                    showAlert('Something went wrong. Please try again.', 'danger');
                }
            })
            .catch(error => {
                console.error('Error updating reservation:', error);
                showAlert('Something went wrong. Please try again.', 'danger');
            });
    }

    function renderPagination(totalPages, currentPage) {
        const paginationUl = document.getElementById('pagination');
        if (totalPages <= 1) {
            paginationUl.innerHTML = '';
            return;
        }

        let html = '';
        for (let i = 1; i <= totalPages; i++) {
            const activeClass = i === currentPage ? 'active' : '';
            html += `
            <li class="page-item ${activeClass}">
                <button class="page-link" onclick="loadReservations(${i})">${i}</button>
            </li>`;
        }
        paginationUl.innerHTML = html;
    }

    function resetFilters() {
        document.getElementById('filterForm').reset();
        loadReservations(1);
    }

    function showAlert(message, type) {
        const alertContainer = document.getElementById('alertContainer');
        alertContainer.innerHTML = `
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>`;
    }
</script>