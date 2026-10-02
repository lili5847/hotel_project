# ជំហានទី ១: Build JAR file (មាន Cache សម្រាប់ Maven Dependencies)
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# ចម្លងតែ pom.xml មកមុន ដើម្បីទាញយក Dependencies រក្សាទុកក្នុង Docker Cache
COPY pom.xml .
RUN mvn dependency:go-offline -B

# ចម្លង Source code តាមក្រោយ រួចធ្វើការ Build
COPY src ./src
RUN mvn clean package -DskipTests -B

# ជំហានទី ២: Run Application ជាមួយ Java 21 JRE Runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/HotelReservationSystem.war app.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]