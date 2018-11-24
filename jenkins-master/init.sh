#!/bin/bash

# create .ssh directory and set ownership and permissions
mkdir -p "${JENKINS_HOME}/.ssh"
chown -Rf jenkins:jenkins "${JENKINS_HOME}/.ssh"
chmod 0750 -R "${JENKINS_HOME}/.ssh"

# copy git config
cp /init/config "${JENKINS_HOME}/.ssh/config"

# copy key
cp "${INTERNAL_GIT_PRIVATE_KEY_FILE}" "${JENKINS_HOME}/.ssh/internal-git-private-key"

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

# start the jenkins server
sh `/sbin/tini -- /usr/local/bin/jenkins.sh`

