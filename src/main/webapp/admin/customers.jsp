<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Customers" />
</jsp:include>
<jsp:include page="/common/admin-sidebar.jsp" />

<div class="mb-4">
    <h1 class="h4 mb-0">Customers</h1>
    <p class="text-body-secondary small mb-0">View registered guests and their reservation activity.</p>
</div>

<!-- Search Panel -->
<div class="panel mb-4">
    <form id="searchForm" class="p-3" onsubmit="event.preventDefault(); loadCustomers();">
        <div class="row g-3 align-items-end">
            <div class="col-md-6">
                <label for="q" class="form-label">Search by name or email</label>
                <input type="text" class="form-control" id="q" name="q" placeholder="e.g. jane@example.com">
            </div>
            <div class="col-md-2 d-grid">
                <button type="submit" class="btn btn-outline-primary">Search</button>
            </div>
        </div>
    </form>
</div>

<div class="panel">
    <div class="panel-header">
        <h2 class="h5 mb-0">
            All customers <span id="customerCount" class="text-body-secondary fw-normal"></span>
        </h2>
    </div>

    <!-- Table Container -->
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
                <td colspan="6" class="text-center py-4">Loading data...</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/common/admin-footer.jsp" />

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION
============================================================ -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        loadCustomers();
    });

    function loadCustomers() {
        const query = document.getElementById('q').value;
        const token = localStorage.getItem('accessToken'); // យក JWT Token ពី LocalStorage

        // កំណត់ Endpoint URL (អាចជា /api/users, /api/customers ឬ /api/admin/customers តាមកូដ Backend)
        let url = '${ctx}/api/users';
        if (query) {
            url += '?q=' + encodeURIComponent(query);
        }

        fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token // ផ្ញើ Bearer Token សម្រាប់ Endpoint ដែលត្រូវការ Auth
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to fetch customers');
                }
                return response.json();
            })
            .then(data => {
                // ពិនិត្យ Response (បើ API របស់អ្នកបកមកជា data.data ឬជា Array ផ្ទាល់)
                const customers = Array.isArray(data) ? data : (data.data || []);
                renderCustomerTable(customers);
            })
            .catch(error => {
                console.error('Error fetching customers:', error);
                document.getElementById('customerTableBody').innerHTML = `
            <tr>
                <td colspan="6" class="text-center text-danger py-4">
                    មានបញ្ហាក្នុងការទាញយកទិន្នន័យ ឬពុំមានសិទ្ធិចូលមើល (Unauthorized)។
                </td>
            </tr>`;
            });
    }

    function renderCustomerTable(customers) {
        const tbody = document.getElementById('customerTableBody');
        const countSpan = document.getElementById('customerCount');

        countSpan.textContent = `(${customers.length})`;

        if (customers.length === 0) {
            tbody.innerHTML = `
            <tr>
                <td colspan="6" class="text-center py-4">
                    <i class="bi bi-people fs-3 text-secondary"></i>
                    <p class="mb-0 mt-2">No customers match this search.</p>
                </td>
            </tr>`;
            return;
        }

        let html = '';
        customers.forEach(cust => {
            const isStatusActive = (cust.status === 'ACTIVE');
            const badgeClass = isStatusActive ? 'status-confirmed' : 'status-cancelled';
            const badgeText = isStatusActive ? 'Active' : 'Suspended';

            const actionButton = isStatusActive
                ? `<button onclick="toggleCustomerStatus(${cust.id}, 'suspend')" class="btn btn-sm btn-outline-danger">Suspend</button>`
                : `<button onclick="toggleCustomerStatus(${cust.id}, 'activate')" class="btn btn-sm btn-outline-primary">Re-activate</button>`;

            html += `
            <tr>
                <td class="fw-medium">${cust.fullName || 'N/A'}</td>
                <td>
                    <div class="small">${cust.email || 'N/A'}</div>
                    <div class="small text-body-secondary">${cust.phone || ''}</div>
                </td>
                <td>
                    <a href="${ctx}/admin/reservations?q=${cust.email}" class="small">
                        ${cust.reservationCount || 0} booking(s)
                    </a>
                </td>
                <td>${cust.joinedDate || 'N/A'}</td>
                <td>
                    <span class="badge status-badge ${badgeClass}">${badgeText}</span>
                </td>
                <td class="text-end">
                    ${actionButton}
                </td>
            </tr>`;
        });

        tbody.innerHTML = html;
    }

    // Function សម្រាប់ Suspend / Activate តាម API POST
    function toggleCustomerStatus(customerId, action) {
        if (action === 'suspend' && !confirm('Suspend this account?')) return;

        const token = localStorage.getItem('accessToken');

        fetch('${ctx}/api/users/' + customerId + '/' + action, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (response.ok) {
                    loadCustomers(); // Reload បញ្ជីឡើងវិញពេលផ្លាស់ប្តូរជោគជ័យ
                } else {
                    alert('Operation failed.');
                }
            })
            .catch(err => console.error('Error toggling status:', err));
    }
</script>