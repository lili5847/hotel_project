<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Create account" />
</jsp:include>
<jsp:include page="/common/navbar.jsp" />

<main class="flex-grow-1 d-flex align-items-center py-5">
    <div class="container auth-shell">
        <div class="card border-0 shadow rounded-4 overflow-hidden">
            <div class="row g-0">

                <!-- Photo panel (hidden on small screens) -->
                <div class="col-lg-5 auth-aside d-none d-lg-flex flex-column justify-content-end p-5">
                    <h2 class="h3">Book in a minute</h2>
                    <p class="mb-0">One account lets you reserve rooms and keep track of every stay.</p>
                </div>

                <!-- Form -->
                <div class="col-lg-7 p-4 p-md-5">
                    <h1 class="h3 mb-1">Create your account</h1>
                    <p class="text-body-secondary mb-4">
                        Already registered? <a href="${ctx}/Customer/login.jsp">Log in</a>
                    </p>

                    <%-- General Error Banner --%>
                    <div id="generalErrorAlert" class="alert alert-danger ${empty error ? 'd-none' : ''}" role="alert">
                        <span id="generalErrorMessage"><c:out value="${error}" /></span>
                    </div>

                    <%-- Form --%>
                    <form id="registerForm" action="${ctx}/register" method="post" class="needs-validation" novalidate onsubmit="handleRegisterSubmit(event)">

                        <div class="row g-3">
                            <div class="col-12">
                                <label for="fullName" class="form-label">Full name</label>
                                <input type="text" class="form-control ${not empty errors.fullName ? 'is-invalid' : ''}"
                                       id="fullName" name="fullName" maxlength="100"
                                       value="<c:out value='${param.fullName}' />"
                                       autocomplete="name" required autofocus>
                                <div class="invalid-feedback" id="fullNameError">
                                    <c:out value="${empty errors.fullName ? 'Enter your full name.' : errors.fullName}" />
                                </div>
                            </div>

                            <div class="col-md-7">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}"
                                       id="email" name="email" maxlength="150"
                                       value="<c:out value='${param.email}' />"
                                       autocomplete="email" required>
                                <div class="invalid-feedback" id="emailError">
                                    <c:out value="${empty errors.email ? 'Enter a valid email address.' : errors.email}" />
                                </div>
                            </div>

                            <div class="col-md-5">
                                <label for="phone" class="form-label">Phone</label>
                                <input type="tel" class="form-control ${not empty errors.phone ? 'is-invalid' : ''}"
                                       id="phone" name="phone" maxlength="20"
                                       value="<c:out value='${param.phone}' />"
                                       autocomplete="tel" required>
                                <div class="invalid-feedback" id="phoneError">
                                    <c:out value="${empty errors.phone ? 'Enter your phone number.' : errors.phone}" />
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="password" class="form-label">Password</label>
                                <div class="input-group has-validation">
                                    <input type="password" class="form-control ${not empty errors.password ? 'is-invalid' : ''}"
                                           id="password" name="password" minlength="8"
                                           autocomplete="new-password" required>
                                    <button type="button" class="btn btn-outline-secondary"
                                            data-toggle-password="#password" aria-label="Show password">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <div class="invalid-feedback" id="passwordError">
                                        <c:out value="${empty errors.password ? 'Use at least 8 characters.' : errors.password}" />
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="confirmPassword" class="form-label">Confirm password</label>
                                <div class="input-group has-validation">
                                    <input type="password" class="form-control ${not empty errors.confirmPassword ? 'is-invalid' : ''}"
                                           id="confirmPassword" name="confirmPassword"
                                           autocomplete="new-password" required>
                                    <button type="button" class="btn btn-outline-secondary"
                                            data-toggle-password="#confirmPassword" aria-label="Show password">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <div class="invalid-feedback" id="confirmPasswordError">
                                        <c:out value="${empty errors.confirmPassword ? 'Passwords do not match.' : errors.confirmPassword}" />
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 d-grid mt-2">
                                <button type="submit" id="submitBtn" class="btn btn-primary btn-lg">Create account</button>
                            </div>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
</main>

<script src="${ctx}/assets/js/auth.js"></script>

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION FOR REGISTRATION
============================================================ -->
<script>
    function handleRegisterSubmit(event) {
        event.preventDefault();

        const form = document.getElementById('registerForm');
        const submitBtn = document.getElementById('submitBtn');
        const generalErrorAlert = document.getElementById('generalErrorAlert');
        const generalErrorMessage = document.getElementById('generalErrorMessage');

        // Reset validation states
        form.classList.remove('was-validated');
        generalErrorAlert.classList.add('d-none');
        clearFieldErrors();

        const fullName = document.getElementById('fullName').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        let hasClientError = false;

        // Client-side password match check
        if (password !== confirmPassword) {
            showFieldError('confirmPassword', 'Passwords do not match.');
            hasClientError = true;
        }

        if (!form.checkValidity() || hasClientError) {
            form.classList.add('was-validated');
            return;
        }

        // Disable submit button and show loading state
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Creating account...';

        // Send JSON request via Fetch API to Spring Boot Backend
        fetch('${ctx}/api/auth/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                fullName: fullName,
                email: email,
                phone: phone,
                password: password,
                confirmPassword: confirmPassword
            })
        })
            .then(async response => {
                const data = await response.json().catch(() => ({}));
                if (response.ok) {
                    return data;
                } else {
                    throw { status: response.status, data: data };
                }
            })
            .then(data => {
                // Successful registration -> redirect to login page with registered flag
                window.location.href = '${ctx}/Customer/login.jsp?registered=1';
            })
            .catch(error => {
                submitBtn.disabled = false;
                submitBtn.innerHTML = 'Create account';

                if (error.data) {
                    // Handle field validation errors returned from Spring Boot
                    if (error.data.errors) {
                        const errs = error.data.errors;
                        if (errs.fullName) showFieldError('fullName', errs.fullName);
                        if (errs.email) showFieldError('email', errs.email);
                        if (errs.phone) showFieldError('phone', errs.phone);
                        if (errs.password) showFieldError('password', errs.password);
                        if (errs.confirmPassword) showFieldError('confirmPassword', errs.confirmPassword);
                    }
                    if (error.data.message) {
                        generalErrorMessage.textContent = error.data.message;
                        generalErrorAlert.classList.remove('d-none');
                    }
                } else {
                    generalErrorMessage.textContent = 'Something went wrong. Please try again.';
                    generalErrorAlert.classList.remove('d-none');
                }
            });
    }

    function showFieldError(fieldId, message) {
        const input = document.getElementById(fieldId);
        const errorDiv = document.getElementById(fieldId + 'Error');
        if (input && errorDiv) {
            input.classList.add('is-invalid');
            errorDiv.textContent = message;
        }
    }

    function clearFieldErrors() {
        const fields = ['fullName', 'email', 'phone', 'password', 'confirmPassword'];
        fields.forEach(fieldId => {
            const input = document.getElementById(fieldId);
            if (input) {
                input.classList.remove('is-invalid');
            }
        });
    }
</script>

<jsp:include page="/common/footer.jsp" />