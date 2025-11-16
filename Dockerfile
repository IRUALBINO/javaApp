FROM eclipse-temurin:17-jdk-alpine
COPY target/*-shaded.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
