#!/bin/bash

# set environment variables in current shell
export INTERNAL_GIT_USER=$(cat $INTERNAL_GIT_USER_FILE)
export POSTGRES_USER=$(cat $POSTGRES_USER_FILE)
export POSTGRES_PASSWORD=$(cat $POSTGRES_PASSWORD_FILE)

# create .ssh directory and set ownership and permissions
mkdir -p "${JENKINS_AGENT_HOME}/.ssh"
chown -Rf jenkins:jenkins "${JENKINS_AGENT_HOME}/.ssh"
chmod 0740 -R "${JENKINS_AGENT_HOME}/.ssh"

# copy keys and config for user jenkins
cp /init/config "${JENKINS_AGENT_HOME}/.ssh/config"
cp "${SSH_SLAVE_PUBLIC_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/authorized_keys"
cp "${INTERNAL_GIT_PRIVATE_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/internal-git-private-key"
cp "${EXTERNAL_GIT_PRIVATE_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/external-git-private-key"
sed -i 's|$INTERNAL_GIT_USER|'"$INTERNAL_GIT_USER"'|g' "${JENKINS_AGENT_HOME}/.ssh/config"

# create workspace-custom directory for user jenkins and set ownership and permissions
mkdir -p /workspace-custom
chown -Rf jenkins:jenkins /workspace-custom
chmod 0755 -R /workspace-custom

# set reporting tool properties
sed -i 's|$POSTGRES_USER|'"$POSTGRES_USER"'|g' /workspace-custom/Common/ReportingTool.properties
sed -i 's|$POSTGRES_PASSWORD|'"$POSTGRES_PASSWORD"'|g' /workspace-custom/Common/ReportingTool.properties

# ensure variables passed to docker container are also exposed to ssh sessions
env | grep _ >> /etc/environment

# add internal git server to known_hosts file
gitInternalSshKey=`ssh-keyscan -p 29418 gitblit`
while [ -z "$gitInternalSshKey" ]
do
        gitInternalSshKey=`ssh-keyscan -p 29418 gitblit`
done
echo $gitInternalSshKey >> "${JENKINS_AGENT_HOME}/.ssh/known_hosts"
echo $gitInternalSshKey >> "${HOME}/.ssh/known_hosts"

# add external git server to known_hosts file
gitExternalSshKey=`ssh-keyscan git-inf.technikum-wien.at`
while [ -z "$gitExternalSshKey" ]
do
        gitExternalSshKey=`ssh-keyscan git-inf.technikum-wien.at`
done
echo $gitExternalSshKey >> "${JENKINS_AGENT_HOME}/.ssh/known_hosts"
echo $gitExternalSshKey >> "${HOME}/.ssh/known_hosts"

# generate ssh keys for the server
ssh-keygen -A

# run ssh slave
exec /usr/sbin/sshd -D -e "${@}"
