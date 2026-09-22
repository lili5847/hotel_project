<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="pageTitle" value="Customers" />

<%-- ============================================================
     BACKEND 0: ACCESS CONTROL
     Reachable only through CustomerManagementServlet at
     /admin/customers, behind AdminFilter.
     ============================================================ --%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Customers" />
</jsp:include>
<jsp:include page="/common/admin-sidebar.jsp" />

<c:if test="${not empty param.flash}">
    <c:choose>
        <c:when test="${param.flash == 'activated'}"><div class="alert alert-success">Account re-activated.</div></c:when>
        <c:when test="${param.flash == 'suspended'}"><div class="alert alert-warning">Account suspended.</div></c:when>
        <c:otherwise><div class="alert alert-danger">Something went wrong. Please try again.</div></c:otherwise>
    </c:choose>
</c:if>

<div class="mb-4">
    <h1 class="h4 mb-0">Customers</h1>
    <p class="text-body-secondary small mb-0">View registered guests and their reservation activity.</p>
</div>

<%-- ============================================================
     BACKEND 1: SEARCH
     GET /admin/customers?q=...
     CustomerManagementServlet.doGet() reads "q", calls
     UserDAO.searchByRole("CUSTOMER", q), sets request attribute
     "customers" plus echoes "q" back so the box stays filled in.
     ============================================================ --%>
<div class="panel mb-4">
    <form action="${ctx}/admin/customers" method="get" class="p-3">
        <div class="row g-3 align-items-end">
            <div class="col-md-6">
                <label for="q" class="form-label">Search by name or email</label>
                <input type="text" class="form-control" id="q" name="q" value="<c:out value='${q}' />"
                       placeholder="e.g. jane@example.com">
            </div>
            <div class="col-md-2 d-grid">
                <button type="submit" class="btn btn-outline-primary">Search</button>
            </div>
        </div>
    </form>
</div>

<div class="panel">
    <div class="panel-header">
        <h2 class="h5 mb-0">
            All customers
            <c:if test="${not empty customers}">
                <span class="text-body-secondary fw-normal">(${fn:length(customers)})</span>
            </c:if>
        </h2>
    </div>

    <%-- ============================================================
         BACKEND 2: CUSTOMERS TABLE
         request attribute "customers": a List where each item exposes
           getId(), getFullName(), getEmail(), getPhone(),
           getReservationCount(), getJoinedDate(), getStatus()
           (ACTIVE / SUSPENDED)
         Suggested source: UserDAO.searchByRole("CUSTOMER", q) above,
         joined against a COUNT(*) on reservations per user.
         ============================================================ --%>
    <c:choose>
        <c:when test="${empty customers}">
            <div class="panel-empty">
                <i class="bi bi-people"></i>
                <p class="mb-0">No customers match this search.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive">
                <table class="table admin-table align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Contact</th>
                            <th>Reservations</th>
                            <th>Joined</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cust" items="${customers}">
                            <tr>
                                <td class="fw-medium"><c:out value="${cust.fullName}" /></td>
                                <td>
                                    <div class="small"><c:out value="${cust.email}" /></div>
                                    <div class="small text-body-secondary"><c:out value="${cust.phone}" /></div>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/reservations?q=${cust.email}" class="small">
                                        <c:out value="${cust.reservationCount}" /> booking(s)
                                    </a>
                                </td>
                                <td><c:out value="${cust.joinedDate}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cust.status == 'ACTIVE'}">
                                            <span class="badge status-badge status-confirmed">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge status-badge status-cancelled">Suspended</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <%-- ============================================================
                                     BACKEND 3: SUSPEND / RE-ACTIVATE
                                     POST /admin/customers, action=suspend|activate, id=...
                                     CustomerManagementServlet should:
                                       - flip the user's status column
                                       - a suspended user's LoginServlet check must reject
                                         their login even with a correct password
                                       - never let an admin suspend their own account here
                                         (guard server-side, not just by hiding the button)
                                     ============================================================ --%>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${cust.status == 'ACTIVE'}">
                                            <form action="${ctx}/admin/customers" method="post" class="d-inline"
                                                  onsubmit="return confirm('Suspend this account?');">
                                                <input type="hidden" name="action" value="suspend">
                                                <input type="hidden" name="id" value="${cust.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">Suspend</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${ctx}/admin/customers" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="activate">
                                                <input type="hidden" name="id" value="${cust.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-primary">Re-activate</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/common/admin-footer.jsp" />