# example 4 - Persistent Cache

# In order not to re-download everything each time pom.xml file changed, we need a persistent storage for mvn cache
# There are 2 options to re-use mvn cache and prevent dependencies re-downloaded on every build
# 1. Bind Mounts (https://docs.docker.com/storage/bind-mounts)
#    * -v "$HOME"/.m2:root/.m2 (can re-use local mvn repo)
#    * -v "$PWD"/.m2:root/.m2  (or use any specific folder)
# 2. Named Volume (https://docs.docker.com/storage/volumes/)
#    * -v mvn-cache:root/.m2 (a new volume with name 'mvn-cache' is created and mount with container's dir)

FROM maven:3.5-jdk-8-alpine

WORKDIR /src/app

# Prepare by downloading dependencies
ADD pom.xml /src/app/pom.xml

# Note that we have dismissed the step to download dependencies at build time from previous example

# Adding source
ADD src /src/app/src

ENTRYPOINT ["/usr/bin/mvn"]

### 1. Bind Mounts ###
# We can re-use the maven host repo or specify a directory
#    * -v "$HOME"/.m2:root/.m2 (can re-use local mvn repo)
#    * -v "$PWD"/.m2:root/.m2  (or use any specific folder)

# Run script #
# build docker image : `docker build -f ex4.builder.Dockerfile -t minh/docker-java-builder:4.0 .`
# build jar file     : `docker run -it --rm -v $PWD/target:/src/app/target -v "$HOME"/.m2:/root/.m2 minh/docker-java-builder:4.0 package -Dmaven.test.skip=true`
# run app container  : `docker run --name docker-java -d -p 8080:8080 -v $(pwd)/target:/src/app -w /src/app openjdk:8-alpine /bin/sh -c 'java -jar docker-java-1.0-SNAPSHOT.jar'`

# Build command breakdown #
# docker run -it                             (interactive run, show log on command)
#            --rm                            (container will be removed after launch)
#            -v "$PWD"/target:src/app/target (mount current host dir with the build dir)
#            -v "$HOME"/.m2:root/.m2         (mount host with container mvn folder, local dependencies can be re-used)
#            minh/docker-java-builder:4.0    (image)
#            package -Dmaven.test.skip=true  (mvn build command)
# Run command breakdown #
# docker run --name docker-java                                   (container name)
#             -d                                                  (detach mode)
#             -p 8080:8080                                        (open port)
#             -v $(pwd)/target:/src/app                           (mount with host folder)
#             -w /src/app                                         (workdir)
#             openjdk:8-alpine                                    (image)
#             /bin/sh -c 'java -jar docker-java-1.0-SNAPSHOT.jar' (has to run with a bash process or else java library won't load as expected)


### 2. Named Volume ###

# Run script #
# create a repo volume  : `docker volume create docker-java-repo`
# create a build volume : `docker volume create docker-java-build`
# build docker image    : `docker build -f ex4.builder.Dockerfile -t minh/docker-java-builder:4.0 .`
# build jar file        : `docker run -it --rm -v docker-java-build/target:/src/app/target -v docker-java:/root/.m2 minh/docker-java-builder:4.0 clean package -Dmaven.test.skip=true`
# run app container     : `docker run --name docker-java -d -p 8080:8080 -v docker-java-build:/src/app -w /src/app openjdk:8-alpine /bin/sh -c 'java -jar docker-java-1.0-SNAPSHOT.jar'`

# Build command breakdown #
# docker run -it                                  (interactive run, show log on command)
#            --rm                                 (container will be removed after launch)
#            -v docker-java-build:/src/app/target (mount container build dir, data from container will be stored in volume)
#            -v docker-java:/root/.m2             (mount container mvn dir with the named volume, data from container will be stored in volume)
#            minh/docker-java-builder:4.0         (image)
#            clean package -Dmaven.test.skip=true (mvn build command)
# Run command breakdown #
# docker run --name docker-java                                   (container name)
#             -d                                                  (detach mode)
#             -p 8080:8080                                        (open port)
#             -v docker-java-build:/src/app                       (mount with volume)
#             -w /src/app                                         (workdir)
#             openjdk:8-alpine                                    (image)
#             /bin/sh -c 'java -jar docker-java-1.0-SNAPSHOT.jar' (has to run with a bash process or else java library won't load as expected)



### Note ###
# Now you will notice that at the first run, the time may not be any different with other example
# But things will get more excited when you update your pom.xml file, remove all built images and retry all the example
# You will notice an instant build time for example 4. This is because it doesn't have to redownload mvn dependencies

### Draw back ###
# The 2 methods are mostly idential and have the same drawback, they both depend on the host file system.
# Check the built files in host system of the method 1, you'll notice that the owner is root not the current user
# $ ls -al target
# drwxr-xr-x 3 root root 4,0K Thg 8 12 11:39 classes/
# -rw-r--r-- 1 root root  16M Thg 8 12 11:39 docker-java-1.0-SNAPSHOT.jar
# -rw-r--r-- 1 root root 3,7K Thg 8 12 11:39 docker-java-1.0-SNAPSHOT.jar.original
#
# Check the built files in volume, you'll notice the same
# $ ls -al /var/snap/docker/common/var-lib-docker/volumes/docker-java-build/_data (the path may vary depends on environment)
# drwxr-xr-x 3 root root 4,0K Thg 8 12 15:35 classes/
# -rw-r--r-- 1 root root  16M Thg 8 12 15:37 docker-java-1.0-SNAPSHOT.jar
# -rw-r--r-- 1 root root 3,7K Thg 8 12 15:36 docker-java-1.0-SNAPSHOT.jar.original
#
# Now, let ajust the previous build script a little bit and change the build command to `clean package` instead of `package`
# build jar file: `docker run -it --rm -v $PWD/target:/src/app/target -v "$HOME"/.m2:/root/.m2 minh/docker-java-builder:4.0 clean package -Dmaven.test.skip=true`:
# You will receive error like below:
# [ERROR] Failed to execute goal org.apache.maven.plugins:maven-clean-plugin:3.0.0:clean (default-clean) on project docker-java: Failed to clean project: Failed to delete /src/app/target -> [Help 1]
# It is obvious that we're having issue with user's permission when running a script with a non-root user and trying to delete root's files
#
# More on the user's permission can be read here: https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf
# One important note that default user of a container is root and it map with host root. You may want to remember to analyze any security risk.
