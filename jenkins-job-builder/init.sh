#!/bin/bash

# set environment variables in current shell
export INTERNAL_GIT_USER=$(cat $INTERNAL_GIT_USER_FILE)
export JENKINS_USER=$(cat $JENKINS_USER_FILE)
export JENKINS_PASSWORD=$(cat $JENKINS_PASSWORD_FILE)

# create .ssh directory for user jenkins
mkdir -p "${JENKINS_AGENT_HOME}/.ssh"

# copy keys and config for user jenkins
cp /init/config "${JENKINS_AGENT_HOME}/.ssh/config"
cp "${SSH_SLAVE_USER_PUBLIC_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/authorized_keys"
cp "${INTERNAL_GIT_USER_PRIVATE_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/internal-git-user-private-key"
cp "${EXTERNAL_GIT_USER_PRIVATE_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/external-git-user-private-key"
sed -i 's|$INTERNAL_GIT_USER|'"$INTERNAL_GIT_USER"'|g' "${JENKINS_AGENT_HOME}/.ssh/config"

# create .ssh directory for user root
mkdir -p "${HOME}/.ssh"

# copy keys and config for user root
cp /init/config "${HOME}/.ssh/config"
cp "${INTERNAL_GIT_USER_PRIVATE_KEY_FILE}" "${HOME}/.ssh/internal-git-user-private-key"
cp "${EXTERNAL_GIT_USER_PRIVATE_KEY_FILE}" "${HOME}/.ssh/external-git-user-private-key"
sed -i 's|$INTERNAL_GIT_USER|'"$INTERNAL_GIT_USER"'|g' "${HOME}/.ssh/config"

# set jenkins-job-builder configuration values
sed -i 's|$JENKINS_SUBDIRECTORY|'"$JENKINS_SUBDIRECTORY"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini
sed -i 's|$JENKINS_USER|'"$JENKINS_USER"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini
sed -i 's|$JENKINS_PASSWORD|'"$JENKINS_PASSWORD"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini

# ensure variables passed to docker container are also exposed to ssh sessions
env | grep _ >> /etc/environment

# add internal git server to known_hosts file
cat $INTERNAL_GIT_SERVER_PUBLIC_KEY_DSA_FILE | xargs echo "[gitblit]:29418" > "${JENKINS_AGENT_HOME}/.ssh/known_hosts"
cat $INTERNAL_GIT_SERVER_PUBLIC_KEY_RSA_FILE | xargs echo "[gitblit]:29418" >> "${JENKINS_AGENT_HOME}/.ssh/known_hosts"
cat $INTERNAL_GIT_SERVER_PUBLIC_KEY_DSA_FILE | xargs echo "[gitblit]:29418" > "${HOME}/.ssh/known_hosts"
cat $INTERNAL_GIT_SERVER_PUBLIC_KEY_RSA_FILE | xargs echo "[gitblit]:29418" >> "${HOME}/.ssh/known_hosts"

# add external git server to known_hosts file
gitExternalSshKey=`ssh-keyscan git-inf.technikum-wien.at`
while [ -z "$gitExternalSshKey" ]
do
        gitExternalSshKey=`ssh-keyscan git-inf.technikum-wien.at`
done
echo $gitExternalSshKey >> "${JENKINS_AGENT_HOME}/.ssh/known_hosts"
echo $gitExternalSshKey >> "${HOME}/.ssh/known_hosts"

# set ownership and permissions
chown -Rf jenkins:jenkins "${JENKINS_AGENT_HOME}/.ssh"
chmod -R 0700 "${JENKINS_AGENT_HOME}/.ssh"
chmod 0700 -R "${HOME}/.ssh"
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

# clone all jobs
git clone "ssh://git@git-inf.technikum-wien.at/ueb-inf/$COURSE-Jobs.git"
cd "./$COURSE-Jobs"

# non blocking background job
(
	# do nothing while jenkins-master is not availale
	while [ 200 != $(curl --write-out %{http_code} --silent --output /dev/null http://jenkins-master:8080/$JENKINS_SUBDIRECTORY/) ]
	do
		sleep 5
	done

	# create jobs
	jenkins-jobs --conf /jenkins-job-builder/etc/jenkins-job-builder-conf.ini update .
) &

# run ssh slave
exec /usr/sbin/sshd -D -e "${@}"
