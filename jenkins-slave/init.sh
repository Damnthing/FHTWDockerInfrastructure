#!/bin/bash

# set environment variables in current shell
export INTERNAL_GIT_USER=$(cat $INTERNAL_GIT_USER_FILE)
export POSTGRES_USER=$(cat $POSTGRES_USER_FILE)
export POSTGRES_PASSWORD=$(cat $POSTGRES_PASSWORD_FILE)

# create .ssh directory
mkdir -p "${JENKINS_AGENT_HOME}/.ssh"

# copy keys and config for user jenkins
cp /init/config "${JENKINS_AGENT_HOME}/.ssh/config"
cp "${SSH_SLAVE_USER_PUBLIC_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/authorized_keys"
cp "${INTERNAL_GIT_USER_PRIVATE_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/internal-git-user-private-key"
cp "${EXTERNAL_GIT_USER_PRIVATE_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/external-git-user-private-key"
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
cat $INTERNAL_GIT_SERVER_PUBLIC_KEY_DSA_FILE | xargs echo "[gitblit]:29418" > "${JENKINS_AGENT_HOME}/.ssh/known_hosts"
cat $INTERNAL_GIT_SERVER_PUBLIC_KEY_RSA_FILE | xargs echo "[gitblit]:29418" >> "${JENKINS_AGENT_HOME}/.ssh/known_hosts"

# add external git server to known_hosts file
gitExternalSshKey=`ssh-keyscan git-inf.technikum-wien.at`
while [ -z "$gitExternalSshKey" ]
do
        gitExternalSshKey=`ssh-keyscan git-inf.technikum-wien.at`
done
echo $gitExternalSshKey >> "${JENKINS_AGENT_HOME}/.ssh/known_hosts"

# set ownership and permissions
chown -Rf jenkins:jenkins "${JENKINS_AGENT_HOME}/.ssh"
chmod -R 0700 "${JENKINS_AGENT_HOME}/.ssh"
chmod 0755 "${JENKINS_AGENT_HOME}/.ssh/authorized_keys"

# provide own ssh keys for the server
rm /etc/ssh/ssh_host_dsa_key
rm /etc/ssh/ssh_host_dsa_key.pub
rm /etc/ssh/ssh_host_ecdsa_key
rm /etc/ssh/ssh_host_ecdsa_key.pub
rm /etc/ssh/ssh_host_ed25519_key
rm /etc/ssh/ssh_host_ed25519_key.pub
rm /etc/ssh/ssh_host_rsa_key
rm /etc/ssh/ssh_host_rsa_key.pub
cat $SSH_SLAVE_SERVER_PRIVATE_KEY_RSA_FILE > /etc/ssh/ssh_host_rsa_key
cat $SSH_SLAVE_SERVER_PUBLIC_KEY_RSA_FILE > /etc/ssh/ssh_host_rsa_key.pub

# set permissions
chmod -R 0700 "/etc/ssh"

# run ssh slave
exec /usr/sbin/sshd -D -e "${@}"
