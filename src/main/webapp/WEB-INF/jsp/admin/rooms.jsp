<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>

<jsp:include page="/WEB-INF/jsp/common/admin-header.jsp">
    <jsp:param name="title" value="Rooms" />
</jsp:include>
<jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp" />

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

<jsp:include page="/WEB-INF/jsp/common/admin-footer.jsp" />
<script>

    const ctx = '<%= request.getContextPath() %>';
    const token = localStorage.getItem('token');

    let roomsData = [];
    let typesData = [];


    document.addEventListener('DOMContentLoaded', function () {

        console.log('ROOMS PAGE LOADED');
        console.log('Token exists:', !!token);

        loadRooms();

        const q = document.getElementById('q');
        const type = document.getElementById('type');
        const status = document.getElementById('status');

        if (q) {
            q.addEventListener('input', applyFilters);
        }

        if (type) {
            type.addEventListener('change', applyFilters);
        }

        if (status) {
            status.addEventListener('change', applyFilters);
        }
    });


    /*
     * =========================================================
     * API HELPER
     * =========================================================
     */

    function api(path, options) {

        options = options || {};

        options.headers = Object.assign({
            'Content-Type': 'application/json'
        }, options.headers || {});

        if (token) {
            options.headers['Authorization'] =
                'Bearer ' + token;
        }

        return fetch(ctx + path, options)
            .then(function (response) {

                console.log(
                    'API:',
                    path,
                    'STATUS:',
                    response.status
                );

                return response.json()
                    .catch(function () {
                        return {};
                    })
                    .then(function (body) {

                        if (!response.ok) {

                            if (response.status === 401) {
                                localStorage.removeItem('token');
                            }

                            throw new Error(
                                body.message ||
                                ('HTTP ' + response.status)
                            );
                        }

                        return body;
                    });
            });
    }


    /*
     * =========================================================
     * LOAD ROOMS
     * =========================================================
     */

     function loadRooms() {

    	    api('/api/rooms', {
    	        method: 'GET'
    	    })
    	    .then(function(res) {

    	        console.log('ROOM API RESPONSE:', res);

    	        roomsData = Array.isArray(res.data)
    	            ? res.data
    	            : [];

    	        console.log('ROOMS DATA:', roomsData);

    	        // IMPORTANT:
    	        // Room types are extracted only after rooms have loaded.
    	        loadRoomTypes();

    	        // Build room-type filter
    	        buildTypeFilter();

    	        // Render rooms
    	        applyFilters();

    	    })
    	    .catch(function(error) {

    	        console.error('Error loading rooms:', error);

    	        showAlert(
    	            'danger',
    	            'Could not load rooms: ' + escapeHtml(error.message)
    	        );
    	    });
    	}


    /*
     * =========================================================
     * LOAD ROOM TYPES
     * =========================================================
     */

    function loadRoomTypes() {

        /*
         * We first try the existing room API data.
         * Every room already contains roomType.
         */

        const typeMap = {};

        roomsData.forEach(function (room) {

            if (
                room.roomType &&
                room.roomType.roomTypeId
            ) {

                typeMap[
                    room.roomType.roomTypeId
                ] = room.roomType;
            }
        });

        typesData = Object.keys(typeMap)
            .map(function (key) {
                return typeMap[key];
            });

        buildRoomTypeSelect();
    }


    /*
     * =========================================================
     * ROOM TYPE FILTER
     * =========================================================
     */

    function buildTypeFilter() {

        const select =
            document.getElementById('type');

        if (!select) {
            return;
        }

        const existingValue =
            select.value;

        const types = {};

        roomsData.forEach(function (room) {

            if (
                room.roomType &&
                room.roomType.roomTypeId
            ) {

                types[
                    room.roomType.roomTypeId
                ] = room.roomType.typeName;
            }
        });

        select.innerHTML =
            '<option value="">All types</option>';

        Object.keys(types).forEach(function (id) {

            const option =
                document.createElement('option');

            option.value = id;
            option.textContent = types[id];

            select.appendChild(option);
        });

        select.value = existingValue;
    }


    /*
     * =========================================================
     * ROOM TYPE FORM SELECT
     * =========================================================
     */

    function buildRoomTypeSelect() {

        const select =
            document.getElementById('roomTypeSelect');

        if (!select) {
            return;
        }

        select.innerHTML =
            '<option value="">Select room type</option>';

        typesData.forEach(function (type) {

            const option =
                document.createElement('option');

            option.value = type.roomTypeId;
            option.textContent =
                type.typeName +
                (type.price != null
                    ? ' - $' + type.price
                    : '');

            select.appendChild(option);
        });

        select.innerHTML +=
            '<option value="NEW">+ New room type</option>';
    }


    /*
     * =========================================================
     * FILTER ROOMS
     * =========================================================
     */

    function applyFilters() {

        const q =
            document.getElementById('q');

        const type =
            document.getElementById('type');

        const status =
            document.getElementById('status');


        const search =
            q
                ? q.value.toLowerCase().trim()
                : '';


        const typeId =
            type
                ? type.value
                : '';


        const statusValue =
            status
                ? status.value
                : '';


        const filtered =
            roomsData.filter(function (room) {

                const roomNumber =
                    String(
                        room.roomNumber || ''
                    ).toLowerCase();

                const description =
                    String(
                        room.description || ''
                    ).toLowerCase();

                const roomTypeId =
                    room.roomType &&
                    room.roomType.roomTypeId
                        ? String(
                            room.roomType.roomTypeId
                        )
                        : '';

                const roomStatus =
                    String(room.status || '');


                const matchesSearch =
                    !search ||
                    roomNumber.includes(search) ||
                    description.includes(search);


                const matchesType =
                    !typeId ||
                    roomTypeId === typeId;


                const matchesStatus =
                    !statusValue ||
                    roomStatus === statusValue;


                return (
                    matchesSearch &&
                    matchesType &&
                    matchesStatus
                );
            });


        renderRooms(filtered);
    }


    /*
     * =========================================================
     * RENDER TABLE
     * =========================================================
     */

    function renderRooms(rooms) {

        const tbody =
            document.getElementById(
                'roomsTableBody'
            );

        const count =
            document.getElementById(
                'roomCount'
            );


        if (!tbody) {
            return;
        }


        if (count) {
            count.textContent =
                '(' + rooms.length + ')';
        }


        if (rooms.length === 0) {

            tbody.innerHTML =
                '<tr>' +
                '<td colspan="5" ' +
                'class="text-center py-4">' +
                'No rooms found.' +
                '</td>' +
                '</tr>';

            return;
        }


        tbody.innerHTML =
            rooms.map(function (room) {

                const roomType =
                    room.roomType
                        ? room.roomType.typeName || '-'
                        : '-';


                const price =
                    room.roomType &&
                    room.roomType.price != null
                        ? '$' +
                          Number(
                              room.roomType.price
                          ).toFixed(2)
                        : '-';


                const status =
                    room.status || '-';


                return (
                    '<tr>' +

                    '<td>' +
                    '<strong>' +
                    escapeHtml(
                        room.roomNumber
                    ) +
                    '</strong>' +
                    '</td>' +

                    '<td>' +
                    escapeHtml(roomType) +
                    '</td>' +

                    '<td>' +
                    escapeHtml(price) +
                    '</td>' +

                    '<td>' +
                    '<span class="badge ' +
                    getStatusClass(status) +
                    '">' +
                    escapeHtml(status) +
                    '</span>' +
                    '</td>' +

                    '<td class="text-end">' +

                    '<button type="button" ' +
                    'class="btn btn-sm ' +
                    'btn-outline-primary me-1" ' +
                    'onclick="editRoom(' +
                    room.roomId +
                    ')">' +

                    '<i class="bi bi-pencil"></i>' +

                    '</button>' +

                    '<button type="button" ' +
                    'class="btn btn-sm ' +
                    'btn-outline-danger" ' +
                    'onclick="deleteRoom(' +
                    room.roomId +
                    ')">' +

                    '<i class="bi bi-trash"></i>' +

                    '</button>' +

                    '</td>' +

                    '</tr>'
                );

            }).join('');
    }


    /*
     * =========================================================
     * STATUS BADGE
     * =========================================================
     */

    function getStatusClass(status) {

        switch (
            String(status).toUpperCase()
        ) {

            case 'AVAILABLE':
                return 'bg-success';

            case 'OCCUPIED':
                return 'bg-danger';

            case 'MAINTENANCE':
                return 'bg-warning text-dark';

            case 'RESERVED':
                return 'bg-primary';

            default:
                return 'bg-secondary';
        }
    }


    /*
     * =========================================================
     * OPEN ADD FORM
     * =========================================================
     */

    function openRoomForm() {

        resetRoomForm();

        const panel =
            document.getElementById(
                'roomFormPanel'
            );

        if (panel) {
            panel.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    }


    /*
     * =========================================================
     * NEW ROOM TYPE TOGGLE
     * =========================================================
     */

    function toggleNewType() {

        const select =
            document.getElementById(
                'roomTypeSelect'
            );

        const fields =
            document.getElementById(
                'newTypeFields'
            );


        if (!select || !fields) {
            return;
        }


        if (select.value === 'NEW') {

            fields.classList.remove('d-none');

        } else {

            fields.classList.add('d-none');
        }
    }


    /*
     * =========================================================
     * SAVE ROOM
     * =========================================================
     */

    function saveRoom(event) {

        event.preventDefault();


        const roomId =
            document.getElementById(
                'roomId'
            ).value;


        const roomNumber =
            document.getElementById(
                'roomNumber'
            ).value.trim();


        const floor =
            document.getElementById(
                'floor'
            ).value;


        const description =
            document.getElementById(
                'description'
            ).value.trim();


        const roomTypeId =
            document.getElementById(
                'roomTypeSelect'
            ).value;


        const status =
            document.getElementById(
                'roomStatus'
            ).value;


        if (!roomNumber) {

            showAlert(
                'warning',
                'Room number is required.'
            );

            return;
        }


        if (!roomTypeId) {
            showAlert(
                'warning',
                'Please select a room type.'
            );
            return;
        }

        if (roomTypeId === 'NEW') {
            showAlert(
                'warning',
                'Creating a new room type is not available yet. Please select an existing room type.'
            );
            return;
        }


        /*
         * -----------------------------------------------------
         * IMPORTANT
         *
         * This is the JSON we will send to the backend.
         * We will adjust it if your existing API expects
         * a different DTO.
         * -----------------------------------------------------
         */

        const roomData = {

            roomNumber: roomNumber,

            floor: floor
                ? Number(floor)
                : null,

            description: description,

            status: status,

            roomType: {
                roomTypeId: Number(roomTypeId)
            }
        };


        const method =
            roomId
                ? 'PUT'
                : 'POST';


        const url =
            roomId
                ? '/api/rooms/' + roomId
                : '/api/rooms';


        const submitButton =
            document.getElementById(
                'roomFormSubmit'
            );


        if (submitButton) {
            submitButton.disabled = true;
        }


        api(url, {

            method: method,

            body: JSON.stringify(roomData)

        })

        .then(function (res) {

            console.log(
                'SAVE ROOM RESPONSE:',
                res
            );

            showAlert(
                'success',
                res.message ||
                (
                    roomId
                        ? 'Room updated successfully.'
                        : 'Room added successfully.'
                )
            );

            resetRoomForm();

            return loadRooms();
        })

        .catch(function (error) {

            console.error(
                'Error saving room:',
                error
            );

            showAlert(
                'danger',
                error.message ||
                'Could not save room.'
            );
        })

        .finally(function () {

            if (submitButton) {
                submitButton.disabled = false;
            }
        });
    }


    /*
     * =========================================================
     * EDIT ROOM
     * =========================================================
     */

    function editRoom(roomId) {

        const room =
            roomsData.find(function (item) {
                return Number(item.roomId) ===
                       Number(roomId);
            });


        if (!room) {
            showAlert(
                'danger',
                'Room not found.'
            );

            return;
        }


        document.getElementById(
            'roomId'
        ).value = room.roomId;


        document.getElementById(
            'roomNumber'
        ).value = room.roomNumber || '';


        document.getElementById(
            'floor'
        ).value =
            room.floor != null
                ? room.floor
                : '';


        document.getElementById(
            'description'
        ).value =
            room.description || '';


        document.getElementById(
            'roomStatus'
        ).value =
            room.status || 'AVAILABLE';


        const roomTypeSelect =
            document.getElementById(
                'roomTypeSelect'
            );


        if (
            room.roomType &&
            room.roomType.roomTypeId
        ) {

            roomTypeSelect.value =
                room.roomType.roomTypeId;
        }


        toggleNewType();


        document.getElementById(
            'roomFormTitle'
        ).textContent = 'Edit room';


        document.getElementById(
            'roomFormSubmit'
        ).textContent = 'Update room';


        document.getElementById(
            'roomFormPanel'
        ).scrollIntoView({
            behavior: 'smooth',
            block: 'start'
        });
    }


    /*
     * =========================================================
     * DELETE ROOM
     * =========================================================
     */

    function deleteRoom(roomId) {

        const room =
            roomsData.find(function (item) {
                return Number(item.roomId) ===
                       Number(roomId);
            });


        if (!room) {
            return;
        }


        if (
            !confirm(
                'Delete room ' +
                room.roomNumber +
                '?'
            )
        ) {
            return;
        }


        api(
            '/api/rooms/' + roomId,
            {
                method: 'DELETE'
            }
        )

        .then(function (res) {

            showAlert(
                'success',
                res.message ||
                'Room deleted successfully.'
            );

            return loadRooms();
        })

        .catch(function (error) {

            console.error(
                'Error deleting room:',
                error
            );

            showAlert(
                'danger',
                error.message ||
                'Could not delete room.'
            );
        });
    }


    /*
     * =========================================================
     * RESET ROOM FORM
     * =========================================================
     */

    function resetRoomForm() {

        const form =
            document.getElementById(
                'roomForm'
            );

        if (form) {
            form.reset();
        }


        document.getElementById(
            'roomId'
        ).value = '';


        document.getElementById(
            'roomFormTitle'
        ).textContent =
            'Add a room';


        document.getElementById(
            'roomFormSubmit'
        ).textContent =
            'Add room';


        const status =
            document.getElementById(
                'roomStatus'
            );

        if (status) {
            status.value = 'AVAILABLE';
        }


        const fields =
            document.getElementById(
                'newTypeFields'
            );

        if (fields) {
            fields.classList.add('d-none');
        }


        const typeSelect =
            document.getElementById(
                'roomTypeSelect'
            );

        if (typeSelect) {
            typeSelect.value = '';
        }
    }


    /*
     * =========================================================
     * RESET FILTERS
     * =========================================================
     */

    function resetFilters() {

        const form =
            document.getElementById(
                'filterForm'
            );

        if (form) {
            form.reset();
        }

        applyFilters();
    }


    /*
     * =========================================================
     * ALERT
     * =========================================================
     */

    function showAlert(type, message) {

        const container =
            document.getElementById(
                'alertContainer'
            );

        if (!container) {
            return;
        }


        container.innerHTML =
            '<div class="alert alert-' +
            type +
            ' alert-dismissible fade show" ' +
            'role="alert">' +

            message +

            '<button type="button" ' +
            'class="btn-close" ' +
            'data-bs-dismiss="alert">' +
            '</button>' +

            '</div>';
    }


    /*
     * =========================================================
     * ESCAPE HTML
     * =========================================================
     */

    function escapeHtml(value) {

        if (
            value === null ||
            value === undefined
        ) {
            return '';
        }

        return String(value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }

</script>





