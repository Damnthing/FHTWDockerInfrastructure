#!/bin/bash

export JENKINS_USER=$(cat $JENKINS_USER_FILE)
export JENKINS_PASSWORD=$(cat $JENKINS_PASSWORD_FILE)

# set the correct path of the jenkins-master
sed -i 's|$JENKINS_SUBDIRECTORY|'"$JENKINS_SUBDIRECTORY"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini
sed -i 's|$JENKINS_USER|'"$JENKINS_USER"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini
sed -i 's|$JENKINS_PASSWORD|'"$JENKINS_PASSWORD"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini

# clone all jobs
git clone "ssh://git@git-inf.technikum-wien.at/ueb-inf/$COURSE.git"

# do nothing while jenkins-master is not availale
cd "./$COURSE"

# non blocking background job
(
	while [ 200 != $(curl --write-out %{http_code} --silent --output /dev/null http://jenkins-master:8080/$JENKINS_SUBDIRECTORY/) ]
	do
		sleep 5
	done

	# create jobs
	jenkins-jobs --conf /jenkins-job-builder/etc/jenkins-job-builder-conf.ini update .
	#jenkins-jobs --conf /jenkins-job-builder/etc/jenkins-job-builder-conf.ini update /jenkins-job-builder/tests/yamlparser/fixtures/templates002.yaml
) &
