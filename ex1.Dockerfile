# example 1
FROM maven:3.5-jdk-8-alpine

WORKDIR /src/app

# Prepare by downloading dependencies
ADD pom.xml /src/app/pom.xml

# This will download most* of the dependencies required for the build
# and cache them for as long as the pom.xml doesn’t change
RUN ["mvn", "dependency:go-offline"]

# Adding source, compile and package into a fat jar
ADD src /src/app/src
RUN ["mvn", "package"]

CMD exec java -jar target/docker-java-1.0-SNAPSHOT.jar

# CMD ["/usr/lib/jvm/java-1.8-openjdk/bin/java", "-jar", "docker-java-1.0-SNAPSHOT.jar"]
# I don't know why but running in exec form end up with below error on my machine. (didn't happen before)
# Error loading shared library libjli.so: No such file or directory (needed by /usr/lib/jvm/java-1.8-openjdk/bin/java)
# Error relocating /usr/lib/jvm/java-1.8-openjdk/bin/java: JLI_Launch: symbol not found

# Note #
# This build has a weakness that it put all src code and dependencies in the final image.
# This could be very bad for application that have lots of dependencies.

# Run script #
# build docker image  : `docker build -t minh/docker-java:1.0 .`
# run docker container: `docker run --name spring-example -d -p 8080:8080 minh/docker-java:1.0`: