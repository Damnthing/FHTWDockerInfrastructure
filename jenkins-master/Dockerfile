FROM jenkins-master-origin:dev

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY credentials.groovy /usr/share/jenkins/ref/init.groovy.d/credentials.groovy
COPY slave.groovy /usr/share/jenkins/ref/init.groovy.d/slave.groovy
 
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /tmp/plugins.txt

COPY jenkins-slave-rsa /var/jenkins_home/.ssh/gitblit.key 
COPY config /var/jenkins_home/.ssh/config
COPY init.sh /init/init.sh

USER root
RUN chown -R jenkins:jenkins /var/jenkins_home/.ssh
RUN chmod 600 /var/jenkins_home/.ssh/gitblit.key
RUN chmod 660 /var/jenkins_home/.ssh/config
RUN chmod +x /init/init.sh
USER jenkins

ENTRYPOINT ["/init/init.sh"]
