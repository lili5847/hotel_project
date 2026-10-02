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
                <ul class="nav justify-content-md-end small" id="footerNavLinks">
                    <li class="nav-item"><a class="nav-link px-2 text-body-secondary" href="${ctx}/rooms">Rooms</a></li>
                    <li class="nav-item"><a class="nav-link px-2 text-body-secondary" href="${ctx}/Customer/login.jsp">Log in</a></li>
                    <li class="nav-item"><a class="nav-link px-2 text-body-secondary" href="${ctx}/Customer/register.jsp">Create account</a></li>
                </ul>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap JS (needed for the navbar toggle and dropdown) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION FOR FOOTER NAV
============================================================ -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        updateFooterNavStatus();
    });

    function updateFooterNavStatus() {
        const token = localStorage.getItem('accessToken');
        if (!token) return;

        fetch('${ctx}/api/auth/me', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (response.ok) return response.json();
                throw new Error('Not authenticated');
            })
            .then(user => {
                if (user && user.fullName) {
                    const footerNav = document.getElementById('footerNavLinks');
                    if (!footerNav) return;

                    const isCustomer = user.role === 'CUSTOMER';
                    const profileLink = isCustomer ? '${ctx}/my-reservations.jsp' : '${ctx}/admin/dashboard.jsp';

                    footerNav.innerHTML = `
                <li class="nav-item"><a class="nav-link px-2 text-body-secondary" href="${ctx}/rooms">Rooms</a></li>
                <li class="nav-item"><a class="nav-link px-2 text-body-secondary" href="${profileLink}">My Account (${escapeHtml(user.fullName)})</a></li>
                <li class="nav-item"><a class="nav-link px-2 text-danger" href="#" onclick="handleFooterLogout(event)">Log out</a></li>
            `;
                }
            })
            .catch(error => {
                // User is not logged in or token is invalid
                console.warn('User not logged in via API:', error);
            });
    }

    function handleFooterLogout(event) {
        event.preventDefault();
        const token = localStorage.getItem('accessToken');

        fetch('${ctx}/api/auth/logout', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .finally(() => {
                localStorage.removeItem('accessToken');
                sessionStorage.clear();
                window.location.href = '${ctx}/Customer/login.jsp';
            });
    }

    function escapeHtml(str) {
        return String(str || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }
</script>
</body>
</html>