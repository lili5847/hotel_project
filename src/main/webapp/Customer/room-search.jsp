<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Search rooms" />
</jsp:include>
<jsp:include page="/common/navbar.jsp" />

<main class="flex-grow-1 py-4">
<div class="container">

    <%-- ============================================================
         BACKEND 1: SEARCH / FILTER FORM
         GET /rooms  ->  RoomSearchServlet.doGet()
         Params sent: checkIn, checkOut, guests, type (0-3 values,
         name="type" repeated), minPrice, maxPrice, sort
         "type" values below are the three room types this project
         uses: POOL_VIEW, CITY_VIEW, FAMILY_SUITE. If your RoomType
         table uses different codes or numeric IDs, change the
         value="" attributes on the three checkboxes to match, and
         update the c:forEach "checked" comparisons the same way.
         The servlet should:
           1. read all params (everything is optional except none
              are required — an empty search just returns all rooms)
           2. call RoomDAO.search(checkIn, checkOut, guests, types,
              minPrice, maxPrice, sort, page, pageSize)
           3. set request attributes: rooms, resultCount, currentPage,
              totalPages, and echo back the submitted filters (checkIn,
              checkOut, guests, selectedTypes, minPrice, maxPrice, sort)
              so the form stays filled in after submit
         ============================================================ --%>
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

                    <%-- Only 3 room types in this project. Bed count, view details,
                         amenities etc. are NOT filtered here — those live on the
                         room-details page for the user to choose once they open a room. --%>
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
                <%-- BACKEND: "resultCount" = total matching rows (for the label below,
                     independent of how many are shown on this page) --%>
                <div class="text-body-secondary">
                    <c:choose>
                        <c:when test="${empty rooms}">No rooms found</c:when>
                        <c:otherwise><c:out value="${resultCount}" /> room(s) found</c:otherwise>
                    </c:choose>
                </div>

                <%-- BACKEND: "sort" param, read by RoomSearchServlet, e.g.
                     "price_asc" -> ORDER BY price ASC, "price_desc" -> ORDER BY price DESC,
                     "rating_desc" -> ORDER BY rating DESC. Submits the same form on change. --%>
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

            <%-- ============================================================
                 BACKEND 2: RESULTS LIST
                 request attribute "rooms": a List where each item exposes
                   getId(), getName(), getTypeLabel() ("Pool view" / "City
                   view" / "Family suite"), getPrice(), getRating() (0-5),
                   getImage() (file name under assets/img), getGuestCapacity()
                 Suggested source: RoomDAO.search(...) described above.
                 Reuses the same room-card.jsp used on the home page.
                 ============================================================ --%>
            <c:choose>
                <c:when test="${empty rooms}">
                    <div class="panel">
                        <div class="panel-empty py-5">
                            <i class="bi bi-search"></i>
                            <p class="mb-0">No rooms match these filters. Try widening your dates or price range.</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <c:forEach var="room" items="${rooms}">
                            <div class="col-md-6 col-xl-4">
                                <jsp:include page="/common/room-card.jsp">
                                    <jsp:param name="id" value="${room.id}" />
                                    <jsp:param name="name" value="${room.name}" />
                                    <jsp:param name="price" value="${room.price}" />
                                    <jsp:param name="rating" value="${room.rating}" />
                                    <jsp:param name="img" value="${room.image}" />
                                    <jsp:param name="meta" value="${room.guestCapacity} guests, ${room.typeLabel}" />
                                </jsp:include>
                            </div>
                        </c:forEach>
                    </div>

                    <%-- ============================================================
                         BACKEND 3: PAGINATION
                         request attributes: currentPage (1-based), totalPages.
                         Keeps every filter in the link so paging doesn't reset them.
                         ============================================================ --%>
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