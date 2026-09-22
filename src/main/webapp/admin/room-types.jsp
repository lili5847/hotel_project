<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Room types" />

<%-- ============================================================
     BACKEND 0: ACCESS CONTROL
     Reachable only through RoomTypeManagementServlet at
     /admin/room-types, behind AdminFilter.

     This project only ever has 3 room types (Pool view, City view,
     Family suite), so this page is EDIT-ONLY — there's no "add type"
     or "delete type" button, unlike admin/rooms.jsp. If that ever
     changes, this page would need an add/delete flow like rooms.jsp.
     ============================================================ --%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Room types" />
</jsp:include>
<jsp:include page="/common/admin-sidebar.jsp" />

<c:if test="${not empty param.flash && param.flash == 'updated'}">
    <div class="alert alert-success">Room type updated.</div>
</c:if>
<c:if test="${not empty param.flash && param.flash == 'error'}">
    <div class="alert alert-danger">Something went wrong. Please try again.</div>
</c:if>

<div class="mb-4">
    <h1 class="h4 mb-0">Room types</h1>
    <p class="text-body-secondary small mb-0">
        Edit the description, base price, and amenities shown to guests for each of the 3 room types.
    </p>
</div>

<%-- ============================================================
     BACKEND 1: THE THREE TYPES
     request attribute "roomTypes": a List of exactly 3 items, each
     exposing getId(), getCode() (POOL_VIEW / CITY_VIEW / FAMILY_SUITE),
     getLabel(), getBasePrice(), getDescription(), getAmenitiesCsv()
     (a comma-separated string for the textarea below — split/join in
     the servlet when converting to/from the amenities List used on
     room-details.jsp), getActiveRoomCount() (how many actual rooms
     currently use this type, just informational).
     Source: RoomTypeDAO.findAll(), always ordered POOL_VIEW, CITY_VIEW,
     FAMILY_SUITE (or whatever your fixed display order should be).

     Each type gets its own <form>, POSTing independently to
     /admin/room-types with action=update, id=<type id>. Since types
     are never created or deleted, there's no shared "id" hidden field
     trick to worry about — each form already carries its own type id.
     ============================================================ --%>
<c:choose>
    <c:when test="${empty roomTypes}">
        <div class="panel">
            <div class="panel-empty">
                <i class="bi bi-tags"></i>
                <p class="mb-0">Room type data hasn't loaded yet.</p>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="row g-4">
            <c:forEach var="rt" items="${roomTypes}">
                <div class="col-lg-4">
                    <div class="panel h-100">
                        <div class="panel-header">
                            <h2 class="h6 mb-0"><c:out value="${rt.label}" /></h2>
                            <span class="small text-body-secondary">
                                <c:out value="${rt.activeRoomCount}" /> room(s)
                            </span>
                        </div>

                        <form action="${ctx}/admin/room-types" method="post" class="p-3">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${rt.id}">

                            <div class="mb-3">
                                <label class="form-label small fw-medium">Base price per night</label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" min="0" step="1" class="form-control"
                                           name="basePrice" value="<c:out value='${rt.basePrice}' />" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-medium">Description</label>
                                <textarea class="form-control" name="description" rows="4" required><c:out value="${rt.description}" /></textarea>
                            </div>

                            <div class="mb-4">
                                <label class="form-label small fw-medium">Amenities</label>
                                <textarea class="form-control" name="amenitiesCsv" rows="3"
                                          placeholder="Free Wi-Fi, Air conditioning, Mini bar"><c:out value="${rt.amenitiesCsv}" /></textarea>
                                <div class="form-text">Comma-separated. Shown on the room details page.</div>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary">Save changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/common/admin-footer.jsp" />