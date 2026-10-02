<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Admin dashboard" />
</jsp:include>
<jsp:include page="/common/admin-sidebar.jsp" />

<!-- Dynamic Stats Cards -->
<div class="row g-3 g-lg-4 mb-4">
    <div class="col-6 col-lg-3">
        <div class="stat-card">
            <span class="stat-icon bg-icon-teal"><i class="bi bi-door-open"></i></span>
            <div class="stat-value" id="statTotalRooms">0</div>
            <div class="stat-label">Total rooms</div>
        </div>
    </div>
    <div class="col-6 col-lg-3">
        <div class="stat-card">
            <span class="stat-icon bg-icon-green"><i class="bi bi-check2-circle"></i></span>
            <div class="stat-value" id="statAvailableRooms">0</div>
            <div class="stat-label">Available today</div>
        </div>
    </div>
    <div class="col-6 col-lg-3">
        <div class="stat-card">
            <span class="stat-icon bg-icon-amber"><i class="bi bi-box-arrow-in-right"></i></span>
            <div class="stat-value" id="statTodayCheckIns">0</div>
            <div class="stat-label">Check-ins today</div>
        </div>
    </div>
    <div class="col-6 col-lg-3">
        <div class="stat-card">
            <span class="stat-icon bg-icon-plum"><i class="bi bi-people"></i></span>
            <div class="stat-value" id="statTotalCustomers">0</div>
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
                    <tbody id="recentReservationsBody">
                    <tr>
                        <td colspan="6" class="text-center py-4">Loading data...</td>
                    </tr>
                    </tbody>
                </table>
            </div>
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

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION FOR DASHBOARD
============================================================ -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        loadDashboardData();
    });

    function loadDashboardData() {
        const token = localStorage.getItem('accessToken');

        // 1. Fetch Stats / Dashboard overview
        fetch('${ctx}/api/admin/dashboard/stats', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(res => res.json())
            .then(data => {
                const stats = data.data || data;
                document.getElementById('statTotalRooms').textContent = stats.totalRooms || 0;
                document.getElementById('statAvailableRooms').textContent = stats.availableRooms || 0;
                document.getElementById('statTodayCheckIns').textContent = stats.todayCheckIns || 0;
                document.getElementById('statTotalCustomers').textContent = stats.totalCustomers || 0;
            })
            .catch(err => console.error('Error fetching dashboard stats:', err));

        // 2. Fetch Recent Reservations
        fetch('${ctx}/api/reservations', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(res => res.json())
            .then(data => {
                const reservations = Array.isArray(data) ? data : (data.data || []);
                renderRecentReservations(reservations.slice(0, 5)); // Aggap laeng ti 5 nga kabarbaro
            })
            .catch(err => {
                console.error('Error fetching reservations:', err);
                document.getElementById('recentReservationsBody').innerHTML = `
            <tr>
                <td colspan="6" class="text-center text-danger py-4">
                    Nakamaisyu ti panag-fetch ti datos dagiti reservation.
                </td>
            </tr>`;
            });
    }

    function renderRecentReservations(reservations) {
        const tbody = document.getElementById('recentReservationsBody');

        if (reservations.length === 0) {
            tbody.innerHTML = `
            <tr>
                <td colspan="6" class="text-center py-4">
                    <i class="bi bi-journal-x fs-3 text-secondary"></i>
                    <p class="mb-0 mt-2">Awan pay ti reservation a maiparang.</p>
                </td>
            </tr>`;
            return;
        }

        let html = '';
        reservations.forEach(r => {
            let badgeClass = 'status-pending';
            let statusText = r.status || 'PENDING';

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

            html += `
            <tr>
                <td>${r.guestName || r.userName || 'N/A'}</td>
                <td>${r.roomLabel || r.roomNumber || 'N/A'}</td>
                <td>${r.checkIn || 'N/A'}</td>
                <td>${r.checkOut || 'N/A'}</td>
                <td>
                    <span class="badge status-badge ${badgeClass}">${statusText}</span>
                </td>
                <td class="text-end">
                    <a href="${ctx}/admin/reservations?id=${r.id}" class="small">Manage</a>
                </td>
            </tr>`;
        });

        tbody.innerHTML = html;
    }
</script>