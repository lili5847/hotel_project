<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Rooms" />
</jsp:include>
<jsp:include page="/common/admin-sidebar.jsp" />

<!-- Dynamic Alert Container -->
<div id="alertContainer"></div>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h4 mb-0">Rooms</h1>
        <p class="text-body-secondary small mb-0">Manage individual rooms and their status.</p>
    </div>
    <button type="button" class="btn btn-primary" onclick="openRoomForm()">
        <i class="bi bi-plus-circle me-1"></i>Add a room
    </button>
</div>

<!-- Filter Bar -->
<div class="panel mb-4">
    <form id="filterForm" class="p-3" onsubmit="event.preventDefault(); loadRooms();">
        <div class="row g-3 align-items-end">
            <div class="col-md-4">
                <label for="q" class="form-label">Room number or name</label>
                <input type="text" class="form-control" id="q" name="q" placeholder="Search room...">
            </div>
            <div class="col-md-3">
                <label for="type" class="form-label">Room type</label>
                <select class="form-select" id="type" name="type">
                    <option value="">All types</option>
                    <option value="POOL_VIEW">Pool view</option>
                    <option value="CITY_VIEW">City view</option>
                    <option value="FAMILY_SUITE">Family suite</option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status">
                    <option value="">All statuses</option>
                    <option value="AVAILABLE">Available</option>
                    <option value="OCCUPIED">Occupied</option>
                    <option value="MAINTENANCE">Under maintenance</option>
                </select>
            </div>
            <div class="col-md-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">Apply</button>
                <button type="button" class="btn btn-outline-secondary" onclick="resetFilters()">Reset</button>
            </div>
        </div>
    </form>
</div>

<div class="row g-4">

    <!-- Rooms Table Panel -->
    <div class="col-lg-8">
        <div class="panel">
            <div class="panel-header">
                <h2 class="h5 mb-0">
                    All rooms
                    <span id="roomCount" class="text-body-secondary fw-normal"></span>
                </h2>
            </div>

            <div class="table-responsive">
                <table class="table admin-table align-middle mb-0">
                    <thead>
                    <tr>
                        <th>Room</th>
                        <th>Type</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                    </thead>
                    <tbody id="roomsTableBody">
                    <tr>
                        <td colspan="5" class="text-center py-4">Loading data...</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add / Edit Form Panel -->
    <div class="col-lg-4">
        <div class="panel" id="roomFormPanel">
            <div class="panel-header">
                <h2 class="h6 mb-0" id="roomFormTitle">Add a room</h2>
            </div>

            <form id="roomForm" onsubmit="saveRoom(event)" class="p-3">
                <input type="hidden" id="roomId" value="">

                <div class="mb-3">
                    <label for="roomNumber" class="form-label small fw-medium">Room number</label>
                    <input type="text" class="form-control" id="roomNumber" required>
                </div>
                <div class="mb-3">
                    <label for="name" class="form-label small fw-medium">Display name</label>
                    <input type="text" class="form-control" id="name" required>
                </div>
                <div class="mb-3">
                    <label for="roomType" class="form-label small fw-medium">Room type</label>
                    <select class="form-select" id="roomType" required>
                        <option value="POOL_VIEW">Pool view</option>
                        <option value="CITY_VIEW">City view</option>
                        <option value="FAMILY_SUITE">Family suite</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="price" class="form-label small fw-medium">Price per night</label>
                    <div class="input-group">
                        <span class="input-group-text">$</span>
                        <input type="number" min="0" step="1" class="form-control" id="price" required>
                    </div>
                </div>
                <div class="mb-4">
                    <label for="roomStatus" class="form-label small fw-medium">Status</label>
                    <select class="form-select" id="roomStatus" required>
                        <option value="AVAILABLE">Available</option>
                        <option value="OCCUPIED">Occupied</option>
                        <option value="MAINTENANCE">Under maintenance</option>
                    </select>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary flex-grow-1" id="roomFormSubmit">Add room</button>
                    <button type="button" class="btn btn-outline-secondary" onclick="resetRoomForm()">Clear</button>
                </div>
            </form>
        </div>
    </div>

</div>

<jsp:include page="/common/admin-footer.jsp" />

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION FOR ROOMS
============================================================ -->
<script>
    let roomsData = [];

    document.addEventListener("DOMContentLoaded", function () {
        loadRooms();
    });

    function loadRooms() {
        const token = localStorage.getItem('accessToken');

        const q = document.getElementById('q').value;
        const type = document.getElementById('type').value;
        const status = document.getElementById('status').value;

        let params = new URLSearchParams();
        if (q) params.append('q', q);
        if (type) params.append('type', type);
        if (status) params.append('status', status);

        fetch(`${ctx}/api/admin/rooms?${params.toString()}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) throw new Error('Failed to fetch rooms');
                return response.json();
            })
            .then(data => {
                roomsData = Array.isArray(data) ? data : (data.content || data.data || []);
                renderRoomsTable(roomsData);
            })
            .catch(error => {
                console.error('Error fetching rooms:', error);
                document.getElementById('roomsTableBody').innerHTML = `
            <tr>
                <td colspan="5" class="text-center text-danger py-4">
                    Nakamaisyu ti panag-fetch ti datos dagiti kuarto.
                </td>
            </tr>`;
            });
    }

    function renderRoomsTable(rooms) {
        const tbody = document.getElementById('roomsTableBody');
        const countSpan = document.getElementById('roomCount');

        countSpan.textContent = `(${rooms.length})`;

        if (rooms.length === 0) {
            tbody.innerHTML = `
            <tr>
                <td colspan="5" class="text-center py-4">
                    <i class="bi bi-door-closed fs-3 text-secondary"></i>
                    <p class="mb-0 mt-2">No rooms match these filters.</p>
                </td>
            </tr>`;
            return;
        }

        let html = '';
        rooms.forEach(room => {
            let badgeClass = 'status-pending';
            let statusText = 'Maintenance';

            if (room.status === 'AVAILABLE') {
                badgeClass = 'status-confirmed';
                statusText = 'Available';
            } else if (room.status === 'OCCUPIED') {
                badgeClass = 'status-checked-in';
                statusText = 'Occupied';
            }

            const typeLabel = room.typeLabel || formatTypeLabel(room.type);

            html += `
            <tr>
                <td>
                    <div class="fw-medium">Room ${escapeHtml(room.roomNumber)}</div>
                    <div class="small text-body-secondary">${escapeHtml(room.name || '')}</div>
                </td>
                <td>${escapeHtml(typeLabel)}</td>
                <td>&#36;${room.price || 0}</td>
                <td>
                    <span class="badge status-badge ${badgeClass}">${statusText}</span>
                </td>
                <td class="text-end text-nowrap">
                    <button type="button" class="btn btn-sm btn-outline-secondary"
                            onclick="editRoom(${room.id})">
                        <i class="bi bi-pencil"></i>
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-danger"
                            onclick="deleteRoom(${room.id})">
                        <i class="bi bi-trash"></i>
                    </button>
                </td>
            </tr>`;
        });

        tbody.innerHTML = html;
    }

    function saveRoom(event) {
        event.preventDefault();
        const token = localStorage.getItem('accessToken');

        const id = document.getElementById('roomId').value;
        const roomNumber = document.getElementById('roomNumber').value;
        const name = document.getElementById('name').value;
        const type = document.getElementById('roomType').value;
        const price = document.getElementById('price').value;
        const status = document.getElementById('roomStatus').value;

        const payload = {
            roomNumber: roomNumber,
            name: name,
            type: type,
            price: parseFloat(price),
            status: status
        };

        const isUpdate = id !== '';
        const url = isUpdate ? `${ctx}/api/admin/rooms/${id}` : `${ctx}/api/admin/rooms`;
        const method = isUpdate ? 'PUT' : 'POST';

        fetch(url, {
            method: method,
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            },
            body: JSON.stringify(payload)
        })
            .then(response => {
                if (response.ok) {
                    showAlert(isUpdate ? 'Room updated successfully.' : 'Room added successfully.', 'success');
                    resetRoomForm();
                    loadRooms();
                } else {
                    showAlert('Something went wrong. Please try again.', 'danger');
                }
            })
            .catch(error => {
                console.error('Error saving room:', error);
                showAlert('Something went wrong. Please try again.', 'danger');
            });
    }

    function deleteRoom(id) {
        if (!confirm('Remove this room? This cannot be undone.')) return;

        const token = localStorage.getItem('accessToken');

        fetch(`${ctx}/api/admin/rooms/${id}`, {
            method: 'DELETE',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (response.ok) {
                    showAlert('Room removed successfully.', 'warning');
                    loadRooms();
                } else {
                    showAlert('Cannot remove room with active bookings or something went wrong.', 'danger');
                }
            })
            .catch(error => {
                console.error('Error deleting room:', error);
                showAlert('Something went wrong. Please try again.', 'danger');
            });
    }

    function editRoom(id) {
        const room = roomsData.find(r => r.id === id);
        if (!room) return;

        document.getElementById('roomFormTitle').textContent = 'Edit room ' + room.roomNumber;
        document.getElementById('roomId').value = room.id;
        document.getElementById('roomNumber').value = room.roomNumber;
        document.getElementById('name').value = room.name;
        document.getElementById('roomType').value = room.type;
        document.getElementById('price').value = room.price;
        document.getElementById('roomStatus').value = room.status;
        document.getElementById('roomFormSubmit').textContent = 'Save changes';
        document.getElementById('roomFormPanel').scrollIntoView({ behavior: 'smooth' });
    }

    function openRoomForm() {
        resetRoomForm();
        document.getElementById('roomFormPanel').scrollIntoView({ behavior: 'smooth' });
    }

    function resetRoomForm() {
        document.getElementById('roomFormTitle').textContent = 'Add a room';
        document.getElementById('roomId').value = '';
        document.getElementById('roomForm').reset();
        document.getElementById('roomFormSubmit').textContent = 'Add room';
    }

    function resetFilters() {
        document.getElementById('filterForm').reset();
        loadRooms();
    }

    function showAlert(message, type) {
        const alertContainer = document.getElementById('alertContainer');
        alertContainer.innerHTML = `
        <div class="alert alert-${type} alert-dismissible fade show mb-4" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>`;
    }

    function formatTypeLabel(type) {
        if (type === 'POOL_VIEW') return 'Pool view';
        if (type === 'CITY_VIEW') return 'City view';
        if (type === 'FAMILY_SUITE') return 'Family suite';
        return type || '';
    }

    function escapeHtml(str) {
        return String(str || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }
</script>