<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Rooms" />
</jsp:include>
<jsp:include page="/common/admin-sidebar.jsp" />

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

<!-- Filter bar (filters run in the browser; the API has no filter params) -->
<div class="panel mb-4">
    <form id="filterForm" class="p-3" onsubmit="event.preventDefault(); applyFilters();">
        <div class="row g-3 align-items-end">
            <div class="col-md-4">
                <label for="q" class="form-label">Room number or description</label>
                <input type="text" class="form-control" id="q" placeholder="Search room...">
            </div>
            <div class="col-md-3">
                <label for="type" class="form-label">Room type</label>
                <select class="form-select" id="type">
                    <option value="">All types</option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status">
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

    <div class="col-lg-8">
        <div class="panel">
            <div class="panel-header">
                <h2 class="h5 mb-0">All rooms <span id="roomCount" class="text-body-secondary fw-normal"></span></h2>
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
                    <tr><td colspan="5" class="text-center py-4">Loading data...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

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
                    <label for="floor" class="form-label small fw-medium">Floor</label>
                    <input type="number" min="0" step="1" class="form-control" id="floor" required>
                </div>
                <div class="mb-3">
                    <label for="description" class="form-label small fw-medium">Description</label>
                    <input type="text" class="form-control" id="description">
                </div>
                <div class="mb-3">
                    <label for="roomTypeSelect" class="form-label small fw-medium">Room type</label>
                    <select class="form-select" id="roomTypeSelect" onchange="toggleNewType()"></select>
                </div>

                <!-- Shown only when "+ New room type" is selected -->
                <div id="newTypeFields" class="border rounded p-3 mb-3 d-none">
                    <div class="mb-2">
                        <label for="typeName" class="form-label small fw-medium">Type name</label>
                        <input type="text" class="form-control" id="typeName">
                    </div>
                    <div class="mb-2">
                        <label for="price" class="form-label small fw-medium">Price per night</label>
                        <div class="input-group">
                            <span class="input-group-text">$</span>
                            <input type="number" min="0" step="1" class="form-control" id="price">
                        </div>
                    </div>
                    <div class="mb-2">
                        <label for="capacity" class="form-label small fw-medium">Capacity (guests)</label>
                        <input type="number" min="1" step="1" class="form-control" id="capacity">
                    </div>
                    <div class="mb-2">
                        <label for="amenities" class="form-label small fw-medium">Amenities</label>
                        <input type="text" class="form-control" id="amenities" placeholder="Free Wi-Fi, Air conditioning">
                    </div>
                    <div>
                        <label for="typeDescription" class="form-label small fw-medium">Type description</label>
                        <input type="text" class="form-control" id="typeDescription">
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

<script>
    const ctx = '<%= request.getContextPath() %>';
    const token = localStorage.getItem('accessToken');
    if (!token) { window.location.href = ctx + '/login'; }

    let roomsData = [];   // rooms from GET /api/rooms
    let typesData = [];   // distinct room types found in those rooms

    document.addEventListener('DOMContentLoaded', function () {
        loadRooms();
    });

    // ---- API helper: adds the token, unwraps ApiResponse errors ----
    function api(path, options) {
        options = options || {};
        options.headers = Object.assign({
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + token
        }, options.headers || {});

        return fetch(ctx + path, options).then(function (response) {
            if (response.status === 401) {
                localStorage.removeItem('accessToken');
                window.location.href = ctx + '/login';
                throw new Error('Unauthorized');
            }
            return response.json().catch(function () { return {}; }).then(function (body) {
                if (!response.ok) {
                    throw new Error(body.message || ('HTTP ' + response.status));
                }
                return body;
            });
        });
    }

    // ---- Load + render ----
    function loadRooms() {
        api('/api/rooms', { method: 'GET' })
            .then(function (res) {
                roomsData = Array.isArray(res.data) ? res.data : [];
                buildTypes();
                applyFilters();
            })
            .catch(function (error) {
                console.error('Error fetching rooms:', error);
                document.getElementById('roomsTableBody').innerHTML =
                    '<tr><td colspan="5" class="text-center text-danger py-4">Could not load rooms: ' +
                    escapeHtml(error.message) + '</td></tr>';
            });
    }

    function buildTypes() {
        const seen = {};
        typesData = [];
        roomsData.forEach(function (r) {
            const t = r.roomType;
            if (t && t.roomTypeId != null && !seen[t.roomTypeId]) {
                seen[t.roomTypeId] = true;
                typesData.push(t);
            }
        });

        const filterSel = document.getElementById('type');
        const keepFilter = filterSel.value;
        filterSel.innerHTML = '<option value="">All types</option>' + typesData.map(function (t) {
            return '<option value="' + t.roomTypeId + '">' + escapeHtml(t.typeName) + '</option>';
        }).join('');
        filterSel.value = keepFilter;

        const formSel = document.getElementById('roomTypeSelect');
        const keepForm = formSel.value;
        formSel.innerHTML = typesData.map(function (t) {
            return '<option value="' + t.roomTypeId + '">' + escapeHtml(t.typeName) +
                   ' ($' + (t.price || 0) + ')</option>';
        }).join('') + '<option value="new">+ New room type...</option>';
        formSel.value = keepForm || (typesData.length ? String(typesData[0].roomTypeId) : 'new');
        if (!formSel.value) formSel.value = 'new';
        toggleNewType();
    }

    function applyFilters() {
        const q = document.getElementById('q').value.trim().toLowerCase();
        const type = document.getElementById('type').value;
        const status = document.getElementById('status').value;

        const filtered = roomsData.filter(function (r) {
            if (q) {
                const hay = ((r.roomNumber || '') + ' ' + (r.description || '')).toLowerCase();
                if (hay.indexOf(q) === -1) return false;
            }
            if (type && String(r.roomType && r.roomType.roomTypeId) !== type) return false;
            if (status && r.status !== status) return false;
            return true;
        });
        renderRoomsTable(filtered);
    }

    function renderRoomsTable(rooms) {
        const tbody = document.getElementById('roomsTableBody');
        document.getElementById('roomCount').textContent = '(' + rooms.length + ')';

        if (rooms.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center py-4">' +
                '<i class="bi bi-door-closed fs-3 text-secondary"></i>' +
                '<p class="mb-0 mt-2">No rooms match these filters.</p></td></tr>';
            return;
        }

        tbody.innerHTML = rooms.map(function (room) {
            let badgeClass = 'status-pending';
            let statusText = room.status || 'Unknown';
            if (room.status === 'AVAILABLE') { badgeClass = 'status-confirmed'; statusText = 'Available'; }
            else if (room.status === 'OCCUPIED') { badgeClass = 'status-checked-in'; statusText = 'Occupied'; }
            else if (room.status === 'MAINTENANCE') { statusText = 'Maintenance'; }

            const t = room.roomType || {};
            return '<tr>' +
                '<td><div class="fw-medium">Room ' + escapeHtml(room.roomNumber) + '</div>' +
                '<div class="small text-body-secondary">Floor ' + escapeHtml(room.floor) +
                (room.description ? ' &middot; ' + escapeHtml(room.description) : '') + '</div></td>' +
                '<td>' + escapeHtml(t.typeName || '') + '</td>' +
                '<td>&#36;' + (t.price || 0) + '</td>' +
                '<td><span class="badge status-badge ' + badgeClass + '">' + escapeHtml(statusText) + '</span></td>' +
                '<td class="text-end text-nowrap">' +
                '<button type="button" class="btn btn-sm btn-outline-secondary" onclick="editRoom(' + room.roomId + ')"><i class="bi bi-pencil"></i></button> ' +
                '<button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteRoom(' + room.roomId + ')"><i class="bi bi-trash"></i></button>' +
                '</td></tr>';
        }).join('');
    }

    // ---- Create / update ----
    function saveRoom(event) {
        event.preventDefault();

        const id = document.getElementById('roomId').value;
        const sel = document.getElementById('roomTypeSelect').value;

        let roomType;
        if (sel === 'new') {
            roomType = {
                typeName: document.getElementById('typeName').value,
                description: document.getElementById('typeDescription').value,
                price: parseFloat(document.getElementById('price').value),
                capacity: parseInt(document.getElementById('capacity').value, 10),
                amenities: document.getElementById('amenities').value
            };
        } else {
            roomType = typesData.find(function (t) { return String(t.roomTypeId) === sel; });
        }

        const payload = {
            roomNumber: document.getElementById('roomNumber').value,
            floor: parseInt(document.getElementById('floor').value, 10),
            description: document.getElementById('description').value,
            status: document.getElementById('roomStatus').value,
            roomType: roomType
        };

        const isUpdate = id !== '';
        if (isUpdate) payload.roomId = parseInt(id, 10);

        api(isUpdate ? '/api/rooms/' + id : '/api/rooms', {
            method: isUpdate ? 'PUT' : 'POST',
            body: JSON.stringify(payload)
        })
            .then(function () {
                showAlert(isUpdate ? 'Room updated successfully.' : 'Room added successfully.', 'success');
                resetRoomForm();
                loadRooms();
            })
            .catch(function (error) {
                console.error('Error saving room:', error);
                showAlert('Could not save room: ' + escapeHtml(error.message), 'danger');
            });
    }

    function deleteRoom(id) {
        if (!confirm('Remove this room? This cannot be undone.')) return;

        api('/api/rooms/' + id, { method: 'DELETE' })
            .then(function () {
                showAlert('Room removed successfully.', 'warning');
                loadRooms();
            })
            .catch(function (error) {
                console.error('Error deleting room:', error);
                showAlert('Could not remove room: ' + escapeHtml(error.message), 'danger');
            });
    }

    // ---- Form helpers ----
    function editRoom(id) {
        const room = roomsData.find(function (r) { return r.roomId === id; });
        if (!room) return;

        document.getElementById('roomFormTitle').textContent = 'Edit room ' + room.roomNumber;
        document.getElementById('roomId').value = room.roomId;
        document.getElementById('roomNumber').value = room.roomNumber || '';
        document.getElementById('floor').value = room.floor != null ? room.floor : '';
        document.getElementById('description').value = room.description || '';
        document.getElementById('roomStatus').value = room.status || 'AVAILABLE';
        if (room.roomType && room.roomType.roomTypeId != null) {
            document.getElementById('roomTypeSelect').value = String(room.roomType.roomTypeId);
        }
        toggleNewType();
        document.getElementById('roomFormSubmit').textContent = 'Save changes';
        document.getElementById('roomFormPanel').scrollIntoView({ behavior: 'smooth' });
    }

    function toggleNewType() {
        const isNew = document.getElementById('roomTypeSelect').value === 'new';
        document.getElementById('newTypeFields').classList.toggle('d-none', !isNew);
        ['typeName', 'price', 'capacity'].forEach(function (f) {
            document.getElementById(f).required = isNew;
        });
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
        buildTypes();
    }

    function resetFilters() {
        document.getElementById('filterForm').reset();
        applyFilters();
    }

    function showAlert(message, type) {
        document.getElementById('alertContainer').innerHTML =
            '<div class="alert alert-' + type + ' alert-dismissible fade show mb-4" role="alert">' +
            message +
            '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button></div>';
    }

    function escapeHtml(str) {
        return String(str == null ? '' : str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }
</script>
