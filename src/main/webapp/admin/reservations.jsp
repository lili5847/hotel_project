<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Reservations" />

<%-- ============================================================
     BACKEND 0: ACCESS CONTROL
     Reachable only through ReservationManagementServlet at
     /admin/reservations, behind the same AdminFilter used by
     the dashboard (sessionScope.user, role == "ADMIN").
     ============================================================ --%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Reservations" />
</jsp:include>
<jsp:include page="/common/admin-sidebar.jsp" />

<%-- ============================================================
     BACKEND 1: STATUS BANNER
     After an action (confirm / check-in / cancel), redirect back
     to /admin/reservations?...&flash=confirmed  (or checked_in /
     cancelled / error) so the admin sees feedback after the
     redirect. Using redirect-after-POST here avoids the classic
     "resubmit form on refresh" browser prompt.
     ============================================================ --%>
<c:if test="${not empty param.flash}">
    <c:choose>
        <c:when test="${param.flash == 'confirmed'}">
            <div class="alert alert-success">Reservation confirmed.</div>
        </c:when>
        <c:when test="${param.flash == 'checked_in'}">
            <div class="alert alert-success">Guest checked in.</div>
        </c:when>
        <c:when test="${param.flash == 'cancelled'}">
            <div class="alert alert-warning">Reservation cancelled.</div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-danger">Something went wrong. Please try again.</div>
        </c:otherwise>
    </c:choose>
</c:if>

<%-- ============================================================
     BACKEND 2: FILTER BAR
     GET /admin/reservations with: status, q, from, to, page
     ReservationManagementServlet should:
       1. read these params (all optional)
       2. call ReservationDAO.search(status, q, from, to, page, pageSize)
       3. set request attributes: reservations, currentPage, totalPages,
          plus keep the submitted filters as request attributes
          (status, q, from, to) so the form below stays filled in
     ============================================================ --%>
<div class="panel mb-4">
    <div class="panel-header">
        <h2 class="h5 mb-0">Filter reservations</h2>
    </div>
    <form action="${ctx}/admin/reservations" method="get" class="p-3">
        <div class="row g-3 align-items-end">
            <div class="col-md-3">
                <label for="q" class="form-label">Guest name or email</label>
                <input type="text" class="form-control" id="q" name="q"
                       value="<c:out value='${q}' />" placeholder="Search guest">
            </div>
            <div class="col-md-2">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status">
                    <option value="" ${empty status ? 'selected' : ''}>All statuses</option>
                    <option value="PENDING"    ${status == 'PENDING'    ? 'selected' : ''}>Pending</option>
                    <option value="CONFIRMED"  ${status == 'CONFIRMED'  ? 'selected' : ''}>Confirmed</option>
                    <option value="CHECKED_IN" ${status == 'CHECKED_IN' ? 'selected' : ''}>Checked in</option>
                    <option value="CANCELLED"  ${status == 'CANCELLED'  ? 'selected' : ''}>Cancelled</option>
                </select>
            </div>
            <div class="col-md-2">
                <label for="from" class="form-label">From</label>
                <input type="date" class="form-control" id="from" name="from" value="<c:out value='${from}' />">
            </div>
            <div class="col-md-2">
                <label for="to" class="form-label">To</label>
                <input type="date" class="form-control" id="to" name="to" value="<c:out value='${to}' />">
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">
                    <i class="bi bi-funnel me-1"></i>Apply
                </button>
                <a href="${ctx}/admin/reservations" class="btn btn-outline-secondary">Reset</a>
            </div>
        </div>
    </form>
</div>

<%-- ============================================================
     BACKEND 3: RESERVATIONS TABLE
     request attribute "reservations": a List where each item exposes
       getId(), getGuestName(), getGuestEmail(), getRoomLabel(),
       getCheckIn(), getCheckOut(), getNights(), getTotal(), getStatus()
     Suggested source: ReservationDAO.search(...) described above.
     Status values: PENDING, CONFIRMED, CHECKED_IN, CANCELLED — adjust
     the c:when blocks (here and in the badge) if your enum differs.
     ============================================================ --%>
<div class="panel">
    <div class="panel-header">
        <h2 class="h5 mb-0">
            Reservations
            <c:if test="${not empty reservations}">
                <span class="text-body-secondary fw-normal">(${fn:length(reservations)} shown)</span>
            </c:if>
        </h2>
    </div>

    <c:choose>
        <c:when test="${empty reservations}">
            <div class="panel-empty">
                <i class="bi bi-journal-x"></i>
                <p class="mb-0">No reservations match these filters.</p>
            </div>
        </c:when>
        <c:otherwise>
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
                    <tbody>
                        <c:forEach var="r" items="${reservations}">
                            <tr>
                                <td>
                                    <div class="fw-medium"><c:out value="${r.guestName}" /></div>
                                    <div class="small text-body-secondary"><c:out value="${r.guestEmail}" /></div>
                                </td>
                                <td><c:out value="${r.roomLabel}" /></td>
                                <td><c:out value="${r.checkIn}" /></td>
                                <td><c:out value="${r.checkOut}" /></td>
                                <td><c:out value="${r.nights}" /></td>
                                <td>&#36;<c:out value="${r.total}" /></td>
                                <td>
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
                                </td>

                                <%-- ============================================================
                                     BACKEND 4: ROW ACTIONS
                                     Each button is its own tiny form, POSTing to
                                     /admin/reservations with "action" + "id".
                                     In ReservationManagementServlet.doPost():
                                       - "confirm"   : PENDING -> CONFIRMED
                                       - "check_in"  : CONFIRMED -> CHECKED_IN
                                       - "cancel"    : any non-final status -> CANCELLED
                                     Re-check the current status server-side before changing
                                     it (don't trust the button that was clicked), then
                                     redirect back to /admin/reservations?flash=... , keeping
                                     the current filters/page in the redirect URL if you want
                                     the admin to land back where they were.
                                     ============================================================ --%>
                                <td class="text-end text-nowrap">
                                    <div class="d-inline-flex gap-1">
                                        <c:if test="${r.status == 'PENDING'}">
                                            <form action="${ctx}/admin/reservations" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="confirm">
                                                <input type="hidden" name="id" value="${r.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-primary" title="Confirm">
                                                    <i class="bi bi-check2"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${r.status == 'CONFIRMED'}">
                                            <form action="${ctx}/admin/reservations" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="check_in">
                                                <input type="hidden" name="id" value="${r.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-primary" title="Check in">
                                                    <i class="bi bi-box-arrow-in-right"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${r.status != 'CANCELLED' && r.status != 'CHECKED_IN'}">
                                            <form action="${ctx}/admin/reservations" method="post" class="d-inline"
                                                  onsubmit="return confirm('Cancel this reservation?');">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="id" value="${r.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Cancel">
                                                    <i class="bi bi-x-lg"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                        <a href="${ctx}/admin/reservations?id=${r.id}"
                                           class="btn btn-sm btn-outline-secondary" title="View details">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <%-- ============================================================
                 BACKEND 5: PAGINATION
                 request attributes: currentPage (1-based), totalPages.
                 Carries the current filters along on each page link so
                 paging doesn't reset them.
                 ============================================================ --%>
            <c:if test="${totalPages > 1}">
                <nav class="d-flex justify-content-center py-3" aria-label="Reservations pages">
                    <ul class="pagination mb-0">
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                   href="${ctx}/admin/reservations?page=${p}&status=${status}&q=${q}&from=${from}&to=${to}">
                                    <c:out value="${p}" />
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </nav>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/common/admin-footer.jsp" />