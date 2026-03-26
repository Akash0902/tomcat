# -------------------------------
# Stage 1: Build (optional)
# Use only if you want Docker to build the JAR
# -------------------------------
# FROM maven:3.9.6-eclipse-temurin-17 AS build
# WORKDIR /build
# COPY pom.xml .
# COPY src ./src
# RUN mvn -B -ntp clean package -DskipTests

# -------------------------------
# Stage 2: Runtime (recommended)
# -------------------------------
FROM eclipse-temurin:17-jre-jammy

# Security: non-root user
RUN useradd -r -u 1001 appuser

WORKDIR /app

# Copy the JAR built by GitHub Actions
# If your artifact name changes, update this line
COPY target/tomcat-1.0.0.jar app.jar

# File ownership
RUN chown -R appuser:appuser /app

USER appuser

# JVM best practices
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75"

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
