FROM gradle:7.2.0-jdk17 AS builder
WORKDIR /home/app

COPY . .

RUN gradle buildLayers

FROM eclipse-temurin:17-jre

COPY --from=builder /home/app/build/docker/main/layers/libs /home/app/libs
COPY --from=builder /home/app/build/docker/main/layers/classes /home/app/classes
COPY --from=builder /home/app/build/docker/main/layers/resources /home/app/resources
COPY --from=builder /home/app/build/docker/main/layers/application.jar /home/app/application.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/home/app/application.jar"]
