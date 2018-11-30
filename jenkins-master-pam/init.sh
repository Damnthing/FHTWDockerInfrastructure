#!/bin/bash

# create .ssh directory and set ownership
mkdir -p "${JENKINS_HOME}/.ssh"
chown -Rf jenkins:jenkins "${JENKINS_HOME}/.ssh"

# copy keys and config and set permissions
cp /init/config "${JENKINS_HOME}/.ssh/config"
cp "${INTERNAL_GIT_PRIVATE_KEY_FILE}" "${JENKINS_HOME}/.ssh/internal-git-private-key"
chmod 0755 "${JENKINS_HOME}/.ssh/config"
chmod 0740 "${JENKINS_HOME}/.ssh/internal-git-private-key"

# set variable values
sed -i 's|$SSH_SLAVE_PRIVATE_KEY_FILE|'"$SSH_SLAVE_PRIVATE_KEY_FILE"'|g' /usr/share/jenkins/ref/init.groovy.d/credentials.groovy
sed -i 's|$JENKINS_USER_FILE|'"$JENKINS_USER_FILE"'|g' /usr/share/jenkins/ref/init.groovy.d/security.groovy
sed -i 's|$JENKINS_PASSWORD_FILE|'"$JENKINS_PASSWORD_FILE"'|g' /usr/share/jenkins/ref/init.groovy.d/security.groovy

# add internal git server to known_hosts file
gitInternalSshKey=`ssh-keyscan -p 29418 gitblit`
while [ -z "$gitInternalSshKey" ]
do
        gitInternalSshKey=`ssh-keyscan -p 29418 gitblit`
done
echo $gitInternalSshKey >> "${JENKINS_HOME}/.ssh/known_hosts"

# add jenkins slave server to known_hosts file
jenkinsSlaveSshKey=`ssh-keyscan jenkins-slave`
while [ -z "$jenkinsSlaveSshKey" ]
do
        jenkinsSlaveSshKey=`ssh-keyscan jenkins-slave`
done
echo $jenkinsSlaveSshKey >> "${JENKINS_HOME}/.ssh/known_hosts"

# add jenkins job builder server to known_hosts file
jenkinsJobBuilderSshKey=`ssh-keyscan jenkins-job-builder`
while [ -z "$jenkinsJobBuilderSshKey" ]
do
        jenkinsJobBuilderSshKey=`ssh-keyscan jenkins-job-builder`
done
echo $jenkinsJobBuilderSshKey >> "${JENKINS_HOME}/.ssh/known_hosts"

# set permissions
chmod 0755 "${JENKINS_HOME}/.ssh/known_hosts"

# start nslcd
sudo /etc/init.d/nslcd start

# start the jenkins server
sh `/sbin/tini -s /usr/local/bin/jenkins.sh`

