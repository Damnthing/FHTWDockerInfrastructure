#!/bin/bash

# set the correct path of the jenkins-master
sed -i 's|$COURSE|'"$COURSE"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini

# clone all jobs
git clone "ssh://git@jenkins-ueb-inf@git-inf.technikum-wien.at/ueb-inf/$COURSE.git"

# do nothing while jenkins-master is not availale
cd "./$COURSE"

# non blocking background job
(
	while [ 200 != $(curl --write-out %{http_code} --silent --output /dev/null http://jenkins-master:8080/$COURSE/) ]
	do
		sleep 5
	done

	# create jobs
	jenkins-jobs --conf /jenkins-job-builder/etc/jenkins-job-builder-conf.ini update *
) &
