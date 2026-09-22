<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<footer class="bg-white border-top mt-auto py-4">
    <div class="container">
        <div class="row gy-3 align-items-center">
            <div class="col-md-6">
                <span class="fw-semibold">Hotel Reservation</span>
                <div class="small text-body-secondary">
                    &copy; <%= java.time.Year.now() %> Hotel Reservation System. ITE204 J2EE project.
                </div>
            </div>
            <div class="col-md-6">
                <ul class="nav justify-content-md-end small">
                    <li class="nav-item"><a class="nav-link px-2" href="${ctx}/rooms">Rooms</a></li>
                    <li class="nav-item"><a class="nav-link px-2" href="${ctx}/Customer/login.jsp">Log in</a></li>
                    <li class="nav-item"><a class="nav-link px-2" href="${ctx}/Customer/register.jsp">Create account</a></li>
                </ul>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap JS (needed for the navbar toggle and dropdown) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>