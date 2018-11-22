#!/bin/bash

# set environment variables in current shell
export INTERNAL_GIT_USER=$(cat $INTERNAL_GIT_USER_FILE)

# copy keys and config
mkdir -p "${JENKINS_AGENT_HOME}/.ssh"
mkdir -p "${HOME}/.ssh"
cp /init/config "${JENKINS_AGENT_HOME}/.ssh/config"
cp /init/config "${HOME}/.ssh/config"
cp "${SSH_SLAVE_PUBLIC_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/authorized_keys"
cp "${INTERNAL_GIT_PRIVATE_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/internal-git-private-key"
cp "${EXTERNAL_GIT_PRIVATE_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/external-git-private-key"
cp "${EXTERNAL_GIT_PRIVATE_KEY_FILE}" "${HOME}/.ssh/external-git-private-key"
chmod 400 "${HOME}/.ssh/external-git-private-key"

# set internal git user to pull with
sed -i 's|$INTERNAL_GIT_USER|'"$INTERNAL_GIT_USER"'|g' "${JENKINS_AGENT_HOME}/.ssh/config"

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
echo $gitExternalSshKey >> "${HOME}/.ssh/known_hosts"

# if this is a job-builder-slave, create its jobs
[ -e /init/init-jenkins-job-builder.sh ] && /init/init-jenkins-job-builder.sh || :

# generate ssh keys for the server
ssh-keygen -A

# set ownership to user jenkins
chown -Rf jenkins:jenkins "${JENKINS_AGENT_HOME}/.ssh"
chmod 0700 -R "${JENKINS_AGENT_HOME}/.ssh"

# create custom work directory and set ownership to user jenkins
mkdir -p /workspace-custom
chown -Rf jenkins:jenkins "/workspace-custom"

# run ssh slave
exec /usr/sbin/sshd -D -e "${@}"
