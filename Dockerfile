FROM tomcat:8-jre11

#Remove default artefacts & replace with yours
RUN rm -rf /usr/local/tomcat/webapps/*
COPY target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war


# Expose port 8080
EXPOSE 8080
CMD ["catalina.sh", "run"]
WORKDIR /usr/local/tomcat/webapps/
VOLUME /usr/local/tomcat/webapps 

###########################################################
# ANOTHER Dockerfile
###########################################################
FROM nginx
LABEL "Project"="Vprofile"
LABEL "Author"="ERIC"


RUN rm -rf /etc/nginx/conf.d/default.conf 
COPY nginvproapp.conf /etc/nginx/conf.d/vproapp.conf


##########################################################
# ANOTHER Dockerfile
##########################################################
FROM mysql:5.7.25

ENV MYSQL_ROOT_PASSWORD="vprodpass"
ENV MYSQL_DATABASE="accounts"

ADD db_backup.sql docker-entrypoint-initdb.d/db_backup.sql



