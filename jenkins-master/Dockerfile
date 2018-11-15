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
COPY authentication.groovy /usr/share/jenkins/ref/init.groovy.d/authentication.groovy
COPY ldap.groovy /usr/share/jenkins/ref/init.groovy.d/ldap.groovy
COPY credentials.groovy /usr/share/jenkins/ref/init.groovy.d/credentials.groovy
COPY slave.groovy /usr/share/jenkins/ref/init.groovy.d/slave.groovy
COPY views.groovy /usr/share/jenkins/ref/init.groovy.d/views.groovy

# copy git config
COPY config /tmp/config
RUN chown jenkins:jenkins /tmp/config

# copy init script
COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

# run image with user jenkins
USER jenkins

# start image with init.sh script
ENTRYPOINT ["/init/init.sh"]
