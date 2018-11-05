FROM jenkins/jenkins:lts

USER root

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY authentication.groovy /usr/share/jenkins/ref/init.groovy.d/authentication.groovy
COPY ldap.groovy /usr/share/jenkins/ref/init.groovy.d/ldap.groovy
#COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY credentials.groovy /usr/share/jenkins/ref/init.groovy.d/credentials.groovy
COPY slave.groovy /usr/share/jenkins/ref/init.groovy.d/slave.groovy
COPY views.groovy /usr/share/jenkins/ref/init.groovy.d/views.groovy
 
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /tmp/plugins.txt

COPY config /tmp/config
RUN chown jenkins:jenkins /tmp/config

COPY config.xml /tmp/config.xml
RUN chown jenkins:jenkins /tmp/config.xml

COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

USER jenkins

ENTRYPOINT ["/init/init.sh"]
