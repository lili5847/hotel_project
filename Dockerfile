
# Run the already-built Spring Boot WAR
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY target/HotelReservationSystem.war app.war

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.war"]

