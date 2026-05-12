FROM maven:3.8.6-jdk-8 as build

WORKDIR /app
ARG USER_HOME_DIR="/neoflex"
VOLUME "$USER_HOME_DIR/.m2"
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY pom.xml .
RUN mvn -e -B dependency:resolve

COPY src ./src
RUN mvn -e -B package

FROM tomcat:8.5

COPY --from=build /app/target/demo.war /usr/local/tomcat/webapps/

RUN echo "export JAVA_OPTS=\"-Dapp.env=staging\"" > /usr/local/tomcat/bin/setenv.sh \
        && chmod +x /usr/local/tomcat/bin/setenv.sh
        
EXPOSE 8080

CMD ["catalina.sh", "run"]