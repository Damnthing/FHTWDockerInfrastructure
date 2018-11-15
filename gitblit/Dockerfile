FROM jacekkow/gitblit

COPY jenkins.groovy /opt/gitblit-data-initial/groovy/jenkins.groovy
COPY gitblit.properties /opt/gitblit-data-initial/gitblit.properties
COPY repositoriesMessage.md /opt/gitblit-data-initial/repositoriesMessage.md
COPY users.conf /opt/gitblit-data-initial/users.conf

COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

CMD /init/init.sh
