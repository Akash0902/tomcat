# -------------------------------
# Runtime Stage (lightweight)
# -------------------------------
FROM eclipse-temurin:17-jre-jammy

# Create non-root user (security best practice)
RUN useradd -r -u 1001 appuser

# Set working directory
WORKDIR /app

# Copy the JAR built by CI (flexible for version changes)
COPY target/*.jar app.jar

# Set proper ownership
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 8080

# Run application (proper signal handling)
ENTRYPOINT ["java"]
CMD ["-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75", "-jar", "app.jar"]
