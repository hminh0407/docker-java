# example 3 - Builder Image
FROM openjdk:8-alpine

WORKDIR src/app
COPY target/docker-java-1.0-SNAPSHOT.jar /src/app/docker-java-1.0-SNAPSHOT.jar

CMD exec java -jar docker-java-1.0-SNAPSHOT.jar

# Run script #
# build docker image  : `docker build -f ex3.Dockerfile -t minh/docker-java:3.0 .`
# run docker container: `docker run --name docker-java -d -p 8080:8080 minh/docker-java:3.0`
# check localhost:8080/greeting
