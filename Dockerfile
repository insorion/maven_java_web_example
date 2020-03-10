FROM tomcat:8.0

COPY target/api-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/

#CMD java -cp /usr/src/helloworld-1.0-SNAPSHOT.war
CMD ["/bin/bash"]

# USER root

# EXPOSE 80





# LABEL component="@docker.micro-service-full-name@"
# LABEL componentVersion="@project.version@"
# LABEL Role=Tomcat
# LABEL HTTPEndpointName=springactuator2
# LABEL HTTPEndpointPath=actuator/metrics
# LABEL HTTPEndpointPort=8081

# locale fix
# ENV LANG=en_US.utf8

# ARG WAR_FILE=./target/api-0.0.1-SNAPSHOT.war

# ADD ${WAR_FILE} test.war

# #ENV JAR_FILE=Baumeister.jar

# COPY entrypoint.sh ./

# USER root

# RUN chmod +x ./entrypoint.sh

# USER docker

# EXPOSE 80
# #EXPOSE 8081

# ENTRYPOINT ./entrypoint.sh
