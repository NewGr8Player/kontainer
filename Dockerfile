ENV JAVA_IMAGE_VERSION 8-zulu-ubuntu-18.04
ENV DIR_STAGE_COMPILE compile
ENV DIR_STAGE_WORK work
# FROM OPEN JDK
FROM mcr.microsoft.com/java/jdk:${JAVA_IMAGE_VERSION} AS STAGE-COMPILE
# SPECIFIC DIR
RUN mkdir /${DIR_STAGE_COMPILE}
WORKDIR  /${DIR_STAGE_COMPILE}
# TODO DEL
RUN pwd
# ADD ADDONS SUPPORT
RUN apt-get update
RUN apt-get install -y git wget
# TODO CLONE PROJECT
RUN git clone https://github.com/NewGr8Player/kontainer.git
# TODO ADD MAVEN SUPPORT
RUN wget http://apache.communilink.net/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip
RUN unzip apache-maven-3.6.3-bin.zip apache-maven-3.6.3
RUN export M2_HOME=/${DIR_STAGE_COMPILE}/apache-maven-3.5.3
RUN export PATH=${M2_HOME}/bin:$PATH
# TODO COMPILE PROJECT
RUN cd kontainer
RUN mvn clean package
RUN ls -laF

FROM mcr.microsoft.com/java/jre:${JAVA_IMAGE_VERSION}
# SPECIFIC DIR
RUN mkdir /${DIR_STAGE_WORK}
WORKDIR  /${DIR_STAGE_WORK}
# TODO DEL
RUN pwd
COPY --from STAGE-COMPILE /kontainer/Main.class ./
