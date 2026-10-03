<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/WEB-INF/jsp/common/header.jsp">
    <jsp:param name="title" value="Room types" />
</jsp:include>
<jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp" />
<!-- Dynamic Alert Container -->
<div id="alertContainer"></div>

<div class="mb-4">
    <h1 class="h4 mb-0">Room types</h1>
    <p class="text-body-secondary small mb-0">
        Edit the description, base price, and amenities shown to guests for each of the 3 room types.
    </p>
</div>

<!-- Dynamic Room Types Container -->
<div id="roomTypesContainer" class="row g-4">
    <div class="col-12 text-center py-5">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <p class="mt-2 text-body-secondary">Loading room types...</p>
    </div>
</div>

<jsp:include page="/common/admin-footer.jsp" />

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION FOR ROOM TYPES
============================================================ -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        loadRoomTypes();
    });

    function loadRoomTypes() {
        const token = localStorage.getItem('accessToken');

        fetch('${ctx}/api/admin/room-types', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) throw new Error('Failed to fetch room types');
                return response.json();
            })
            .then(data => {
                const roomTypes = Array.isArray(data) ? data : (data.content || data.data || []);
                renderRoomTypes(roomTypes);
            })
            .catch(error => {
                console.error('Error fetching room types:', error);
                document.getElementById('roomTypesContainer').innerHTML = `
            <div class="col-12">
                <div class="panel p-4 text-center text-danger">
                    <i class="bi bi-exclamation-triangle fs-3"></i>
                    <p class="mb-0 mt-2">Nakamaisyu ti panag-fetch ti datos dagiti room type.</p>
                </div>
            </div>`;
            });
    }

    function renderRoomTypes(roomTypes) {
        const container = document.getElementById('roomTypesContainer');

        if (roomTypes.length === 0) {
            container.innerHTML = `
            <div class="col-12">
                <div class="panel">
                    <div class="panel-empty py-5 text-center">
                        <i class="bi bi-tags fs-1 text-secondary"></i>
                        <p class="mb-0 mt-2">Room type data hasn't loaded yet.</p>
                    </div>
                </div>
            </div>`;
            return;
        }

        let html = '';
        roomTypes.forEach(rt => {
            const activeCount = rt.activeRoomCount !== undefined ? rt.activeRoomCount : 0;
            const amenities = rt.amenitiesCsv || (Array.isArray(rt.amenities) ? rt.amenities.join(', ') : '');

            html += `
            <div class="col-lg-4">
                <div class="panel h-100">
                    <div class="panel-header">
                        <h2 class="h6 mb-0">\${escapeHtml(rt.label || rt.name || '')}</h2>
                        <span class="small text-body-secondary">
                            ${activeCount} room(s)
                        </span>
                    </div>

                    <form onsubmit="updateRoomType(event, ${rt.id})" class="p-3">
                        <div class="mb-3">
                            <label class="form-label small fw-medium">Base price per night</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" min="0" step="1" class="form-control"
                                       id="basePrice_${rt.id}" value="${rt.basePrice || 0}" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-medium">Description</label>
                            <textarea class="form-control" id="description_${rt.id}" rows="4" required>\${escapeHtml(rt.description || '')}</textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-medium">Amenities</label>
                            <textarea class="form-control" id="amenitiesCsv_${rt.id}" rows="3"
                                      placeholder="Free Wi-Fi, Air conditioning, Mini bar">\\${escapeHtml(amenities)}</textarea>
                            <div class="form-text">Comma-separated. Shown on the room details page.</div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary" id="btn_${rt.id}">Save changes</button>
                        </div>
                    </form>
                </div>
            </div>`;
        });

        container.innerHTML = html;
    }

    function updateRoomType(event, id) {
        event.preventDefault();
        const token = localStorage.getItem('accessToken');
        const submitBtn = document.getElementById(`btn_${id}`);

        const basePrice = document.getElementById(`basePrice_${id}`).value;
        const description = document.getElementById(`description_${id}`).value;
        const amenitiesCsv = document.getElementById(`amenitiesCsv_${id}`).value;

        const payload = {
            id: id,
            basePrice: parseFloat(basePrice),
            description: description,
            amenitiesCsv: amenitiesCsv
        };

        submitBtn.disabled = true;
        submitBtn.textContent = 'Saving...';

        fetch(`${ctx}/api/admin/room-types/${id}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            },
            body: JSON.stringify(payload)
        })
            .then(response => {
                if (response.ok) {
                    showAlert('Room type updated successfully.', 'success');
                } else {
                    showAlert('Something went wrong. Please try again.', 'danger');
                }
            })
            .catch(error => {
                console.error('Error updating room type:', error);
                showAlert('Something went wrong. Please try again.', 'danger');
            })
            .finally(() => {
                submitBtn.disabled = false;
                submitBtn.textContent = 'Save changes';
            });
    }

    function showAlert(message, type) {
        const alertContainer = document.getElementById('alertContainer');
        alertContainer.innerHTML = `
        <div class="alert alert-${type} alert-dismissible fade show mb-4" role="alert">
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>`;
    }

    function escapeHtml(str) {
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }
</script>