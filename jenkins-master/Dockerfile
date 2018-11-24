# use official jenkins image
FROM jenkins/jenkins:lts

# build this image with user root
USER root

# do not run setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# install plugins
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /tmp/plugins.txt

# copy groovy scripts for setting up jenkins
#COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY authentication.groovy /usr/share/jenkins/ref/init.groovy.d/authentication.groovy
COPY ldap.groovy /usr/share/jenkins/ref/init.groovy.d/ldap.groovy
COPY credentials.groovy /usr/share/jenkins/ref/init.groovy.d/credentials.groovy
COPY slave.groovy /usr/share/jenkins/ref/init.groovy.d/slave.groovy
COPY views.groovy /usr/share/jenkins/ref/init.groovy.d/views.groovy

# set permissions
RUN chmod -R 0755 /usr/share/jenkins/ref/init.groovy.d

# copy git config and set permissions
COPY config /init/config
RUN chmod 0755 /init/config

# copy init script and set permissions
COPY init.sh /init/init.sh
RUN chmod 0755 /init/init.sh

# run image with user jenkins
USER jenkins

# start image with init.sh script
ENTRYPOINT ["/init/init.sh"]
