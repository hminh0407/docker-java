# example 2 - Multistage Build
FROM maven:3.5-jdk-8-alpine as builder

WORKDIR /src/app

# Prepare by downloading dependencies
ADD pom.xml /src/app/pom.xml

# This will download most of the dependencies required for the build
# and cache them for as long as the pom.xml doesn’t change
RUN ["mvn", "dependency:go-offline"]

# Adding source, compile and package into a fat jar
ADD src /src/app/src
RUN ["mvn", "package"]

FROM openjdk:8-alpine

WORKDIR src/app
COPY --from=builder /src/app/target/docker-java-1.0-SNAPSHOT.jar /src/app/docker-java-1.0-SNAPSHOT.jar

CMD exec java -jar docker-java-1.0-SNAPSHOT.jar

# Note #
# This build reduce the size of the final image by containing only what need to be executed (the jar file)
# But still it has one weakness that whenever pom.xml files change, the whole dependencies will be re-downloaded

# Run script #
# build docker image  : `docker build -f ex2.Dockerfile -t minh/docker-java:2.0 .`
# run docker container: `docker run --name docker-java -d -p 8080:8080 minh/docker-java:2.0`
# check localhost:8080/greeting

