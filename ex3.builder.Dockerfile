# example 3 - Builder Image
FROM maven:3.5-jdk-8-alpine

WORKDIR /src/app

# Prepare by downloading dependencies
ADD pom.xml /src/app/pom.xml

# This will download most of the dependencies required for the build
# and cache them for as long as the pom.xml doesn’t change
RUN ["mvn", "dependency:go-offline"]

# Adding source
ADD src /src/app/src

ENTRYPOINT ["/usr/bin/mvn"]

# Run script #
# build docker image : `docker build -f ex3.builder.Dockerfile -t minh/docker-java-builder:3.0 .`
# build jar file     : `docker run -it --rm -v $PWD/target:/src/app/target minh/docker-java-builder:3.0 package -Dmaven.test.skip=true`
# then check ex3.Dockerfile to build and run app container.

# Build command breakdown #
# docker run -it                                  (interactive run, show log on command)
#            --rm                                 (container will be removed after launch)
#            -v "$PWD"/target:src/app/target      (mount current host dir with the build dir)
#            minh/docker-java-builder:3.0         (image)
#            package -Dmaven.test.skip=true (mvn build command)

# Another way to run app container without Dockerfile #
# run app container: `docker run --name docker-java -d -p 8080:8080 -v $(pwd)/target:/src/app -w /src/app openjdk:8-alpine /bin/sh -c 'java -jar docker-java-1.0-SNAPSHOT.jar'`:
# docker run --name docker-java                                   (container name)
#             -d                                                  (detach mode)
#             -p 8080:8080                                        (open port)
#             -v $(pwd)/target:/src/app                           (mount with host folder)
#             -w /src/app                                         (workdir)
#             openjdk:8-alpine                                    (image)
#             /bin/sh -c 'java -jar docker-java-1.0-SNAPSHOT.jar' (has to run with a bash process or else java library won't load as expected)

# Note #
# This build has an advantage that it store all the dependencies and source code but still separating the build materials with the running container
# Still note that whenever the pom.xml file changed and build new image, all of dependencies will be re-downloaded
# We can use this build image for further mvn tasks like
# * mvn test
# * mvn package

