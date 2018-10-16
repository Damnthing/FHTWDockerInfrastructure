#!/bin/bash

sed -i 's|$FACH_FULL|'"$FACH_FULL"'|g' /jenkins-job-builder/etc/jenkins-job-builder-conf.ini

git clone "https://git-inf.technikum-wien.at/ueb-inf/$FACH_FULL"

cd "$FACH_FULL/jenkins-jobs"

(
	while [ 302 != $(curl --write-out %{http_code} --silent --output /dev/null jenkins-master:8080/$FACH_FULL) ]
	do
		sleep 5
	done

	jenkins-jobs --conf /jenkins-job-builder/etc/jenkins-job-builder-conf.ini update *
) &
