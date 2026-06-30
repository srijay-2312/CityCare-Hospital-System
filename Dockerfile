# Step 1: Build the project using Maven
FROM maven:3.8.5-openjdk-17 AS build
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Use Tomcat to run the project
FROM tomcat:10.1-jdk17
# Clean default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the built .war file to Tomcat and rename it to ROOT.war
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]