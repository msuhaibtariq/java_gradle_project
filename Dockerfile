# Step 1: Build Stage
FROM maven:3.8.4-openjdk-11-slim AS build

WORKDIR /app
COPY pom.xml . 
RUN mvn dependency:go-offline  # Download dependencies
COPY src /app/src
RUN mvn package -DskipTests  # Build the app (create JAR)

# Step 2: Runtime Stage
FROM openjdk:11-jre-slim  # Use a lighter base image for runtime

WORKDIR /app
# Copy the JAR file from the previous build stage
COPY --from=build /app/target/simple-java-project-1.0-SNAPSHOT.jar app.jar

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]

