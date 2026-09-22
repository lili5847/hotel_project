<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Home" />
</jsp:include>
<jsp:include page="/common/navbar.jsp" />

<main class="flex-grow-1">

    <!-- Hero -->
    <section class="hero text-center">
        <div class="container">
            <c:if test="${not empty sessionScope.user}">
                <p class="mb-2">Welcome back, <c:out value="${sessionScope.user.fullName}" />.</p>
            </c:if>
            <h1 class="mb-3">Browse rooms and suites with ease</h1>
            <p class="lead mb-4">Pick your dates, compare room types, and confirm your stay online.</p>
            <a href="${ctx}/rooms" class="btn btn-outline-light rounded-pill px-4">Explore rooms</a>
        </div>
    </section>

    <!-- Search bar overlapping the hero -->
    <section class="container search-panel">
        <form class="bg-white rounded-4 shadow p-3 p-md-4" action="${ctx}/rooms" method="get">
            <div class="row g-3 align-items-end">
                <div class="col-6 col-lg">
                    <label for="checkIn" class="form-label"><i class="bi bi-calendar-event me-1"></i>Check-in</label>
                    <input type="date" class="form-control" id="checkIn" name="checkIn" required>
                </div>
                <div class="col-6 col-lg">
                    <label for="checkOut" class="form-label"><i class="bi bi-calendar-check me-1"></i>Check-out</label>
                    <input type="date" class="form-control" id="checkOut" name="checkOut" required>
                </div>
                <div class="col-6 col-lg">
                    <label for="guests" class="form-label"><i class="bi bi-people me-1"></i>Guests</label>
                    <select class="form-select" id="guests" name="guests">
                        <option value="1">1 guest</option>
                        <option value="2" selected>2 guests</option>
                        <option value="3">3 guests</option>
                        <option value="4">4 guests</option>
                        <option value="5">5 guests</option>
                        <option value="6">6 guests</option>
                    </select>
                </div>
                <div class="col-6 col-lg">
                    <label for="roomType" class="form-label"><i class="bi bi-door-open me-1"></i>Room type</label>
                    <%-- TODO: fill these options from RoomTypeDAO --%>
                    <select class="form-select" id="roomType" name="roomType">
                        <option value="">Any type</option>
                        <option value="1">Pool View</option>
                        <option value="2">City View</option>
                        <option value="3">Family Suite</option>
                    </select>
                </div>
                <div class="col-12 col-lg-auto d-grid">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-search me-1"></i>Search
                    </button>
                </div>
            </div>
        </form>
    </section>

    <!-- Feature strip -->
    <section class="container mt-4">
        <div class="bg-white rounded-4 shadow-sm p-3 p-md-4">
            <div class="row g-3">
                <div class="col-6 col-lg-3 d-flex align-items-center gap-3">
                    <span class="feature-icon"><i class="bi bi-lightning-charge"></i></span>
                    <div>
                        <div class="fw-semibold">Instant confirmation</div>
                        <div class="small text-body-secondary">Know your booking status right away</div>
                    </div>
                </div>
                <div class="col-6 col-lg-3 d-flex align-items-center gap-3">
                    <span class="feature-icon"><i class="bi bi-calendar2-week"></i></span>
                    <div>
                        <div class="fw-semibold">Flexible dates</div>
                        <div class="small text-body-secondary">Stay for one night or many</div>
                    </div>
                </div>
                <div class="col-6 col-lg-3 d-flex align-items-center gap-3">
                    <span class="feature-icon"><i class="bi bi-shield-check"></i></span>
                    <div>
                        <div class="fw-semibold">Secure accounts</div>
                        <div class="small text-body-secondary">Your details stay protected</div>
                    </div>
                </div>
                <div class="col-6 col-lg-3 d-flex align-items-center gap-3">
                    <span class="feature-icon"><i class="bi bi-headset"></i></span>
                    <div>
                        <div class="fw-semibold">Front desk support</div>
                        <div class="small text-body-secondary">Help before and during your stay</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured rooms -->
    <section class="container pt-5 pb-3">
        <h2 class="text-center mb-4">Featured rooms</h2>
        <div class="row g-4">
            <div class="col-md-6 col-lg-4">
                <jsp:include page="/common/room-card.jsp">
                    <jsp:param name="id" value="1" />
                    <jsp:param name="name" value="Deluxe King Room" />
                    <jsp:param name="price" value="65" />
                    <jsp:param name="rating" value="4" />
                    <jsp:param name="img" value="room-1.jpg" />
                    <jsp:param name="meta" value="2 guests, 1 king bed, city view" />
                </jsp:include>
            </div>
            <div class="col-md-6 col-lg-4">
                <jsp:include page="/common/room-card.jsp">
                    <jsp:param name="id" value="2" />
                    <jsp:param name="name" value="Garden View Twin" />
                    <jsp:param name="price" value="55" />
                    <jsp:param name="rating" value="4" />
                    <jsp:param name="img" value="room-2.jpg" />
                    <jsp:param name="meta" value="2 guests, 2 single beds, garden view" />
                </jsp:include>
            </div>
            <div class="col-md-6 col-lg-4">
                <jsp:include page="/common/room-card.jsp">
                    <jsp:param name="id" value="3" />
                    <jsp:param name="name" value="Executive Suite" />
                    <jsp:param name="price" value="120" />
                    <jsp:param name="rating" value="5" />
                    <jsp:param name="img" value="room-3.jpg" />
                    <jsp:param name="meta" value="3 guests, 1 king bed, lounge area" />
                </jsp:include>
            </div>
        </div>
    </section>

    <!-- Popular room types -->
    <section class="container py-5">
        <h2 class="text-center mb-4">Popular for families and groups</h2>
        <div class="row g-4">
            <div class="col-md-6 col-lg-4">
                <jsp:include page="/common/room-card.jsp">
                    <jsp:param name="id" value="4" />
                    <jsp:param name="name" value="Family Suite" />
                    <jsp:param name="price" value="95" />
                    <jsp:param name="rating" value="5" />
                    <jsp:param name="img" value="room-4.jpg" />
                    <jsp:param name="meta" value="4 guests, 2 queen beds, living room" />
                </jsp:include>
            </div>
            <div class="col-md-6 col-lg-4">
                <jsp:include page="/common/room-card.jsp">
                    <jsp:param name="id" value="5" />
                    <jsp:param name="name" value="Standard Double" />
                    <jsp:param name="price" value="40" />
                    <jsp:param name="rating" value="3" />
                    <jsp:param name="img" value="room-5.jpg" />
                    <jsp:param name="meta" value="2 guests, 1 double bed" />
                </jsp:include>
            </div>
            <div class="col-md-6 col-lg-4">
                <jsp:include page="/common/room-card.jsp">
                    <jsp:param name="id" value="6" />
                    <jsp:param name="name" value="Riverside Studio" />
                    <jsp:param name="price" value="75" />
                    <jsp:param name="rating" value="4" />
                    <jsp:param name="img" value="room-6.jpg" />
                    <jsp:param name="meta" value="2 guests, 1 queen bed, kitchenette" />
                </jsp:include>
            </div>
        </div>
    </section>

    <!-- Prompt for guests who are not logged in -->
    <c:if test="${empty sessionScope.user}">
        <section class="bg-white border-top py-5">
            <div class="container">
                <div class="row align-items-center gy-3">
                    <div class="col-md-8">
                        <h2 class="h4 mb-1">You need an account to book</h2>
                        <p class="text-body-secondary mb-0">
                            You can search rooms without one. Create an account when you're ready to reserve.
                        </p>
                    </div>
                    <div class="col-md-4 text-md-end">
                        <a href="${ctx}/Customer/register.jsp" class="btn btn-primary me-2">Create account</a>
                        <a href="${ctx}/Customer/login.jsp" class="btn btn-outline-primary">Log in</a>
                    </div>
                </div>
            </div>
        </section>
    </c:if>

</main>

<script>
    // Block past dates and keep check-out after check-in
    (function () {
        var checkIn = document.getElementById('checkIn');
        var checkOut = document.getElementById('checkOut');

        function iso(d) {
            var m = String(d.getMonth() + 1).padStart(2, '0');
            var day = String(d.getDate()).padStart(2, '0');
            return d.getFullYear() + '-' + m + '-' + day;
        }

        var today = new Date();
        var tomorrow = new Date();
        tomorrow.setDate(today.getDate() + 1);

        checkIn.min = iso(today);
        checkOut.min = iso(tomorrow);

        checkIn.addEventListener('change', function () {
            if (!checkIn.value) return;
            var next = new Date(checkIn.value);
            next.setDate(next.getDate() + 1);
            checkOut.min = iso(next);
            if (checkOut.value && checkOut.value <= checkIn.value) {
                checkOut.value = iso(next);
            }
        });
    })();
</script>

<jsp:include page="/common/footer.jsp" />