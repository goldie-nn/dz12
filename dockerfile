FROM maven:3.8-openjdk-11 AS build
WORKDIR /opt

COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent

RUN mvn clean package -Dmaven.test.skip=true \
    -Dmaven.compiler.source=1.6 \
    -Dmaven.compiler.target=1.6

FROM tomcat:8.5-jdk8-openjdk
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /opt/target/*.war /usr/local/tomcat/webapps/ROOT.war
RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
    cd /usr/local/tomcat/webapps/ROOT && \
    jar -xf ../ROOT.war

RUN mkdir -p /usr/local/tomcat/ROOT && \
    cp /usr/local/tomcat/webapps/ROOT/Config.properties /usr/local/tomcat/ROOT/Config.properties

EXPOSE 8080
CMD ["catalina.sh", "run"]