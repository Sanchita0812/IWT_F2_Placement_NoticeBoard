# Step 1: Build the application
FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# Step 2: Run the application
FROM openjdk:17-slim
WORKDIR /app

# Copy the WAR file and the webapp-runner from the build stage
COPY --from=build /app/target/iwt.war /app/iwt.war
COPY --from=build /app/target/dependency/webapp-runner.jar /app/webapp-runner.jar

# Render provides a $PORT environment variable
EXPOSE 8080

# Use shell form to allow environment variable expansion for $PORT
CMD java -jar /app/webapp-runner.jar --port ${PORT:-8080} /app/iwt.war
