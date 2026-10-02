<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Search rooms" />
</jsp:include>
<jsp:include page="/common/navbar.jsp" />

<main class="flex-grow-1 py-4">
    <div class="container">

        <form action="${ctx}/rooms" method="get" id="searchForm">

            <div class="row g-4">

                <!-- Filters sidebar -->
                <div class="col-lg-3">
                    <div class="panel filter-panel">
                        <div class="panel-header">
                            <h2 class="h6 mb-0">Filters</h2>
                            <a href="${ctx}/rooms" class="small">Reset</a>
                        </div>

                        <div class="p-3">
                            <div class="mb-3">
                                <label for="checkIn" class="form-label small fw-medium">Check-in</label>
                                <input type="date" class="form-control form-control-sm" id="checkIn" name="checkIn"
                                       value="<c:out value='${checkIn}' />">
                            </div>
                            <div class="mb-3">
                                <label for="checkOut" class="form-label small fw-medium">Check-out</label>
                                <input type="date" class="form-control form-control-sm" id="checkOut" name="checkOut"
                                       value="<c:out value='${checkOut}' />">
                            </div>
                            <div class="mb-4">
                                <label for="guests" class="form-label small fw-medium">Guests</label>
                                <select class="form-select form-select-sm" id="guests" name="guests">
                                    <c:forEach begin="1" end="6" var="g">
                                        <option value="${g}" ${guests == g ? 'selected' : ''}>${g} guest<c:if test="${g > 1}">s</c:if></option>
                                    </c:forEach>
                                </select>
                            </div>

                            <hr>

                            <div class="mb-4">
                                <div class="form-label small fw-medium mb-2">Room type</div>

                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typePool" name="type" value="POOL_VIEW"
                                    ${fn:contains(selectedTypes, 'POOL_VIEW') ? 'checked' : ''}>
                                    <label class="form-check-label" for="typePool">Pool view</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeCity" name="type" value="CITY_VIEW"
                                    ${fn:contains(selectedTypes, 'CITY_VIEW') ? 'checked' : ''}>
                                    <label class="form-check-label" for="typeCity">City view</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="typeFamily" name="type" value="FAMILY_SUITE"
                                    ${fn:contains(selectedTypes, 'FAMILY_SUITE') ? 'checked' : ''}>
                                    <label class="form-check-label" for="typeFamily">Family suite</label>
                                </div>
                            </div>

                            <hr>

                            <div class="mb-4">
                                <div class="form-label small fw-medium mb-2">Price per night</div>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <div class="input-group input-group-sm">
                                            <span class="input-group-text">$</span>
                                            <input type="number" min="0" step="5" class="form-control" name="minPrice"
                                                   placeholder="Min" value="<c:out value='${minPrice}' />">
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="input-group input-group-sm">
                                            <span class="input-group-text">$</span>
                                            <input type="number" min="0" step="5" class="form-control" name="maxPrice"
                                                   placeholder="Max" value="<c:out value='${maxPrice}' />">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-sm">
                                    <i class="bi bi-funnel me-1"></i>Apply filters
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Results -->
                <div class="col-lg-9">

                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                        <div class="text-body-secondary">
                            <c:choose>
                                <c:when test="${empty rooms}">No rooms found</c:when>
                                <c:otherwise>
                                    <c:out value="${resultCount}" /> room(s) found
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="d-flex align-items-center gap-2">
                            <label for="sort" class="small text-body-secondary mb-0">Sort by</label>
                            <select class="form-select form-select-sm" id="sort" name="sort" style="width: auto"
                                    onchange="document.getElementById('searchForm').submit()">
                                <option value="recommended" ${sort == 'recommended' ? 'selected' : ''}>Recommended</option>
                                <option value="price_asc"    ${sort == 'price_asc'    ? 'selected' : ''}>Price: low to high</option>
                                <option value="price_desc"   ${sort == 'price_desc'   ? 'selected' : ''}>Price: high to low</option>
                                <option value="rating_desc"  ${sort == 'rating_desc'  ? 'selected' : ''}>Highest rated</option>
                            </select>
                        </div>
                    </div>

                    <!-- RESULTS LIST -->
                    <c:choose>
                        <c:when test="${empty rooms}">
                            <div class="panel">
                                <div class="panel-empty py-5 text-center">
                                    <i class="bi bi-search fs-1"></i>
                                    <p class="mb-0 mt-2">No rooms match these filters. Try widening your dates or price range.</p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="row g-4">
                                <c:forEach var="room" items="${rooms}">
                                    <div class="col-md-6 col-xl-4 d-flex flex-column">
                                        <div class="flex-grow-1">
                                            <jsp:include page="/common/room-card.jsp">
                                                <jsp:param name="id" value="${room.id}" />
                                                <jsp:param name="name" value="${room.name}" />
                                                <jsp:param name="price" value="${room.price}" />
                                                <jsp:param name="rating" value="${room.rating}" />
                                                <jsp:param name="img" value="${room.image}" />
                                                <jsp:param name="meta" value="${room.guestCapacity} guests,${room.typeLabel}" />
                                            </jsp:include>
                                        </div>
                                        <!-- Action Button for Booking -->
                                        <div class="mt-2">
                                            <button type="button" class="btn btn-success btn-sm w-100" onclick="bookRoom('${room.id}')">
                                                <i class="bi bi-calendar-check me-1"></i>Book Now
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- PAGINATION -->
                            <c:if test="${totalPages > 1}">
                                <nav class="d-flex justify-content-center py-4" aria-label="Room results pages">
                                    <ul class="pagination mb-0">
                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                <a class="page-link"
                                                   href="${ctx}/rooms?page=${p}&checkIn=${checkIn}&checkOut=${checkOut}&guests=${guests}&minPrice=${minPrice}&maxPrice=${maxPrice}&sort=${sort}">
                                                    <c:out value="${p}" />
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>

        </form>
    </div>
</main>

<jsp:include page="/common/footer.jsp" />

<!-- JavaScript Section -->
<script>
    async function bookRoom(roomId) {
        const token = localStorage.getItem('token');

        // 1. Check user authentication
        if (!token) {
            alert('សូមធ្វើការចូលប្រើប្រាស់ (Login) ជាមុនសិន!');
            window.location.href = '${ctx}/login.jsp';
            return;
        }

        // 2. Extract values dynamically from the search form
        const checkInInput = document.getElementById('checkIn');
        const checkOutInput = document.getElementById('checkOut');
        const guestsInput = document.getElementById('guests');

        const checkIn = checkInInput ? checkInInput.value : '';
        const checkOut = checkOutInput ? checkOutInput.value : '';
        const guests = guestsInput ? parseInt(guestsInput.value) : 1;

        // 3. Validation check
        if (!checkIn || !checkOut) {
            alert('សូមជ្រើសរើសថ្ងៃ Check-in និង Check-out ឱ្យបានត្រឹមត្រូវ!');
            return;
        }

        const reservationData = {
            roomId: roomId,
            checkIn: checkIn,
            checkOut: checkOut,
            guests: guests
        };

        try {
            const response = await fetch('${ctx}/api/reservations', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`
                },
                body: JSON.stringify(reservationData)
            });

            if (response.ok) {
                const result = await response.json();
                alert('ការកក់បន្ទប់ទទួលបានជោគជ័យ!');
                window.location.href = '${ctx}/Customer/reservation-History.jsp';
            } else {
                const errorData = await response.json().catch(() => ({}));
                alert(errorData.message || 'ការកក់មិនជោគជ័យទេ សូមពិនិត្យមើលឡើងវិញ!');
            }
        } catch (error) {
            console.error('Booking Error:', error);
            alert('មានបញ្ហាក្នុងការតភ្ជាប់ទៅកាន់ Server!');
        }
    }
</script>