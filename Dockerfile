# Build stage
FROM maven:3.8.6-openjdk-11 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Runtime stage
FROM open-liberty:full-java11-openj9
USER root
RUN apt-get update && \
    apt-get install -y vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY server.xml /config/
COPY --from=build /app/target/java-ee-app.war /config/dropins/
EXPOSE 9080 9443
CMD ["/opt/ol/wlp/bin/server", "run", "defaultServer"]
