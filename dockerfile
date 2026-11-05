FROM maven:3.2.5-jdk-6 AS build
WORKDIR /opt

COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent

RUN mvn clean package -Dmaven.test.skip=true

FROM tomcat:6.0-jre6
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /opt/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]