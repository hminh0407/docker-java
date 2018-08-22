# example 1 - All in 1 Dockerfile
FROM maven:3.5-jdk-8-alpine

WORKDIR /src/app

# Prepare by downloading dependencies
# Do note that the order of the execution is very important (because of docker caching for build)
# In general docker only rebuild what is changed, therefore things that are not likely to change should be put in higher order
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
# This build has a serious weakness that it put all source code and dependencies in the final image. A huge size image has a lot of disadvantage
# * network latency - need to transfer Docker image over the web
# * storage - need to store all these bits somewhere
# * service availability and elasticity - when using a Docker scheduler, like Kubernetes, Swarm, DC/OS or other (scheduler can move containers between hosts)
# * security - do you really, I mean really need the libpng package with all its CVE vulnerabilities for your Java application?
# * development agility - small Docker images == faster build time and faster deployment
# Though you are not able to see the actual different with a simple example.
# This could be very bad for application that have lots of dependencies.

# Run script #
# build docker image  : `docker build -f ex1.Dockerfile -t minh/docker-java:1.0 .`
# run docker container: `docker run --name docker-java -d -p 8080:8080 minh/docker-java:1.0`
# check localhost:8080/greeting
