# example 2
FROM maven:3.5-jdk-8-alpine as builder

WORKDIR /code

# Prepare by downloading dependencies
ADD pom.xml /code/pom.xml

# This will download most* of the dependencies required for the build
# and cache them for as long as the pom.xml doesn’t change
RUN ["mvn", "dependency:go-offline"]

# Adding source, compile and package into a fat jar
ADD src /code/src
RUN ["mvn", "package"]

FROM openjdk:8-alpine

WORKDIR /app
COPY --from=builder /code/target/docker-java-1.0-SNAPSHOT.jar /app/docker-java-1.0-SNAPSHOT.jar

CMD exec java -jar spring-tutorial-1.0-SNAPSHOT.jar

# Note #
# This build reduce the size of the final image by containing only what need to be executed (the jar file)
# But still it has one weakness that whenever pom.xml files change, the whole dependencies will be re-downloaded
