FROM gradle:7-jdk17 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle buildFatJar --no-daemon


#FROM openjdk:17
#FROM   openjdk:17-jdk-alpine3.14
# libmysql-java
FROM ubuntu:23.10
RUN apt -y update
RUN apt install -y openjdk-22-jre mysql-server  mysql-client wget dpkg
RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j_8.3.0-1ubuntu23.10_all.deb
RUN  dpkg -i ./mysql-connector-j_8.3.0-1ubuntu23.10_all.deb
EXPOSE 8080:8080
RUN mkdir /app
COPY --from=build /home/gradle/src/build/libs/*jar /app/ktor-mysql-backend.jar
COPY  /static/*.sql /static/

ENTRYPOINT ["java","-jar","/app/ktor-mysql-backend.jar"]