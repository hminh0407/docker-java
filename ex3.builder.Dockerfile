# example 3 - builder image
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
# build docker image : `docker build -f ex3.builder.Dockerfile -t minh/docker-java-builder:1.0 .`
# build jar file     : `docker run -it --rm -v $PWD/target:/src/app/target minh/docker-java-builder:1.0 package -T 1C -o -Dmaven.test.skip=true`:
# then build and run the app container

# Build command breakdown #
# docker run -it                                     (interactive run, show log on command)
#            --rm                                    (container will be removed after launch)
#            -v "$PWD"/target:src/app/target         (mount current host dir with the build dir)
#            minh/docker-java-builder:1.0            (image)
#            package -T 1C -o -Dmaven.test.skip=true (mvn build command)

# Note #
# This build has an advantage that it store all the dependencies and source code but still separating the build materials with the running container
# Still note that whenever the pom.xml file changed and build new image, all of dependencies will be re-downloaded
# We can use this build image for further mvn tasks like
# * mvn test
# * mvn package

# Persistent mvn cache #
# In order not to re-download everything each time pom.xml file changed, we need a persistent storage for mvn cache
# There are 2 options to re-use mvn cache and prevent dependencies re-downloaded on every build
# To know the different between them, check https://docs.docker.com/storage/volumes/
# 1. Bind mounts (mount container's mvn repo with a host folder)
#    * -v "$HOME"/.m2:root/.m2 (can re-use local mvn repo)
#    * -v "$PWD"/.m2:root/.m2  (or use any specific folder)
# 2. Named Volume (named volume will not be deleted when delete a container and can be shared between containers)
#    * -v mvn-cache:root/.m2 (a new volume with name 'mvn-cache' is created and mount with container's dir)

