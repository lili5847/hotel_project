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
                        Already registered? <a href="${ctx}/login">Log in</a>
                    </p>

                    <%-- ============================================================
                         BACKEND 1: MESSAGES SHOWN TO THE USER
                         - "error"  : general failure, e.g.
                                      request.setAttribute("error", "Something went wrong. Try again.");
                         - "errors" : a Map<String,String> with one message per field.
                                      Keys used below: fullName, email, phone, password, confirmPassword
                                      e.g. errors.put("email", "This email is already registered.");
                         After setting them, forward back to /customer/register.jsp.
                         Text the user typed is kept automatically (from request params),
                         except passwords, which are never sent back.
                         ============================================================ --%>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert"><c:out value="${error}" /></div>
                    </c:if>

                    <%-- ============================================================
                         BACKEND 2: FORM SUBMIT
                         POST to /register  ->  RegisterServlet.doPost()
                         Parameters sent: fullName, email, phone, password, confirmPassword
                         In the servlet:
                           1. validate every field again (never trust the browser check)
                           2. check the email is not taken (UserDAO)
                           3. hash the password with PasswordUtil (jBCrypt)
                           4. save with UserDAO using a PreparedStatement
                           5. response.sendRedirect(ctx + "/login?registered=1");
                         If your User model uses different fields (for example username),
                         change the name="" attributes below to match.
                         ============================================================ --%>
                    <form action="${ctx}/register" method="post" class="needs-validation" novalidate>

                        <%-- BACKEND (optional): CSRF token, uncomment when you add it
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        --%>

                        <div class="row g-3">
                            <div class="col-12">
                                <label for="fullName" class="form-label">Full name</label>
                                <input type="text" class="form-control ${not empty errors.fullName ? 'is-invalid' : ''}"
                                       id="fullName" name="fullName" maxlength="100"
                                       value="<c:out value='${param.fullName}' />"
                                       autocomplete="name" required autofocus>
                                <div class="invalid-feedback">
                                    <c:out value="${empty errors.fullName ? 'Enter your full name.' : errors.fullName}" />
                                </div>
                            </div>

                            <div class="col-md-7">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}"
                                       id="email" name="email" maxlength="150"
                                       value="<c:out value='${param.email}' />"
                                       autocomplete="email" required>
                                <div class="invalid-feedback">
                                    <c:out value="${empty errors.email ? 'Enter a valid email address.' : errors.email}" />
                                </div>
                            </div>

                            <div class="col-md-5">
                                <label for="phone" class="form-label">Phone</label>
                                <input type="tel" class="form-control ${not empty errors.phone ? 'is-invalid' : ''}"
                                       id="phone" name="phone" maxlength="20"
                                       value="<c:out value='${param.phone}' />"
                                       autocomplete="tel" required>
                                <div class="invalid-feedback">
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
                                    <div class="invalid-feedback">
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
                                    <div class="invalid-feedback">
                                        <c:out value="${empty errors.confirmPassword ? 'Passwords do not match.' : errors.confirmPassword}" />
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 d-grid mt-2">
                                <button type="submit" class="btn btn-primary btn-lg">Create account</button>
                            </div>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
</main>

<script src="${ctx}/assets/js/auth.js"></script>

<jsp:include page="/common/footer.jsp" />