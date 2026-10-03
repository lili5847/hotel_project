
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Login - Hotel Reservation</title>

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

        .login-wrapper {
            min-height: calc(100vh - 72px);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            width: 100%;
            max-width: 450px;
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 35px;
            box-shadow: 0 10px 35px rgba(0, 0, 0, .08);
        }

        .login-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #0d6efd;
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


<!-- NAVBAR -->

<nav class="navbar navbar-expand-lg bg-white border-bottom">

    <div class="container">

        <a class="navbar-brand fw-bold"
           href="${ctx}/">

            <i class="bi bi-building me-2"></i>
            Hotel

        </a>


        <div class="ms-auto">

            <a href="${ctx}/rooms"
               class="btn btn-outline-primary btn-sm">

                <i class="bi bi-door-open me-1"></i>
                Browse Rooms

            </a>

        </div>

    </div>

</nav>



<!-- LOGIN -->

<div class="login-wrapper">

    <div class="login-card">


        <div class="login-icon">

            <i class="bi bi-person"></i>

        </div>


        <h2 class="text-center fw-bold mb-2">
            Welcome Back
        </h2>


        <p class="text-center text-muted mb-4">
            Login to manage your reservations.
        </p>



        <div id="loginError"
             class="alert alert-danger d-none">
        </div>



        <form id="loginForm"
              onsubmit="handleLogin(event)">


            <!-- USERNAME OR EMAIL -->

            <div class="mb-3">

                <label for="usernameOrEmail"
                       class="form-label fw-medium">

                    Username or Email

                </label>


                <div class="input-group">

                    <span class="input-group-text">

                        <i class="bi bi-person"></i>

                    </span>


                    <input
                        type="text"
                        class="form-control"
                        id="usernameOrEmail"
                        name="usernameOrEmail"
                        placeholder="Enter username or email"
                        autocomplete="username"
                        required>

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
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>

                </div>

            </div>



            <!-- LOGIN BUTTON -->

            <button
                id="loginButton"
                type="submit"
                class="btn btn-primary w-100 py-2">

                <i class="bi bi-box-arrow-in-right me-2"></i>

                Login

            </button>


        </form>



        <div class="text-center mt-4">

            <span class="text-muted">
                Don't have an account?
            </span>

            <a href="${ctx}/register">
                Register
            </a>

        </div>


    </div>

</div>



<script>

async function handleLogin(event) {

    /*
     * VERY IMPORTANT:
     * Stop the browser from performing
     * normal GET/POST form submission.
     */
    event.preventDefault();
    event.stopPropagation();


    console.log("LOGIN JAVASCRIPT RUNNING");


    const usernameOrEmail =
        document.getElementById("usernameOrEmail")
            .value
            .trim();


    const password =
        document.getElementById("password")
            .value;


    const errorBox =
        document.getElementById("loginError");


    const loginButton =
        document.getElementById("loginButton");


    errorBox.classList.add("d-none");
    errorBox.textContent = "";


    loginButton.disabled = true;
    loginButton.innerHTML =
        '<span class="spinner-border spinner-border-sm me-2"></span>Logging in...';


    try {


        console.log("Sending POST /api/auth/login");


        const response = await fetch(
            "${ctx}/api/auth/login",
            {
                method: "POST",

                headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                },

                credentials: "same-origin",

                body: JSON.stringify({
                    usernameOrEmail: usernameOrEmail,
                    password: password
                })
            }
        );


        const result =
            await response.json().catch(function() {
                return {};
            });


        console.log("LOGIN HTTP STATUS:", response.status);

        console.log("LOGIN RESPONSE:", result);


        if (response.ok && result.success) {


            const token =
                result.data &&
                result.data.accessToken;


            if (!token) {

                errorBox.textContent =
                    "Login succeeded, but no access token was returned.";

                errorBox.classList.remove("d-none");

                return;
            }


            /*
             * Store JWT
             */
            localStorage.setItem("token", token);


            console.log("LOGIN SUCCESS");


            /*
             * Go to rooms
             */
            window.location.href =
                "${ctx}/after-login";


            return;

        }


        errorBox.textContent =
            result.message ||
            "Invalid username/email or password.";

        errorBox.classList.remove("d-none");


    } catch (error) {


        console.error("LOGIN ERROR:", error);


        errorBox.textContent =
            "Unable to connect to the server.";

        errorBox.classList.remove("d-none");


    } finally {


        loginButton.disabled = false;

        loginButton.innerHTML =
            '<i class="bi bi-box-arrow-in-right me-2"></i>Login';

    }

}

</script>


</body>

</html>

