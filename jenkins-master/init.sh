#!/bin/bash

mkdir -p "${JENKINS_HOME}/.ssh"

cp /run/secrets/gitblit-private-key "${JENKINS_HOME}/.ssh/gitblit.key"

gitblitKey=`ssh-keyscan -p 29418 gitblit`
while [ -z "$gitblitKey" ]
do
	gitblitKey=`ssh-keyscan -p 29418 gitblit`
done
echo $gitblitKey >> "${JENKINS_HOME}/.ssh/known_hosts"

jenkinsSlaveKey=`ssh-keyscan jenkins-slave`
while [ -z "$jenkinsSlaveKey" ]
do
        jenkinsSlaveKey=`ssh-keyscan jenkins-slave`
done
echo $jenkinsSlaveKey >> "${JENKINS_HOME}/.ssh/known_hosts"

jenkinsJobBuilderKey=`ssh-keyscan jenkins-job-builder`
while [ -z "$jenkinsJobBuilderKey" ]
do
        jenkinsJobBuilderKey=`ssh-keyscan jenkins-job-builder`
done
echo $jenkinsJobBuilderKey >> "${JENKINS_HOME}/.ssh/known_hosts"

sh `/sbin/tini -- /usr/local/bin/jenkins.sh`

