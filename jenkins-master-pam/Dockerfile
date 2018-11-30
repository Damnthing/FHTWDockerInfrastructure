# use official jenkins image
FROM jenkins/jenkins:lts

# build this image with user root
USER root

# add user jenkins to group shadow
RUN adduser jenkins shadow

# install packages for pam / ldap authentication
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -yq libnss-ldapd libpam-ldapd sudo

# copy pam / ldap authentication config and set permissions
COPY nslcd.conf /etc/nslcd.conf
COPY nsswitch.conf /etc/nsswitch.conf
RUN chmod 755 /etc/nslcd.conf
RUN chmod 755 /etc/nsswitch.conf

# enable user jenkins to run pam / ldap authentication
RUN echo "jenkins ALL=NOPASSWD: /etc/init.d/nslcd" >> /etc/sudoers 

# do not run setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# install plugins
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /tmp/plugins.txt

# copy groovy scripts for setting up jenkins
COPY authentication.groovy /usr/share/jenkins/ref/init.groovy.d/authentication.groovy
COPY pam.groovy /usr/share/jenkins/ref/init.groovy.d/pam.groovy
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
