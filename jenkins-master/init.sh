#!/bin/bash

# create .ssh directory
mkdir -p "${JENKINS_HOME}/.ssh"

# copy git config
cp /tmp/config "${JENKINS_HOME}/.ssh/config"

# copy key
cp /run/secrets/git-internal-private-key "${JENKINS_HOME}/.ssh/git-internal-private-key"

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

# set ownership to jenkins
chown -Rf jenkins:jenkins "${JENKINS_HOME}/.ssh"
chmod 0700 -R "${JENKINS_HOME}/.ssh"

# start the jenkins server
sh `/sbin/tini -- /usr/local/bin/jenkins.sh`

