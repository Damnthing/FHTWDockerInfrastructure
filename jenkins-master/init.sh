#!/bin/bash

# set environment variables in current shell
export INTERNAL_GIT_USER=$(cat $INTERNAL_GIT_USER_FILE)
export JENKINS_USER=$(cat $JENKINS_USER_FILE)
export JENKINS_PASSWORD=$(cat $JENKINS_PASSWORD_FILE)

# add user for jenkins job builder
sudo useradd $JENKINS_USER
echo "$JENKINS_USER:$JENKINS_PASSWORD" | sudo chpasswd &> /dev/null

# create .ssh directory and set ownership
mkdir -p "${JENKINS_HOME}/.ssh"
chown -Rf jenkins:jenkins "${JENKINS_HOME}/.ssh"

# copy keys and config and set permissions
cp /init/config "${JENKINS_HOME}/.ssh/config"
cp "${INTERNAL_GIT_USER_PRIVATE_KEY_FILE}" "${JENKINS_HOME}/.ssh/internal-git-user-private-key"
chmod 0755 "${JENKINS_HOME}/.ssh/config"
chmod 0700 "${JENKINS_HOME}/.ssh/internal-git-user-private-key"

# set variable values
sed -i 's|$JENKINS_USER|'"$JENKINS_USER"'|g' /usr/share/jenkins/ref/init.groovy.d/authentication.groovy
sed -i 's|$SSH_SLAVE_USER_PRIVATE_KEY_FILE|'"$SSH_SLAVE_USER_PRIVATE_KEY_FILE"'|g' /usr/share/jenkins/ref/init.groovy.d/credentials.groovy
sed -i 's|$INTERNAL_GIT_USER|'"$INTERNAL_GIT_USER"'|g' "${JENKINS_HOME}/.ssh/config"

# add internal git, jenkins-slave and jenkins-job-builder server to known_hosts file
cat $INTERNAL_GIT_SERVER_PUBLIC_KEY_DSA_FILE | xargs echo "[gitblit]:29418" > "${JENKINS_HOME}/.ssh/known_hosts"
cat $INTERNAL_GIT_SERVER_PUBLIC_KEY_RSA_FILE | xargs echo "[gitblit]:29418" >> "${JENKINS_HOME}/.ssh/known_hosts"
cat $SSH_SLAVE_SERVER_PUBLIC_KEY_RSA_FILE | xargs echo "jenkins-slave" >> "${JENKINS_HOME}/.ssh/known_hosts"
cat $SSH_SLAVE_SERVER_PUBLIC_KEY_RSA_FILE | xargs echo "jenkins-job-builder" >> "${JENKINS_HOME}/.ssh/known_hosts"

# set permissions
chmod 0755 "${JENKINS_HOME}/.ssh/known_hosts"

# start nslcd
sudo /etc/init.d/nslcd start

# start the jenkins server
sh `/sbin/tini -s /usr/local/bin/jenkins.sh`

