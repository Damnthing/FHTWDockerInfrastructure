#!/bin/bash

mkdir /var/jenkins_home/.ssh

gitblitKey=`ssh-keyscan -p 29418 gitblit`
while [ -z "$gitblitKey" ]
do
	gitblitKey=`ssh-keyscan -p 29418 gitblit`
done
echo $gitblitKey >> /var/jenkins_home/.ssh/known_hosts

jenkinsSlaveKey=`ssh-keyscan jenkins-slave`
while [ -z "$jenkinsSlaveKey" ]
do
        jenkinsSlaveKey=`ssh-keyscan jenkins-slave`
done
echo $jenkinsSlaveKey >> /var/jenkins_home/.ssh/known_hosts

jenkinsJobBuilderKey=`ssh-keyscan jenkins-job-builder`
while [ -z "$jenkinsJobBuilderKey" ]
do
        jenkinsJobBuilderKey=`ssh-keyscan jenkins-job-builder`
done
echo $jenkinsJobBuilderKey >> /var/jenkins_home/.ssh/known_hosts

sh `/sbin/tini -- /usr/local/bin/jenkins.sh`

