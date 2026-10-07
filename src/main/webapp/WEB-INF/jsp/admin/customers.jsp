
<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/jsp/common/admin-header.jsp">
    <jsp:param name="title" value="Customers" />
</jsp:include>

<jsp:include page="/WEB-INF/jsp/common/admin-sidebar.jsp" />

<div class="mb-4">

    <h1 class="h4 mb-0">
        Customers
    </h1>

    <p class="text-body-secondary small mb-0">
        View registered guests and their reservation activity.
    </p>

</div>


<!-- SEARCH PANEL -->

<div class="panel mb-4">

    <form id="searchForm"
          class="p-3"
          onsubmit="event.preventDefault(); loadCustomers();">

        <div class="row g-3 align-items-end">

            <div class="col-md-6">

                <label for="q" class="form-label">
                    Search by name or email
                </label>

                <input type="text"
                       class="form-control"
                       id="q"
                       name="q"
                       placeholder="e.g. jane@example.com">

            </div>

            <div class="col-md-2 d-grid">

                <button type="submit"
                        class="btn btn-outline-primary">
                    Search
                </button>

            </div>

        </div>

    </form>

</div>


<!-- CUSTOMERS TABLE -->

<div class="panel">

    <div class="panel-header">

        <h2 class="h5 mb-0">

            All customers

            <span id="customerCount"
                  class="text-body-secondary fw-normal">
            </span>

        </h2>

    </div>


    <div class="table-responsive">

        <table class="table admin-table align-middle mb-0">

            <thead>

            <tr>
                <th>Name</th>
                <th>Contact</th>
                <th>Reservations</th>
                <th>Joined</th>
                <th>Status</th>
                <th class="text-end">Actions</th>
            </tr>

            </thead>


            <tbody id="customerTableBody">

            <tr>

                <td colspan="6"
                    class="text-center py-4">

                    Loading data...

                </td>

            </tr>

            </tbody>

        </table>

    </div>

</div>


<jsp:include page="/WEB-INF/jsp/common/admin-footer.jsp" />



<script>

    const ctx = '<%= request.getContextPath() %>';

    document.addEventListener('DOMContentLoaded', function () {

        console.log('CUSTOMERS PAGE LOADED');

        loadCustomers();
    });


    function loadCustomers() {

        const queryElement =
            document.getElementById('q');

        const query =
            queryElement
                ? queryElement.value.trim()
                : '';

        const token =
            localStorage.getItem('token');

        // IMPORTANT:
        // CustomerRestController uses this endpoint.
        let url =
            ctx + '/api/admin/customers';

        if (query) {

            url += '?q=' +
                encodeURIComponent(query);
        }

        console.log(
            'CUSTOMER API:',
            url
        );

        console.log(
            'Token exists:',
            !!token
        );

        fetch(url, {

            method: 'GET',

            headers: {
                'Content-Type':
                    'application/json',

                'Authorization':
                    'Bearer ' + token
            }

        })

        .then(function (response) {

            console.log(
                'CUSTOMER API STATUS:',
                response.status
            );

            return response.json()

                .catch(function () {
                    return {};
                })

                .then(function (data) {

                    if (!response.ok) {

                        throw new Error(
                            data.message ||
                            'HTTP ' + response.status
                        );
                    }

                    return data;
                });
        })

        .then(function (data) {

            console.log(
                'CUSTOMER API RESPONSE:',
                data
            );

            let customers = [];

            /*
             * ApiResponse normally returns:
             *
             * {
             *     success: true,
             *     data: [...]
             * }
             */

            if (Array.isArray(data)) {

                customers = data;

            }
            else if (
                data &&
                Array.isArray(data.data)
            ) {

                customers = data.data;
            }

            renderCustomerTable(customers);
        })

        .catch(function (error) {

            console.error(
                'Error fetching customers:',
                error
            );

            const tbody =
                document.getElementById(
                    'customerTableBody'
                );

            tbody.innerHTML =
                '<tr>' +
                '<td colspan="6" ' +
                'class="text-center text-danger py-4">' +

                '<i class="bi bi-exclamation-triangle fs-3"></i>' +

                '<p class="mb-0 mt-2">' +

                escapeHtml(
                    error.message ||
                    'Could not load customers.'
                ) +

                '</p>' +

                '</td>' +
                '</tr>';
        });
    }


    function renderCustomerTable(customers) {

        const tbody =
            document.getElementById(
                'customerTableBody'
            );

        const countSpan =
            document.getElementById(
                'customerCount'
            );

        if (countSpan) {

            countSpan.textContent =
                '(' + customers.length + ')';
        }


        if (customers.length === 0) {

            tbody.innerHTML =
                '<tr>' +

                '<td colspan="6" ' +
                'class="text-center py-4">' +

                '<i class="bi bi-people fs-3 text-secondary"></i>' +

                '<p class="mb-0 mt-2">' +
                'No customers found.' +
                '</p>' +

                '</td>' +

                '</tr>';

            return;
        }


        let html = '';


        customers.forEach(function (cust) {

            /*
             * USER ID
             */
            const customerId =
                cust.userId ||
                cust.id;


            /*
             * NAME
             */
            const fullName =
                cust.fullName ||
                cust.username ||
                'N/A';


            /*
             * EMAIL
             */
            const email =
                cust.email ||
                'N/A';


            /*
             * PHONE
             */
            const phone =
                cust.phone ||
                '';


            /*
             * Reservation count is not currently
             * provided by User.java.
             */
            const reservationCount =
                cust.reservationCount || 0;


            /*
             * CREATED DATE
             */
            const joinedDate =
                cust.createdAt ||
                'N/A';


            /*
             * STATUS
             */
            const status =
                cust.status ||
                'ACTIVE';


            const isActive =
                String(status).toUpperCase() ===
                'ACTIVE';


            const badgeClass =
                isActive
                    ? 'status-confirmed'
                    : 'status-cancelled';


            const badgeText =
                isActive
                    ? 'Active'
                    : 'Suspended';


            /*
             * ACTION BUTTON
             */
            let actionButton = '';


            if (isActive) {

                actionButton =
                    '<button type="button" ' +

                    'onclick="toggleCustomerStatus(' +
                    customerId +
                    ', \'suspend\')" ' +

                    'class="btn btn-sm btn-outline-danger">' +

                    'Suspend' +

                    '</button>';

            }
            else {

                actionButton =
                    '<button type="button" ' +

                    'onclick="toggleCustomerStatus(' +
                    customerId +
                    ', \'activate\')" ' +

                    'class="btn btn-sm btn-outline-primary">' +

                    'Re-activate' +

                    '</button>';
            }


            /*
             * TABLE ROW
             */
            html +=

                '<tr>' +

                '<td class="fw-medium">' +
                escapeHtml(fullName) +
                '</td>' +


                '<td>' +

                '<div class="small">' +
                escapeHtml(email) +
                '</div>' +

                '<div class="small text-body-secondary">' +
                escapeHtml(phone) +
                '</div>' +

                '</td>' +


                '<td>' +

                '<span class="small">' +
                escapeHtml(
                    String(reservationCount)
                ) +

                ' booking(s)' +

                '</span>' +

                '</td>' +


                '<td>' +

                escapeHtml(
                    String(joinedDate)
                ) +

                '</td>' +


                '<td>' +

                '<span class="badge status-badge ' +
                badgeClass +
                '">' +

                badgeText +

                '</span>' +

                '</td>' +


                '<td class="text-end">' +

                actionButton +

                '</td>' +

                '</tr>';
        });


        tbody.innerHTML = html;
    }


    function toggleCustomerStatus(
        customerId,
        action
    ) {

        if (
            action === 'suspend' &&
            !confirm(
                'Suspend this account?'
            )
        ) {
            return;
        }


        const token =
            localStorage.getItem('token');


        const url =
            ctx +
            '/api/admin/customers/' +
            customerId +
            '/' +
            action;


        console.log(
            'CUSTOMER STATUS API:',
            url
        );


        fetch(url, {

            method: 'POST',

            headers: {

                'Content-Type':
                    'application/json',

                'Authorization':
                    'Bearer ' + token
            }

        })

        .then(function (response) {

            return response.json()

                .catch(function () {
                    return {};
                })

                .then(function (data) {

                    if (!response.ok) {

                        throw new Error(
                            data.message ||
                            'Operation failed. HTTP ' +
                            response.status
                        );
                    }

                    return data;
                });
        })

        .then(function (data) {

            console.log(
                'STATUS UPDATE RESPONSE:',
                data
            );

            loadCustomers();
        })

        .catch(function (error) {

            console.error(
                'Error toggling status:',
                error
            );

            alert(
                error.message ||
                'Operation failed.'
            );
        });
    }


    function escapeHtml(value) {

        if (
            value === null ||
            value === undefined
        ) {
            return '';
        }


        return String(value)

            .replace(
                /&/g,
                '&amp;'
            )

            .replace(
                /</g,
                '&lt;'
            )

            .replace(
                />/g,
                '&gt;'
            )

            .replace(
                /"/g,
                '&quot;'
            )

            .replace(
                /'/g,
                '&#039;'
            );
    }

</script>

