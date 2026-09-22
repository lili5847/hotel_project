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

                <!-- Photo panel (hidden on small screens) -->
                <!--  class="position-absolute top-0 start-0 w-100 h-100 object-fit-cover"-->
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

                    <%-- ============================================================
                         BACKEND 1: MESSAGES SHOWN TO THE USER
                         - "error"  : LoginServlet sets this on a failed login, e.g.
                                      request.setAttribute("error", "Incorrect email or password.");
                                      then forwards back to /customer/login.jsp
                         - ?registered=1 : RegisterServlet redirects here after sign-up
                         - ?loggedout=1  : LogoutServlet redirects here after logout
                         - ?required=1   : AuthFilter redirects here when login is needed
                         ============================================================ --%>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert"><c:out value="${error}" /></div>
                    </c:if>
                    <c:if test="${param.registered == '1'}">
                        <div class="alert alert-success" role="alert">Account created. Log in to continue.</div>
                    </c:if>
                    <c:if test="${param.loggedout == '1'}">
                        <div class="alert alert-info" role="alert">You have been logged out.</div>
                    </c:if>
                    <c:if test="${param.required == '1'}">
                        <div class="alert alert-warning" role="alert">Please log in to continue.</div>
                    </c:if>

                    <%-- ============================================================
                         BACKEND 2: FORM SUBMIT
                         POST to /login  ->  LoginServlet.doPost()
                         Parameters sent: email, password, redirect (optional)
                         On success in the servlet:
                           1. verify the password with PasswordUtil / jBCrypt
                           2. request.changeSessionId();
                           3. session.setAttribute("user", user);
                           4. redirect to "redirect" if it is a safe internal path,
                              otherwise to /admin/dashboard (ADMIN) or /index.jsp
                         ============================================================ --%>
                    <form action="${ctx}/login" method="post" class="needs-validation" novalidate>

                        <%-- BACKEND (optional): CSRF token, uncomment when you add it
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        --%>

                        <%-- BACKEND 3: where to go after login (set by AuthFilter, e.g. /login?redirect=/reservations).
                             Validate on the server that it starts with "/" so nobody can redirect users to another site. --%>
                        <input type="hidden" name="redirect" value="<c:out value='${param.redirect}' />">

                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email"
                                   value="<c:out value='${param.email}' />"
                                   autocomplete="email" required autofocus>
                            <div class="invalid-feedback">Enter a valid email address.</div>
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
                                <div class="invalid-feedback">Enter your password.</div>
                            </div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg">Log in</button>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
</main>

<script src="${ctx}/assets/js/auth.js"></script>

<jsp:include page="/common/footer.jsp" />