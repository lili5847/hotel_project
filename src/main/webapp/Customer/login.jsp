<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Log in" />
</jsp:include>
<jsp:include page="/common/navbar.jsp" />

<main class="flex-grow-1 d-flex align-items-center py-5">
    <div class="container auth-shell">
        <div class="card border-0 shadow rounded-4 overflow-hidden">
            <div class="row g-0">

                <!-- Photo panel -->
                <div class="col-lg-5 auth-aside d-none d-lg-flex flex-column justify-content-end p-5">
                    <h2 class="h3">Welcome back</h2>
                    <p class="mb-0">Log in to see your reservations and book your next stay.</p>
                </div>

                <!-- Form -->
                <div class="col-lg-7 p-4 p-md-5">
                    <h1 class="h3 mb-1">Log in</h1>
                    <p class="text-body-secondary mb-4">
                        New here? <a href="${ctx}/Customer/register.jsp">Create an account</a>
                    </p>

                    <!-- Alert Container for dynamic response messages -->
                    <div id="alert-message"></div>

                    <form id="loginForm" class="needs-validation" novalidate>

                        <div class="mb-3">
                            <label for="username" class="form-label">Username / Email</label>
                            <input type="text" class="form-control" id="username" name="username"
                                   autocomplete="username" required autofocus>
                            <div class="invalid-feedback">Please enter a valid username or email.</div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label">Password</label>
                            <div class="input-group has-validation">
                                <input type="password" class="form-control" id="password" name="password"
                                       autocomplete="current-password" required>
                                <button type="button" class="btn btn-outline-secondary"
                                        data-toggle-password="#password" aria-label="Show password">
                                    <i class="bi bi-eye"></i>
                                </button>
                                <div class="invalid-feedback">Please enter your password.</div>
                            </div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" id="btnLogin" class="btn btn-primary btn-lg">Log in</button>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
</main>

<!-- JavaScript Fetch API for Login -->
<script>
    const BASE_URL = '${ctx}/api';

    document.getElementById('loginForm').addEventListener('submit', async function (e) {
        e.preventDefault();

        const alertContainer = document.getElementById('alert-message');
        const btnLogin = document.getElementById('btnLogin');
        const usernameInput = document.getElementById('username').value.trim();
        const passwordInput = document.getElementById('password').value.trim();

        if (!usernameInput || !passwordInput) {
            this.classList.add('was-validated');
            return;
        }

        btnLogin.disabled = true;
        btnLogin.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Logging in...';
        alertContainer.innerHTML = '';

        try {
            const response = await fetch(`${BASE_URL}/auth/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    username: usernameInput,
                    password: passwordInput
                })
            });

            const result = await response.json();

            if (response.ok) {
                if (result.data && result.data.accessToken) {
                    localStorage.setItem('token', result.data.accessToken);
                    localStorage.setItem('user', JSON.stringify(result.data.user || {}));
                }

                alertContainer.innerHTML = `
                    <div class="alert alert-success" role="alert">
                        Login successful! Redirecting...
                    </div>`;

                setTimeout(() => {
                    const urlParams = new URLSearchParams(window.location.search);
                    const redirectUrl = urlParams.get('redirect') || '${ctx}/Customer/room-search.jsp';
                    window.location.href = redirectUrl;
                }, 1000);

            } else {
                alertContainer.innerHTML = `
                    <div class="alert alert-danger" role="alert">
                        ${result.message || 'Invalid username or password!'}
                    </div>`;
            }
        } catch (error) {
            console.error('Login Error:', error);
            alertContainer.innerHTML = `
                <div class="alert alert-danger" role="alert">
                    Failed to connect to the server. Please try again!
                </div>`;
        } finally {
            btnLogin.disabled = false;
            btnLogin.innerHTML = 'Log in';
        }
    });
</script>

<script src="${ctx}/assets/js/auth.js"></script>

<jsp:include page="/common/footer.jsp" />