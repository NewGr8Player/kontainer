# FROM OPEN JDK
FROM mcr.microsoft.com/java/jdk:8-zulu-ubuntu-18.04 AS STAGE_COMPILE
# SPECIFIC DIR
RUN mkdir /compile
WORKDIR  /compile
# TODO DEL
RUN pwd
# ADD ADDONS SUPPORT
RUN apt-get update && apt-get install -y git wget unzip maven
# CLONE PROJECT
RUN git clone https://github.com/NewGr8Player/kontainer.git
# TODO COMPILE PROJECT
WORKDIR /compile/kontainer
RUN mvn clean package
RUN ls -laF

# FROM OPEN JRE
FROM mcr.microsoft.com/java/jre:8-zulu-ubuntu-18.04
# SPECIFIC DIR
RUN mkdir /work
WORKDIR  /work
# ADD ADDONS SUPPORT
RUN apt-get update && apt-get install -y unzip xmlstarlet
# TODO DEL
RUN pwd
# TODO VERSION
RUN VERSION=$( xmlstarlet sel \
                -N x='http://maven.apache.org/POM/4.0.0' \
                -t \
                -v '//x:project/x:version/text()' \
                pom.xml \
            )
# TODO DEL
RUN echo ${VERSION}
COPY --from=STAGE_COMPILE /kontainer/target/kontainer-${VERSION}.jar ./
RUN java -jar kontainer-${VERSION}.jar
