FROM jacekkow/gitblit

COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

COPY jenkins.groovy /opt/gitblit-data-initial/groovy/jenkins.groovy
COPY gitblit.properties /opt/gitblit-data-initial/gitblit.properties

CMD /init/init.sh
