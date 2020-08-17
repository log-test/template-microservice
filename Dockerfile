# Maven build container

FROM maven:3.5.2-jdk-8-alpine AS maven_build

COPY pom.xml /tmp/

COPY src /tmp/src/

WORKDIR /tmp/

RUN mvn package

#pull base image

FROM openjdk:8-jdk-alpine

#expose port 9080
EXPOSE 9080

#copy hello world to docker image from builder image

COPY --from=maven_build /tmp/target/template-microservice.jar /data/template-microservice.jar

#default command
CMD java -jar /data/template-microservice.jar

