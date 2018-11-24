# use official gitblit image
FROM jacekkow/gitblit

# copy scripts, properties and configs for setting up gitblit
COPY jenkins.groovy /opt/gitblit-data-initial/groovy/jenkins.groovy
COPY gitblit.properties /opt/gitblit-data-initial/gitblit.properties
COPY repositoriesMessage.md /opt/gitblit-data-initial/repositoriesMessage.md
COPY users.conf /opt/gitblit-data-initial/users.conf

# set permissions
RUN chmod 0755 /opt/gitblit-data-initial/groovy/jenkins.groovy
RUN chmod 0755 /opt/gitblit-data-initial/gitblit.properties
RUN chmod 0755 /opt/gitblit-data-initial/repositoriesMessage.md
RUN chmod 0755 /opt/gitblit-data-initial/users.conf

# copy init script and set permissions
COPY init.sh /init/init.sh
RUN chmod 0755 /init/init.sh

# start image with init.sh script
ENTRYPOINT [ "/init/init.sh" ]
