# example 5 - Data Container Pattern

# In the previous example, there's a limitation.
# Multiple executions of build process share the same build folder but we cannot run clean build because of conflicting user permission.
# Though in theory a normal `mvn package` should never cause problem with caching between build, we can never know

# This example is to eliminate the that limitation.
# each execution of build process will use a different folder therefore it could never conflict with built files of previous build process.
# This example use data container pattern. More detail can be found here https://hackernoon.com/docker-data-containers-cb250048d162

# Run script #
# build jar file     : `docker run --name docker-java-builder -v /src/app/target -v $(pwd):/src/app -v "$HOME"/.m2:/root/.m2 -w /src/app maven:3.5-jdk-8-alpine package -Dmaven.test.skip=true`:
# run app container  : `docker run --name docker-java -d -p 8080:8080 --volumes-from docker-java-builder -w /src/app --network=host openjdk:8-alpine /bin/sh -c 'java -jar target/docker-java-1.0-SNAPSHOT.jar'`:

# build jar file breakdown
# docker run --name docker-java-builder
#            -v /src/app/target             (*mount a docker volume to this container specific folder)
#            -v $(pwd):/src/app             (mount with host source folder)
#            -v "$HOME"/.m2:/root/.m2       (mount with local mvn repo)
#            -w /src/app                    (workdir)
#            maven:3.5-jdk-8-alpine         (image)
#            package -Dmaven.test.skip=true (mvn build script)

# run app container breakdown
# docker run --name docker-java
#            -d                                                         (detach mode)
#            -p 8080:8080                                               (expose ports)
#            --volumes-from docker-java-builder                         (bind the volume from previous container)
#            -w /src/app                                                (workdir)
#            --network=host                                             (network)
#            openjdk:8-alpine                                           (image)
#            /bin/sh -c 'java -jar target/docker-java-1.0-SNAPSHOT.jar' (java run script, note that /src/app/target folder is from volume bind with previous container)

