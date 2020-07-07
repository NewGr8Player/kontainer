ARG RELEASE_VERSION
# FROM OPEN JDK
FROM mcr.microsoft.com/java/jdk:8-zulu-ubuntu-18.04 AS STAGE_COMPILE
# SPECIFIC DIR
RUN mkdir /compile
WORKDIR  /compile
# ADD ADDONS SUPPORT
RUN apt-get update && apt-get install -y git wget unzip maven
# CLONE PROJECT
RUN git clone https://github.com/NewGr8Player/kontainer.git
# COMPILE PROJECT
WORKDIR /compile/kontainer
RUN mvn clean package
RUN ls -laF

# FROM OPEN JRE
FROM mcr.microsoft.com/java/jre:8-zulu-ubuntu-18.04
# SPECIFIC DIR
RUN mkdir /work
WORKDIR  /work
COPY --from=STAGE_COMPILE /compile/kontainer/target/kontainer-${RELEASE_VERSION}.jar ./
RUN java -jar kontainer-${RELEASE_VERSION}.jar
