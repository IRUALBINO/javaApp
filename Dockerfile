FROM eclipse-temurin:17-jdk-alpine
COPY target/java-task-1.0-SNAPSHOT-shaded.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
