FROM openjdk:21-slim AS build

RUN apt-get update && \
   apt-get install -y maven && \
   rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean install -DskipTests -Dpmd.skip=true


# Use OpenJDK 21 for the runtime stage

FROM openjdk:21-slim

WORKDIR /app

COPY --from=build /app/target/bankingportal-0.0.1-SNAPSHOT.jar .

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/bankingportal-0.0.1-SNAPSHOT.jar"]
