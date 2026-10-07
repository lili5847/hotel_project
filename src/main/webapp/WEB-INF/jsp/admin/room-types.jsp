<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<jsp:include page="/WEB-INF/jsp/common/admin-header.jsp">
    <jsp:param name="title" value="Room Types" />
</jsp:include>

<jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp" />

<div id="alertContainer"></div>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h4 mb-0">Room Types</h1>
        <p class="text-body-secondary small mb-0">
            Manage room types, prices, capacity, amenities and images.
        </p>
    </div>

    <button type="button"
            class="btn btn-primary"
            onclick="openAddRoomTypeForm()">

        <i class="bi bi-plus-circle me-1"></i>
        Add Room Type
    </button>
</div>


<!-- ADD / EDIT FORM -->

<div class="panel mb-4" id="roomTypeFormPanel">

    <div class="panel-header">
        <h2 class="h6 mb-0" id="formTitle">
            Add Room Type
        </h2>
    </div>

    <form id="roomTypeForm"
          class="p-3"
          onsubmit="saveRoomType(event)">

        <input type="hidden"
               id="roomTypeId">

        <div class="row g-3">

            <div class="col-md-6">

                <label for="typeName"
                       class="form-label small fw-medium">
                    Type Name
                </label>

                <input type="text"
                       class="form-control"
                       id="typeName"
                       placeholder="Standard"
                       required>

            </div>


            <div class="col-md-3">

                <label for="price"
                       class="form-label small fw-medium">
                    Price per night
                </label>

                <div class="input-group">

                    <span class="input-group-text">$</span>

                    <input type="number"
                           min="0"
                           step="0.01"
                           class="form-control"
                           id="price"
                           required>

                </div>

            </div>


            <div class="col-md-3">

                <label for="capacity"
                       class="form-label small fw-medium">
                    Capacity
                </label>

                <input type="number"
                       min="1"
                       step="1"
                       class="form-control"
                       id="capacity"
                       required>

            </div>


            <div class="col-12">

                <label for="description"
                       class="form-label small fw-medium">
                    Description
                </label>

                <textarea class="form-control"
                          id="description"
                          rows="3"></textarea>

            </div>


            <div class="col-md-6">

                <label for="amenities"
                       class="form-label small fw-medium">
                    Amenities
                </label>

                <textarea class="form-control"
                          id="amenities"
                          rows="3"
                          placeholder="Free Wi-Fi, Air conditioning, Mini bar"></textarea>

                <div class="form-text">
                    Separate amenities with commas.
                </div>

            </div>


            <div class="col-md-6">

                <label for="imageUrl"
                       class="form-label small fw-medium">
                    Image URL
                </label>

                <input type="text"
                       class="form-control"
                       id="imageUrl"
                       placeholder="/images/rooms/standard.jpg">

                <div class="form-text">
                    Example: /images/rooms/standard.jpg
                </div>

            </div>

        </div>


        <div class="d-flex gap-2 mt-4">

            <button type="submit"
                    class="btn btn-primary"
                    id="saveButton">

                <i class="bi bi-check-circle me-1"></i>
                Add Room Type

            </button>

            <button type="button"
                    class="btn btn-outline-secondary"
                    onclick="resetRoomTypeForm()">

                Clear

            </button>

        </div>

    </form>

</div>


<!-- ROOM TYPES -->

<div class="panel">

    <div class="panel-header d-flex justify-content-between align-items-center">

        <h2 class="h5 mb-0">
            Existing Room Types
            <span id="roomTypeCount"
                  class="text-body-secondary fw-normal">
            </span>
        </h2>

        <button type="button"
                class="btn btn-sm btn-outline-secondary"
                onclick="loadRoomTypes()">

            <i class="bi bi-arrow-clockwise me-1"></i>
            Refresh

        </button>

    </div>


    <div class="table-responsive">

        <table class="table admin-table align-middle mb-0">

            <thead>

            <tr>
                <th>Type</th>
                <th>Description</th>
                <th>Price</th>
                <th>Capacity</th>
                <th>Amenities</th>
                <th>Image</th>
                <th class="text-end">Action</th>
            </tr>

            </thead>

            <tbody id="roomTypesTableBody">

            <tr>
                <td colspan="7"
                    class="text-center py-5">

                    <div class="spinner-border text-primary"
                         role="status">

                        <span class="visually-hidden">
                            Loading...
                        </span>

                    </div>

                    <div class="mt-2 text-body-secondary">
                        Loading room types...
                    </div>

                </td>
            </tr>

            </tbody>

        </table>

    </div>

</div>


<jsp:include page="/WEB-INF/jsp/common/admin-footer.jsp" />


<script>

const ctx = '<%= request.getContextPath() %>';

const token = localStorage.getItem('token');

let roomTypesData = [];


document.addEventListener('DOMContentLoaded', function () {

    console.log('ROOM TYPES PAGE LOADED');

    console.log('Token exists:', !!token);

    loadRoomTypes();

});


/* =========================================================
   API HELPER
   ========================================================= */

function api(path, options) {

    options = options || {};

    options.headers = Object.assign(
        {
            'Content-Type': 'application/json'
        },
        options.headers || {}
    );

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

                        throw new Error(
                            body.message ||
                            ('HTTP ' + response.status)
                        );

                    }

                    return body;

                });

        });

}


/* =========================================================
   LOAD ROOM TYPES
   ========================================================= */

function loadRoomTypes() {

    api('/api/room-types', {
        method: 'GET'
    })

    .then(function (res) {

        console.log(
            'ROOM TYPE API RESPONSE:',
            res
        );

        roomTypesData =
            Array.isArray(res.data)
                ? res.data
                : [];

        console.log(
            'ROOM TYPES:',
            roomTypesData
        );

        renderRoomTypes();

    })

    .catch(function (error) {

        console.error(
            'Error loading room types:',
            error
        );

        document.getElementById(
            'roomTypesTableBody'
        ).innerHTML =

            '<tr>' +
            '<td colspan="7" ' +
            'class="text-center text-danger py-5">' +
            '<i class="bi bi-exclamation-triangle fs-3"></i>' +
            '<div class="mt-2">' +
            'Could not load room types: ' +
            escapeHtml(error.message) +
            '</div>' +
            '</td>' +
            '</tr>';

    });

}


/* =========================================================
   RENDER ROOM TYPES
   ========================================================= */

function renderRoomTypes() {

    const tbody =
        document.getElementById(
            'roomTypesTableBody'
        );

    const count =
        document.getElementById(
            'roomTypeCount'
        );

    if (!tbody) {
        return;
    }

    if (count) {

        count.textContent =
            '(' + roomTypesData.length + ')';

    }


    if (roomTypesData.length === 0) {

        tbody.innerHTML =

            '<tr>' +
            '<td colspan="7" ' +
            'class="text-center text-muted py-5">' +

            '<i class="bi bi-grid fs-1"></i>' +

            '<div class="mt-2">' +
            'No room types found.' +
            '</div>' +

            '</td>' +
            '</tr>';

        return;

    }


    tbody.innerHTML =

        roomTypesData.map(function (type) {

            const imageUrl =
                type.imageUrl || '';

            const imageHtml =
                imageUrl
                    ? '<img src="' +
                      escapeHtml(imageUrl) +
                      '" ' +
                      'alt="' +
                      escapeHtml(type.typeName) +
                      '" ' +
                      'style="width:70px;height:50px;object-fit:cover;border-radius:8px;">'
                    : '<span class="text-muted">No image</span>';


            return (

                '<tr>' +

                '<td>' +
                '<strong>' +
                escapeHtml(
                    type.typeName || '-'
                ) +
                '</strong>' +
                '</td>' +

                '<td>' +
                escapeHtml(
                    type.description || '-'
                ) +
                '</td>' +

                '<td>' +
                (
                    type.price != null
                        ? '$' +
                          Number(type.price)
                              .toFixed(2)
                        : '-'
                ) +
                '</td>' +

                '<td>' +
                (
                    type.capacity != null
                        ? escapeHtml(type.capacity)
                        : '-'
                ) +
                '</td>' +

                '<td>' +
                escapeHtml(
                    type.amenities || '-'
                ) +
                '</td>' +

                '<td>' +
                imageHtml +
                '</td>' +

                '<td class="text-end">' +

                '<button type="button" ' +
                'class="btn btn-sm btn-outline-primary" ' +
                'onclick="editRoomType(' +
                type.roomTypeId +
                ')">' +

                '<i class="bi bi-pencil me-1"></i>' +
                'Edit' +

                '</button>' +

                '</td>' +

                '</tr>'

            );

        }).join('');

}


/* =========================================================
   OPEN ADD FORM
   ========================================================= */

function openAddRoomTypeForm() {

    resetRoomTypeForm();

    document.getElementById(
        'roomTypeFormPanel'
    ).scrollIntoView({
        behavior: 'smooth',
        block: 'start'
    });

}


/* =========================================================
   EDIT ROOM TYPE
   ========================================================= */

function editRoomType(id) {

    const roomType =
        roomTypesData.find(function (item) {

            return Number(item.roomTypeId) ===
                   Number(id);

        });

    if (!roomType) {

        showAlert(
            'danger',
            'Room type not found.'
        );

        return;

    }


    document.getElementById(
        'roomTypeId'
    ).value =
        roomType.roomTypeId;


    document.getElementById(
        'typeName'
    ).value =
        roomType.typeName || '';


    document.getElementById(
        'price'
    ).value =
        roomType.price != null
            ? roomType.price
            : '';


    document.getElementById(
        'capacity'
    ).value =
        roomType.capacity != null
            ? roomType.capacity
            : '';


    document.getElementById(
        'description'
    ).value =
        roomType.description || '';


    document.getElementById(
        'amenities'
    ).value =
        roomType.amenities || '';


    document.getElementById(
        'imageUrl'
    ).value =
        roomType.imageUrl || '';


    document.getElementById(
        'formTitle'
    ).textContent =
        'Edit Room Type';


    document.getElementById(
        'saveButton'
    ).innerHTML =
        '<i class="bi bi-check-circle me-1"></i>' +
        'Save Changes';


    document.getElementById(
        'roomTypeFormPanel'
    ).scrollIntoView({
        behavior: 'smooth',
        block: 'start'
    });

}


/* =========================================================
   SAVE ROOM TYPE
   ========================================================= */

function saveRoomType(event) {

    event.preventDefault();


    const id =
        document.getElementById(
            'roomTypeId'
        ).value;


    const typeName =
        document.getElementById(
            'typeName'
        ).value.trim();


    const price =
        document.getElementById(
            'price'
        ).value;


    const capacity =
        document.getElementById(
            'capacity'
        ).value;


    const description =
        document.getElementById(
            'description'
        ).value.trim();


    const amenities =
        document.getElementById(
            'amenities'
        ).value.trim();


    const imageUrl =
        document.getElementById(
            'imageUrl'
        ).value.trim();


    if (!typeName) {

        showAlert(
            'warning',
            'Room type name is required.'
        );

        return;

    }


    const payload = {

        typeName: typeName,

        description: description,

        price: price
            ? Number(price)
            : null,

        capacity: capacity
            ? Number(capacity)
            : null,

        amenities: amenities,

        imageUrl: imageUrl

    };


    const isEdit = id !== '';


    const url =
        isEdit
            ? '/api/room-types/' + id
            : '/api/room-types';


    const method =
        isEdit
            ? 'PUT'
            : 'POST';


    const saveButton =
        document.getElementById(
            'saveButton'
        );


    saveButton.disabled = true;

    saveButton.textContent =
        isEdit
            ? 'Saving...'
            : 'Creating...';


    api(url, {

        method: method,

        body: JSON.stringify(payload)

    })

    .then(function (res) {

        console.log(
            'SAVE ROOM TYPE RESPONSE:',
            res
        );

        showAlert(
            'success',
            res.message ||
            (
                isEdit
                    ? 'Room type updated successfully.'
                    : 'Room type created successfully.'
            )
        );


        resetRoomTypeForm();

        return loadRoomTypes();

    })

    .catch(function (error) {

        console.error(
            'Error saving room type:',
            error
        );

        showAlert(
            'danger',
            error.message ||
            'Could not save room type.'
        );

    })

    .finally(function () {

        saveButton.disabled = false;

    });

}


/* =========================================================
   RESET FORM
   ========================================================= */

function resetRoomTypeForm() {

    const form =
        document.getElementById(
            'roomTypeForm'
        );

    if (form) {
        form.reset();
    }


    document.getElementById(
        'roomTypeId'
    ).value = '';


    document.getElementById(
        'formTitle'
    ).textContent =
        'Add Room Type';


    document.getElementById(
        'saveButton'
    ).innerHTML =
        '<i class="bi bi-check-circle me-1"></i>' +
        'Add Room Type';

}


/* =========================================================
   ALERT
   ========================================================= */

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
        ' alert-dismissible fade show mb-4" ' +
        'role="alert">' +

        escapeHtml(message) +

        '<button type="button" ' +
        'class="btn-close" ' +
        'data-bs-dismiss="alert">' +
        '</button>' +

        '</div>';

}


/* =========================================================
   ESCAPE HTML
   ========================================================= */

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