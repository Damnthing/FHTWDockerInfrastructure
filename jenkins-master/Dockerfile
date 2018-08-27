FROM jenkins/jenkins:lts

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY credentials.groovy /usr/share/jenkins/ref/init.groovy.d/credentials.groovy
COPY slave.groovy /usr/share/jenkins/ref/init.groovy.d/slave.groovy
 
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /tmp/plugins.txt

COPY known_hosts /var/jenkins_home/.ssh/known_hosts

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
