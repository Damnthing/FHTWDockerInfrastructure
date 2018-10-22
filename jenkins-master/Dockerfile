FROM jenkins-master-origin:dev

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY credentials.groovy /usr/share/jenkins/ref/init.groovy.d/credentials.groovy
COPY slave.groovy /usr/share/jenkins/ref/init.groovy.d/slave.groovy
 
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /tmp/plugins.txt

COPY config "${JENKINS_HOME}/.ssh/config"
COPY init.sh /init/init.sh

USER root
RUN chown -R jenkins:jenkins ${JENKINS_HOME}/.ssh
RUN chmod 660 ${JENKINS_HOME}/.ssh/config
RUN chmod +x /init/init.sh
USER jenkins

ENTRYPOINT ["/init/init.sh"]
