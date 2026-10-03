<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  A single room card component with dynamic Spring Boot API integration support.
  Parameters: id, name, price, rating (0-5), img (file name inside assets/img), meta (short text)
--%>
<c:url var="detailUrl" value="/rooms">
    <c:param name="id" value="${param.id}" />
</c:url>
<c:url var="imgUrl" value="/assets/img/${param.img}" />

<article class="card room-card h-100 border-0 shadow-sm" id="room-card-${param.id}">
    <a href="${detailUrl}" class="room-thumb">
        <img id="room-img-${param.id}" src="${imgUrl}" alt="<c:out value='${param.name}' />" loading="lazy" onerror="this.remove()">
    </a>
    <div class="card-body">
        <div class="d-flex justify-content-between align-items-start gap-2">
            <h3 class="h5 mb-0">
                <a class="text-reset text-decoration-none" id="room-title-${param.id}" href="${detailUrl}">
                    <c:out value="${param.name}" />
                </a>
            </h3>
            <div class="text-end text-nowrap">
                <span class="fw-semibold">&#36;<span id="room-price-${param.id}"><c:out value="${param.price}" /></span></span>
                <span class="small text-body-secondary">/ night</span>
            </div>
        </div>
        <p class="small text-body-secondary mt-1 mb-2" id="room-meta-${param.id}"><c:out value="${param.meta}" /></p>

        <div class="d-flex justify-content-between align-items-center mt-2">
            <div class="text-warning" id="room-rating-${param.id}" role="img" aria-label="Rated ${param.rating} out of 5">
                <c:forEach begin="1" end="5" var="i">
                    <i class="bi ${i <= param.rating ? 'bi-star-fill' : 'bi-star'}"></i>
                </c:forEach>
            </div>

            <button class="btn btn-sm btn-primary" onclick="bookRoomDirect('${param.id}')">
                Book Now
            </button>
        </div>
    </div>
</article>

<!-- ============================================================
JAVASCRIPT FETCH API INTEGRATION FOR SPRING BOOT BACKEND
============================================================ -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const roomId = "${param.id}";
        if (roomId) {
            fetchRoomDetailsFromSpringBoot(roomId);
        }
    });

    function fetchRoomDetailsFromSpringBoot(roomId) {
        const ctxPath = "${pageContext.request.contextPath}";
        const token = localStorage.getItem('token') || localStorage.getItem('accessToken');

        const headers = {
            'Content-Type': 'application/json'
        };
        if (token) {
            headers['Authorization'] = 'Bearer ' + token;
        }

        // Fetch live room status/data from Spring Boot REST API
        fetch(`${ctxPath}/api/rooms/${roomId}`, {
            method: 'GET',
            headers: headers
        })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Could not fetch room details from Spring Boot API');
            })
            .then(room => {
                if (room) {
                    // Dynamically update card fields if new data exists
                    if (room.name) {
                        document.getElementById(`room-title-${roomId}`).textContent = room.name;
                    }
                    if (room.price) {
                        document.getElementById(`room-price-${roomId}`).textContent = room.price;
                    }
                    if (room.meta) {
                        document.getElementById(`room-meta-${roomId}`).textContent = room.meta;
                    }
                }
            })
            .catch(error => {
                console.warn(`Spring Boot API update skipped for room ID ${roomId}:`, error);
            });
    }

    function bookRoomDirect(roomId) {
        const ctxPath = "${pageContext.request.contextPath}";
        const token = localStorage.getItem('token') || localStorage.getItem('accessToken');

        if (!token) {
            // Redirect to login page if user is unauthenticated
            window.location.href = `${ctxPath}/Customer/login.jsp`;
            return;
        }

        // Example POST request to Spring Boot Reservation API
        fetch(`${ctxPath}/api/reservations/check-availability/${roomId}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.available) {
                    window.location.href = `${ctxPath}/rooms?id=${roomId}`;
                } else {
                    alert('This room is currently unavailable.');
                }
            })
            .catch(error => {
                console.error('Error checking room availability:', error);
                window.location.href = `${ctxPath}/rooms?id=${roomId}`;
            });
    }
</script>