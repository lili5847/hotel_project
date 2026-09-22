<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%--
  Highlights the current nav item by matching the start of the request URI.
  Works as long as each admin servlet's URL starts with the path shown below.
--%>
<c:set var="uri" value="${pageContext.request.requestURI}" />

<div class="admin-layout">

    <aside class="admin-sidebar">
        <a href="${ctx}/admin/dashboard.jsp" class="admin-brand">
            <i class="bi bi-building"></i><span>Hotel Admin</span>
        </a>

        <nav class="admin-nav">
            <a href="${ctx}/admin/dashboard.jsp"
               class="admin-nav-link ${fn:contains(uri, '/admin/dashboard') ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i><span>Dashboard</span>
            </a>
            <a href="${ctx}/admin/reservations.jsp"
               class="admin-nav-link ${fn:contains(uri, '/admin/reservations') ? 'active' : ''}">
                <i class="bi bi-journal-check"></i><span>Reservations</span>
            </a>
            <a href="${ctx}/admin/rooms.jsp"
               class="admin-nav-link ${fn:contains(uri, '/admin/rooms') ? 'active' : ''}">
                <i class="bi bi-door-open"></i><span>Rooms</span>
            </a>
            <a href="${ctx}/admin/room-types.jsp"
               class="admin-nav-link ${fn:contains(uri, '/admin/room-types') ? 'active' : ''}">
                <i class="bi bi-tags"></i><span>Room types</span>
            </a>
            <a href="${ctx}/admin/customers.jsp"
               class="admin-nav-link ${fn:contains(uri, '/admin/customers') ? 'active' : ''}">
                <i class="bi bi-people"></i><span>Customers</span>
            </a>
        </nav>

        <div class="admin-sidebar-footer">
            <a href="${ctx}/index.jsp" class="admin-nav-link">
                <i class="bi bi-box-arrow-up-left"></i><span>View site</span>
            </a>
            <a href="${ctx}/logout" class="admin-nav-link">
                <i class="bi bi-box-arrow-right"></i><span>Log out</span>
            </a>
        </div>
    </aside>

    <div class="admin-main">

        <header class="admin-topbar">
            <button class="admin-menu-toggle d-lg-none" type="button" aria-label="Toggle menu"
                    onclick="document.querySelector('.admin-layout').classList.toggle('sidebar-open')">
                <i class="bi bi-list"></i>
            </button>

            <h1 class="admin-page-title"><c:out value="${empty pageTitle ? 'Dashboard' : pageTitle}" /></h1>

            <%-- ============================================================
                 BACKEND: CURRENT ADMIN NAME
                 AdminFilter should already guarantee sessionScope.user exists
                 and sessionScope.user.role == 'ADMIN' before any /admin/* page
                 is reached, so this should never be empty in practice.
                 ============================================================ --%>
            <div class="admin-user">
                <i class="bi bi-person-circle"></i>
                <span><c:out value="${empty sessionScope.user ? 'Admin' : sessionScope.user.fullName}" /></span>
            </div>
        </header>

        <main class="admin-content">