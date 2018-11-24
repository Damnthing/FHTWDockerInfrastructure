#!/bin/bash

# set environment variables in current shell
export INTERNAL_GIT_USER=$(cat $INTERNAL_GIT_USER_FILE)
export JENKINS_USER=$(cat $JENKINS_USER_FILE)
export JENKINS_PASSWORD=$(cat $JENKINS_PASSWORD_FILE)

# create .ssh directory for user jenkins and set ownership
mkdir -p "${JENKINS_AGENT_HOME}/.ssh"
chown -Rf jenkins:jenkins "${JENKINS_AGENT_HOME}/.ssh"

# copy keys and config for user jenkins and permissions
cp /init/config "${JENKINS_AGENT_HOME}/.ssh/config"
cp "${SSH_SLAVE_PUBLIC_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/authorized_keys"
cp "${INTERNAL_GIT_PRIVATE_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/internal-git-private-key"
cp "${EXTERNAL_GIT_PRIVATE_KEY_FILE}" "${JENKINS_AGENT_HOME}/.ssh/external-git-private-key"
sed -i 's|$INTERNAL_GIT_USER|'"$INTERNAL_GIT_USER"'|g' "${JENKINS_AGENT_HOME}/.ssh/config"
chmod 0740 -R "${JENKINS_AGENT_HOME}/.ssh"

# create .ssh directory for user root
mkdir -p "${HOME}/.ssh"

# copy keys and config for user root and permissions
cp /init/config "${HOME}/.ssh/config"
cp "${EXTERNAL_GIT_PRIVATE_KEY_FILE}" "${HOME}/.ssh/external-git-private-key"
sed -i 's|$INTERNAL_GIT_USER|'"$INTERNAL_GIT_USER"'|g' "${HOME}/.ssh/config"
chmod 0700 -R "${HOME}/.ssh"

# set jenkins-job-builder configuration values
sed -i 's|$JENKINS_SUBDIRECTORY|'"$JENKINS_SUBDIRECTORY"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini
sed -i 's|$JENKINS_USER|'"$JENKINS_USER"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini
sed -i 's|$JENKINS_PASSWORD|'"$JENKINS_PASSWORD"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini

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

# generate ssh keys for the server
ssh-keygen -A

# run ssh slave
exec /usr/sbin/sshd -D -e "${@}"
