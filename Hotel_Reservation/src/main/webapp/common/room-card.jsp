<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  A single room card.
  Parameters: id, name, price, rating (0-5), img (file name inside assets/img), meta (short text)
--%>
<c:url var="detailUrl" value="/rooms">
    <c:param name="id" value="${param.id}" />
</c:url>
<c:url var="imgUrl" value="/assets/img/${param.img}" />

<article class="card room-card h-100 border-0 shadow-sm">
    <a href="${detailUrl}" class="room-thumb">
        <img src="${imgUrl}" alt="<c:out value='${param.name}' />" loading="lazy" onerror="this.remove()">
    </a>
    <div class="card-body">
        <div class="d-flex justify-content-between align-items-start gap-2">
            <h3 class="h5 mb-0">
                <a class="text-reset text-decoration-none" href="${detailUrl}">
                    <c:out value="${param.name}" />
                </a>
            </h3>
            <div class="text-end text-nowrap">
                <span class="fw-semibold">&#36;<c:out value="${param.price}" /></span>
                <span class="small text-body-secondary">/ night</span>
            </div>
        </div>
        <p class="small text-body-secondary mt-1 mb-2"><c:out value="${param.meta}" /></p>
        <div class="text-warning" role="img" aria-label="Rated ${param.rating} out of 5">
            <c:forEach begin="1" end="5" var="i">
                <i class="bi ${i <= param.rating ? 'bi-star-fill' : 'bi-star'}"></i>
            </c:forEach>
        </div>
    </div>
</article>