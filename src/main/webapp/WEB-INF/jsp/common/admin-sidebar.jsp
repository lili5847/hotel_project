
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String sbCtx = request.getContextPath();
    String currentPath = request.getRequestURI()
            .substring(request.getContextPath().length());
%>

<div class="col-md-3 col-lg-2 px-0 sidebar">

    <div class="p-4 text-white">
        <h4>
            <i class="bi bi-building me-2"></i>
            Hotel Admin
        </h4>
    </div>

    <a href="<%= sbCtx %>/admin"
       class="<%= "/admin".equals(currentPath) ? "active" : "" %>">
        <i class="bi bi-speedometer2 me-2"></i>
        Dashboard
    </a>

    <a href="<%= sbCtx %>/admin/reservations"
       class="<%= "/admin/reservations".equals(currentPath) ? "active" : "" %>">
        <i class="bi bi-calendar-check me-2"></i>
        Reservations
    </a>

    <a href="<%= sbCtx %>/admin/rooms"
       class="<%= "/admin/rooms".equals(currentPath) ? "active" : "" %>">
        <i class="bi bi-door-open me-2"></i>
        Rooms
    </a>

    <a href="<%= sbCtx %>/admin/room-types"
       class="<%= "/admin/room-types".equals(currentPath) ? "active" : "" %>">
        <i class="bi bi-grid me-2"></i>
        Room Types
    </a>

    <a href="<%= sbCtx %>/admin/customers"
       class="<%= "/admin/customers".equals(currentPath) ? "active" : "" %>">
        <i class="bi bi-people me-2"></i>
        Customers
    </a>

    <hr class="text-secondary">

    <a href="<%= sbCtx %>/rooms">
        <i class="bi bi-house me-2"></i>
        Customer Site
    </a>

    <a href="<%= sbCtx %>/login"
       onclick="localStorage.removeItem('accessToken');
                localStorage.removeItem('token');">
        <i class="bi bi-box-arrow-right me-2"></i>
        Logout
    </a>

</div>

<div class="col-md-9 col-lg-10">
    <div class="p-4">

