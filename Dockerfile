# Use OpenJDK base image
FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Copy the JAR file from Maven target folder
COPY target/java-task-1.0-SNAPSHOT.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
