```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Register - Hotel Reservation</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

    <style>

        body {
            background: #f7f8fa;
            min-height: 100vh;
        }

        .register-wrapper {
            min-height: calc(100vh - 72px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 15px;
        }

        .register-card {
            width: 100%;
            max-width: 500px;
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 35px;
            box-shadow: 0 10px 35px rgba(0, 0, 0, .08);
        }

        .register-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #198754;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 30px;
        }

    </style>

</head>


<body>


<!-- ========================= -->
<!-- NAVBAR -->
<!-- ========================= -->

<nav class="navbar navbar-expand-lg bg-white border-bottom">

    <div class="container">

        <a class="navbar-brand fw-bold"
           href="${ctx}/">

            <i class="bi bi-building me-2"></i>

            Hotel

        </a>


        <a href="${ctx}/login"
           class="btn btn-outline-primary btn-sm">

            <i class="bi bi-box-arrow-in-right me-1"></i>

            Login

        </a>

    </div>

</nav>


<!-- ========================= -->
<!-- REGISTER -->
<!-- ========================= -->

<div class="register-wrapper">

    <div class="register-card">


        <!-- ICON -->

        <div class="register-icon">

            <i class="bi bi-person-plus"></i>

        </div>


        <!-- TITLE -->

        <h2 class="text-center fw-bold mb-2">

            Create Account

        </h2>


        <p class="text-center text-muted mb-4">

            Register to book your hotel room.

        </p>


        <!-- ERROR -->

        <div id="registerError"
             class="alert alert-danger d-none">

        </div>


        <!-- SUCCESS -->

        <div id="registerSuccess"
             class="alert alert-success d-none">

        </div>


        <!-- ========================= -->
        <!-- FORM -->
        <!-- ========================= -->

        <form id="registerForm">


            <!-- USERNAME -->

            <div class="mb-3">

                <label for="username"
                       class="form-label fw-medium">

                    Username

                </label>

                <div class="input-group">

                    <span class="input-group-text">

                        <i class="bi bi-person"></i>

                    </span>

                    <input
                        type="text"
                        class="form-control"
                        id="username"
                        name="username"
                        minlength="3"
                        maxlength="30"
                        placeholder="Enter username"
                        required>

                </div>

                <div class="form-text">

                    Username must be 3–30 characters.

                </div>

            </div>


            <!-- FULL NAME -->

            <div class="mb-3">

                <label for="fullName"
                       class="form-label fw-medium">

                    Full Name

                </label>

                <div class="input-group">

                    <span class="input-group-text">

                        <i class="bi bi-person-vcard"></i>

                    </span>

                    <input
                        type="text"
                        class="form-control"
                        id="fullName"
                        name="fullName"
                        placeholder="Enter your full name"
                        required>

                </div>

            </div>


            <!-- EMAIL -->

            <div class="mb-3">

                <label for="email"
                       class="form-label fw-medium">

                    Email

                </label>

                <div class="input-group">

                    <span class="input-group-text">

                        <i class="bi bi-envelope"></i>

                    </span>

                    <input
                        type="email"
                        class="form-control"
                        id="email"
                        name="email"
                        placeholder="Enter your email"
                        required>

                </div>

            </div>


            <!-- PHONE -->

            <div class="mb-3">

                <label for="phone"
                       class="form-label fw-medium">

                    Phone
                    <span class="text-muted">
                        (Optional)
                    </span>

                </label>

                <div class="input-group">

                    <span class="input-group-text">

                        <i class="bi bi-telephone"></i>

                    </span>

                    <input
                        type="text"
                        class="form-control"
                        id="phone"
                        name="phone"
                        placeholder="Enter phone number">

                </div>

            </div>


            <!-- PASSWORD -->

            <div class="mb-3">

                <label for="password"
                       class="form-label fw-medium">

                    Password

                </label>

                <div class="input-group">

                    <span class="input-group-text">

                        <i class="bi bi-lock"></i>

                    </span>

                    <input
                        type="password"
                        class="form-control"
                        id="password"
                        name="password"
                        minlength="6"
                        placeholder="At least 6 characters"
                        required>

                </div>

            </div>


            <!-- CONFIRM PASSWORD -->

            <div class="mb-4">

                <label for="confirmPassword"
                       class="form-label fw-medium">

                    Confirm Password

                </label>

                <div class="input-group">

                    <span class="input-group-text">

                        <i class="bi bi-shield-lock"></i>

                    </span>

                    <input
                        type="password"
                        class="form-control"
                        id="confirmPassword"
                        name="confirmPassword"
                        minlength="6"
                        placeholder="Repeat your password"
                        required>

                </div>

            </div>


            <!-- SUBMIT -->

            <button
                type="submit"
                class="btn btn-success w-100 py-2">

                <i class="bi bi-person-plus me-2"></i>

                Create Account

            </button>


        </form>


        <!-- LOGIN LINK -->

        <div class="text-center mt-4">

            <span class="text-muted">

                Already have an account?

            </span>

            <a href="${ctx}/login">

                Login

            </a>

        </div>


    </div>

</div>


<!-- ========================= -->
<!-- JAVASCRIPT -->
<!-- ========================= -->

<script>

document
    .getElementById("registerForm")
    .addEventListener("submit", async function(event) {

        event.preventDefault();


        const username =
            document
                .getElementById("username")
                .value
                .trim();


        const fullName =
            document
                .getElementById("fullName")
                .value
                .trim();


        const email =
            document
                .getElementById("email")
                .value
                .trim();


        const phone =
            document
                .getElementById("phone")
                .value
                .trim();


        const password =
            document
                .getElementById("password")
                .value;


        const confirmPassword =
            document
                .getElementById("confirmPassword")
                .value;


        const errorBox =
            document.getElementById("registerError");


        const successBox =
            document.getElementById("registerSuccess");


        errorBox.classList.add("d-none");

        successBox.classList.add("d-none");


        // =========================
        // VALIDATE PASSWORD
        // =========================

        if (password !== confirmPassword) {

            errorBox.textContent =
                "Passwords do not match.";

            errorBox.classList.remove("d-none");

            return;
        }


        // =========================
        // VALIDATE USERNAME
        // =========================

        if (
            username.length < 3 ||
            username.length > 30
        ) {

            errorBox.textContent =
                "Username must be between 3 and 30 characters.";

            errorBox.classList.remove("d-none");

            return;
        }


        // =========================
        // SEND REQUEST
        // =========================

        try {

            const response =
                await fetch(
                    "${ctx}/api/auth/register",
                    {
                        method: "POST",

                        headers: {
                            "Content-Type":
                                "application/json"
                        },

                        body: JSON.stringify({

                            username: username,

                            email: email,

                            password: password,

                            fullName: fullName,

                            phone: phone

                        })
                    }
                );


            const data =
                await response
                    .json()
                    .catch(() => ({}));


            // =========================
            // SUCCESS
            // =========================

            if (response.ok) {

                successBox.textContent =
                    "Registration successful. Redirecting to login...";

                successBox.classList.remove("d-none");


                setTimeout(function() {

                    window.location.href =
                        "${ctx}/login";

                }, 1200);

            }


            // =========================
            // ERROR
            // =========================

            else {

                let message =
                    data.message ||
                    "Registration failed.";


                // Validation errors
                if (
                    data.data &&
                    typeof data.data === "object"
                ) {

                    const validationErrors =
                        Object.values(data.data);

                    if (validationErrors.length > 0) {

                        message =
                            validationErrors.join(" ");

                    }

                }


                errorBox.textContent =
                    message;

                errorBox.classList.remove("d-none");

            }


        } catch (error) {

            console.error(
                "Register Error:",
                error
            );


            errorBox.textContent =
                "Unable to connect to the server.";


            errorBox.classList.remove(
                "d-none"
            );

        }

    });

</script>


</body>

</html>
```
