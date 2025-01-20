# Step 1: Build Stage
FROM maven:3.8.4-openjdk-11-slim AS build

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml . 
RUN mvn dependency:go-offline

# Copy the source code and build the app
COPY src /app/src
RUN mvn package -DskipTests

# Step 2: Runtime Stage
FROM openjdk:11-jre-slim  # Use a lightweight runtime image

WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
