#!/bin/bash

set -ex

# copy keys and set ownership to jenkins-slave
mkdir -p "${JENKINS_AGENT_HOME}/.ssh"
cp /run/secrets/jenkins-master-public-key "${JENKINS_AGENT_HOME}/.ssh/authorized_keys"
cp /run/secrets/gitblit-private-key "${JENKINS_AGENT_HOME}/.ssh/gitblit.key"
chown -Rf jenkins-slave:jenkins "${JENKINS_AGENT_HOME}/.ssh"
chmod 0700 -R "${JENKINS_AGENT_HOME}/.ssh"

# ensure variables passed to docker container are also exposed to ssh sessions
env | grep _ >> /etc/environment

# add gitblit server to known_hosts file
mkdir -p "${JENKINS_AGENT_HOME}/.ssh"
gitblitKey=`ssh-keyscan -p 29418 gitblit`
while [ -z "$gitblitKey" ]
do
        gitblitKey=`ssh-keyscan -p 29418 gitblit`
done
echo $gitblitKey >> "${JENKINS_AGENT_HOME}/.ssh/known_hosts"

[ -e /init/init-jenkins-job-builder.sh ] && /init/init-jenkins-job-builder.sh || :

ssh-keygen -A
exec /usr/sbin/sshd -D -e "${@}"
