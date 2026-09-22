<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Rooms" />

<%-- ============================================================
     BACKEND 0: ACCESS CONTROL
     Reachable only through RoomManagementServlet at /admin/rooms,
     behind AdminFilter (sessionScope.user, role == "ADMIN").
     ============================================================ --%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Rooms" />
</jsp:include>
<jsp:include page="/common/admin-sidebar.jsp" />

<c:if test="${not empty param.flash}">
    <c:choose>
        <c:when test="${param.flash == 'created'}"><div class="alert alert-success">Room added.</div></c:when>
        <c:when test="${param.flash == 'updated'}"><div class="alert alert-success">Room updated.</div></c:when>
        <c:when test="${param.flash == 'deleted'}"><div class="alert alert-warning">Room removed.</div></c:when>
        <c:otherwise><div class="alert alert-danger">Something went wrong. Please try again.</div></c:otherwise>
    </c:choose>
</c:if>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h4 mb-0">Rooms</h1>
        <p class="text-body-secondary small mb-0">Manage individual rooms and their status.</p>
    </div>
    <%-- Opens the "new room" panel below; see BACKEND 2 --%>
    <button type="button" class="btn btn-primary" onclick="openRoomForm()">
        <i class="bi bi-plus-circle me-1"></i>Add a room
    </button>
</div>

<%-- ============================================================
     BACKEND 1: FILTER BAR
     GET /admin/rooms with: q, type, status
     RoomManagementServlet.doGet() reads these, calls
     RoomDAO.search(q, type, status), sets request attribute "rooms"
     plus echoes back q/type/status as request attributes so the
     form below stays filled in.
     ============================================================ --%>
<div class="panel mb-4">
    <form action="${ctx}/admin/rooms" method="get" class="p-3">
        <div class="row g-3 align-items-end">
            <div class="col-md-4">
                <label for="q" class="form-label">Room number or name</label>
                <input type="text" class="form-control" id="q" name="q" value="<c:out value='${q}' />">
            </div>
            <div class="col-md-3">
                <label for="type" class="form-label">Room type</label>
                <select class="form-select" id="type" name="type">
                    <option value="" ${empty type ? 'selected' : ''}>All types</option>
                    <option value="POOL_VIEW"    ${type == 'POOL_VIEW'    ? 'selected' : ''}>Pool view</option>
                    <option value="CITY_VIEW"    ${type == 'CITY_VIEW'    ? 'selected' : ''}>City view</option>
                    <option value="FAMILY_SUITE" ${type == 'FAMILY_SUITE' ? 'selected' : ''}>Family suite</option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status">
                    <option value="" ${empty status ? 'selected' : ''}>All statuses</option>
                    <option value="AVAILABLE"   ${status == 'AVAILABLE'   ? 'selected' : ''}>Available</option>
                    <option value="OCCUPIED"    ${status == 'OCCUPIED'    ? 'selected' : ''}>Occupied</option>
                    <option value="MAINTENANCE" ${status == 'MAINTENANCE' ? 'selected' : ''}>Under maintenance</option>
                </select>
            </div>
            <div class="col-md-2 d-grid">
                <button type="submit" class="btn btn-outline-primary">Apply</button>
            </div>
        </div>
    </form>
</div>

<div class="row g-4">

    <!-- Table -->
    <div class="col-lg-8">
        <div class="panel">
            <div class="panel-header">
                <h2 class="h5 mb-0">
                    All rooms
                    <c:if test="${not empty rooms}">
                        <span class="text-body-secondary fw-normal">(${fn:length(rooms)})</span>
                    </c:if>
                </h2>
            </div>

            <%-- ============================================================
                 BACKEND 2: ROOMS TABLE
                 request attribute "rooms": a List where each item exposes
                   getId(), getRoomNumber(), getName(), getTypeLabel(),
                   getPrice(), getStatus() (AVAILABLE / OCCUPIED / MAINTENANCE)
                 Suggested source: RoomDAO.search(...) above.

                 The "Edit" button calls editRoom(...) with the row's own
                 values so the form panel on the right fills in without a
                 page reload. If you'd rather each Edit link do a full GET
                 to /admin/rooms?id=... and have the servlet pre-fill the
                 form server-side instead, that works too — just drop the
                 onclick and use an <a href> there instead.
                 ============================================================ --%>
            <c:choose>
                <c:when test="${empty rooms}">
                    <div class="panel-empty">
                        <i class="bi bi-door-closed"></i>
                        <p class="mb-0">No rooms match these filters.</p>
                    </div>
                </c:when>
                <c:otherwise>
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
                            <tbody>
                                <c:forEach var="room" items="${rooms}">
                                    <tr>
                                        <td>
                                            <div class="fw-medium">Room <c:out value="${room.roomNumber}" /></div>
                                            <div class="small text-body-secondary"><c:out value="${room.name}" /></div>
                                        </td>
                                        <td><c:out value="${room.typeLabel}" /></td>
                                        <td>&#36;<c:out value="${room.price}" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${room.status == 'AVAILABLE'}">
                                                    <span class="badge status-badge status-confirmed">Available</span>
                                                </c:when>
                                                <c:when test="${room.status == 'OCCUPIED'}">
                                                    <span class="badge status-badge status-checked-in">Occupied</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge status-badge status-pending">Maintenance</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end text-nowrap">
                                            <button type="button" class="btn btn-sm btn-outline-secondary"
                                                    onclick='editRoom(${room.id}, "<c:out value="${room.roomNumber}"/>", "<c:out value="${room.name}"/>", "${room.type}", ${room.price}, "${room.status}")'>
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <%-- ============================================================
                                                 BACKEND 3: DELETE
                                                 POST /admin/rooms, action=delete, id=...
                                                 RoomManagementServlet should refuse (and show an error
                                                 flash) if the room has any non-cancelled reservations —
                                                 don't allow deleting a room with an active booking.
                                                 ============================================================ --%>
                                            <form action="${ctx}/admin/rooms" method="post" class="d-inline"
                                                  onsubmit="return confirm('Remove this room? This cannot be undone.');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${room.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Add / edit form -->
    <div class="col-lg-4">
        <div class="panel" id="roomFormPanel">
            <div class="panel-header">
                <h2 class="h6 mb-0" id="roomFormTitle">Add a room</h2>
            </div>

            <%-- ============================================================
                 BACKEND 4: CREATE / UPDATE SUBMIT
                 POST /admin/rooms
                 action=create (no "id" sent) or action=update (with "id")
                 Params: roomNumber, name, type, price, status
                 RoomManagementServlet.doPost():
                   - "create": validate, RoomDAO.insert(...), redirect
                     with ?flash=created
                   - "update": validate, RoomDAO.update(id, ...), redirect
                     with ?flash=updated
                 On validation failure, forward back to this JSP with
                 "error" and the submitted values as request attributes
                 so the form can stay open and filled in (out of scope
                 for this static version — this JS-only toggle already
                 covers the common case of re-opening the form empty).
                 ============================================================ --%>
            <form action="${ctx}/admin/rooms" method="post" class="p-3">
                <input type="hidden" name="action" id="formAction" value="create">
                <input type="hidden" name="id" id="roomId" value="">

                <div class="mb-3">
                    <label for="roomNumber" class="form-label small fw-medium">Room number</label>
                    <input type="text" class="form-control" id="roomNumber" name="roomNumber" required>
                </div>
                <div class="mb-3">
                    <label for="name" class="form-label small fw-medium">Display name</label>
                    <input type="text" class="form-control" id="name" name="name" required>
                </div>
                <div class="mb-3">
                    <label for="roomType" class="form-label small fw-medium">Room type</label>
                    <%-- BACKEND: these 3 values must match RoomType codes used everywhere else --%>
                    <select class="form-select" id="roomType" name="type" required>
                        <option value="POOL_VIEW">Pool view</option>
                        <option value="CITY_VIEW">City view</option>
                        <option value="FAMILY_SUITE">Family suite</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="price" class="form-label small fw-medium">Price per night</label>
                    <div class="input-group">
                        <span class="input-group-text">$</span>
                        <input type="number" min="0" step="1" class="form-control" id="price" name="price" required>
                    </div>
                </div>
                <div class="mb-4">
                    <label for="roomStatus" class="form-label small fw-medium">Status</label>
                    <select class="form-select" id="roomStatus" name="status" required>
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

<script>
    function openRoomForm() {
        resetRoomForm();
        document.getElementById('roomFormPanel').scrollIntoView({ behavior: 'smooth' });
    }

    function editRoom(id, roomNumber, name, type, price, status) {
        document.getElementById('roomFormTitle').textContent = 'Edit room ' + roomNumber;
        document.getElementById('formAction').value = 'update';
        document.getElementById('roomId').value = id;
        document.getElementById('roomNumber').value = roomNumber;
        document.getElementById('name').value = name;
        document.getElementById('roomType').value = type;
        document.getElementById('price').value = price;
        document.getElementById('roomStatus').value = status;
        document.getElementById('roomFormSubmit').textContent = 'Save changes';
        document.getElementById('roomFormPanel').scrollIntoView({ behavior: 'smooth' });
    }

    function resetRoomForm() {
        document.getElementById('roomFormTitle').textContent = 'Add a room';
        document.getElementById('formAction').value = 'create';
        document.getElementById('roomId').value = '';
        document.querySelector('#roomFormPanel form').reset();
        document.getElementById('roomFormSubmit').textContent = 'Add room';
    }
</script>

<jsp:include page="/common/admin-footer.jsp" />