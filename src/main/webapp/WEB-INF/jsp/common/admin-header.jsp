
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String adminCtx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        <%= request.getParameter("title") == null
                ? "Admin"
                : request.getParameter("title") %>
        - Hotel Admin
    </title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
        rel="stylesheet">

    <style>
        body {
            background: #f5f7fa;
        }

        .sidebar {
            min-height: 100vh;
            background: #212529;
        }

        .sidebar a {
            color: #adb5bd;
            text-decoration: none;
            display: block;
            padding: 12px 20px;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: #343a40;
            color: white;
        }

        .panel {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .panel-header {
            padding: 16px 20px;
            border-bottom: 1px solid #eee;
        }

        .admin-table th {
            font-size: .75rem;
            text-transform: uppercase;
            color: #6c757d;
        }

        .status-badge {
            font-weight: 500;
        }

        .status-pending {
            background: #ffc107;
            color: #000;
        }

        .status-confirmed {
            background: #198754;
        }

        .status-checked-in {
            background: #0d6efd;
        }

        .status-cancelled {
            background: #dc3545;
        }
    </style>
</head>

<body>

<div class="container-fluid">
    <div class="row">

