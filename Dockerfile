FROM deloitteva/docker-tomcat:8.0.23
MAINTAINER Justin Grant <jlgrock@gmail.com> "http://www.justinleegrant.com"

# Add the application specifi properties
ADD application.properties $CATALINA_HOME/lib/config.properties
ADD log4j.properties $CATALINA_HOME/lib/log4j.properties

# Used for releases (comment out for development)
RUN mkdir -p /data/uploads /data/object-chronicles /data/search
ADD snpweb.war $CATALINA_HOME/webapps/snpweb.war

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8080
CMD ["catalina.sh", "run"]
