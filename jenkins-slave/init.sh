#!/bin/bash

# copy keys and set ownership to jenkins-slave
mkdir -p "${JENKINS_AGENT_HOME}/.ssh"
cp /run/secrets/ssh-slave-public-key "${JENKINS_AGENT_HOME}/.ssh/authorized_keys"
cp /run/secrets/git-internal-private-key "${JENKINS_AGENT_HOME}/.ssh/git-internal-private-key"
cp /run/secrets/git-external-private-key "${JENKINS_AGENT_HOME}/.ssh/git-external-private-key"
chown -Rf jenkins-slave:jenkins "${JENKINS_AGENT_HOME}/.ssh"
chmod 0700 -R "${JENKINS_AGENT_HOME}/.ssh"

# ensure variables passed to docker container are also exposed to ssh sessions
env | grep _ >> /etc/environment

# add internal git server to known_hosts file
gitInternalSshKey=`ssh-keyscan -p 29418 gitblit`
while [ -z "$gitInternalSshKey" ]
do
        gitInternalSshKey=`ssh-keyscan -p 29418 gitblit`
done
echo $gitInternalSshKey >> "${JENKINS_AGENT_HOME}/.ssh/known_hosts"

# add external git server to known_hosts file
gitExternalSshKey=`ssh-keyscan git-inf.technikum-wien.at`
while [ -z "$gitExternalSshKey" ]
do
        gitExternalSshKey=`ssh-keyscan git-inf.technikum-wien.at`
done
echo $gitExternalSshKey >> "${JENKINS_AGENT_HOME}/.ssh/known_hosts"

# if this is a job-builder-slave, create its jobs
[ -e /init/init-jenkins-job-builder.sh ] && /init/init-jenkins-job-builder.sh || :

# generate ssh keys for the server
ssh-keygen -A

# run ssh slave
exec /usr/sbin/sshd -D -e "${@}"
