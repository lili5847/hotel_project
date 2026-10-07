<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<nav class="navbar navbar-expand-lg bg-white border-bottom sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${ctx}/index.jsp">
            <i class="bi bi-building me-2"></i>Hotel Reservation
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#mainNav" aria-controls="mainNav"
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav mx-lg-auto" id="dynamicNavLinks">
                <li class="nav-item">
                    <a class="nav-link" href="${ctx}/index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${ctx}/rooms">Rooms</a>
                </li>
                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/reservations">My reservations</a>
                    </li>
                </c:if>
                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/admin/dashboard">Admin dashboard</a>
                    </li>
                </c:if>
            </ul>

            <ul class="navbar-nav align-items-lg-center gap-2 mt-2 mt-lg-0" id="dynamicAuthArea">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="btn btn-outline-primary btn-sm px-3" href="${ctx}/Customer/login">Log in</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm px-3" href="${ctx}/Customer/register">Create account</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button"
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle me-1"></i>
                                <c:out value="${sessionScope.user.fullName}" />
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${ctx}/reservations">My reservations</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${ctx}/logout" onclick="handleNavbarLogout(event)">Log out</a></li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION FOR NAVBAR
============================================================ -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        checkNavbarUserStatus();
    });

    function checkNavbarUserStatus() {
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
                throw new Error('Not authenticated via API');
            })
            .then(user => {
                if (user && user.fullName) {
                    renderDynamicNavbar(user);
                }
            })
            .catch(error => {
                console.warn('User status check failed or token invalid:', error);
            });
    }

    function renderDynamicNavbar(user) {
        const navLinks = document.getElementById('dynamicNavLinks');
        const authArea = document.getElementById('dynamicAuthArea');

        if (navLinks) {
            let extraLinksHtml = '';
            if (user.role === 'ADMIN') {
                extraLinksHtml += `<li class="nav-item"><a class="nav-link" href="${ctx}/admin/dashboard">Admin dashboard</a></li>`;
            }
            extraLinksHtml += `<li class="nav-item"><a class="nav-link" href="${ctx}/reservations">My reservations</a></li>`;

            navLinks.innerHTML = `
            <li class="nav-item"><a class="nav-link" href="${ctx}/index.jsp">Home</a></li>
            <li class="nav-item"><a class="nav-link" href="${ctx}/rooms">Rooms</a></li>
            ${extraLinksHtml}
        `;
        }

        if (authArea) {
            authArea.innerHTML = `
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-person-circle me-1"></i>
                    ${escapeHtml(user.fullName)}
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="${ctx}/reservations">My reservations</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="#" onclick="handleNavbarLogout(event)">Log out</a></li>
                </ul>
            </li>
        `;
        }
    }

    function handleNavbarLogout(event) {
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