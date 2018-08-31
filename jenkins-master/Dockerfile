FROM jenkins-master-origin:dev

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY credentials.groovy /usr/share/jenkins/ref/init.groovy.d/credentials.groovy
COPY slave.groovy /usr/share/jenkins/ref/init.groovy.d/slave.groovy
 
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /tmp/plugins.txt

COPY known_hosts /var/jenkins_home/.ssh/known_hosts
COPY jenkins-slave-rsa /var/jenkins_home/.ssh/gitblit.key 
COPY config /var/jenkins_home/.ssh/config

USER root
RUN chown -R jenkins:jenkins /var/jenkins_home/.ssh
RUN chmod 600 /var/jenkins_home/.ssh/gitblit.key
RUN chmod 660 /var/jenkins_home/.ssh/config
RUN chmod 660 /var/jenkins_home/.ssh/known_hosts
USER jenkins

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
