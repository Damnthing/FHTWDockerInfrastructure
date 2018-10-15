#!/bin/bash

git clone "https://git-inf.technikum-wien.at/ueb-inf/$FACH_FULL"

cd "$FACH_FULL/jenkins-jobs"

#while [ 400 != $(curl --write-out %{http_code} --silent --output /dev/null jenkins-master:8080) ]
#do
#	echo "nope"
#done

jenkins-jobs --conf /jenkins-job-builder/etc/jenkins-job-builder-conf.ini update *
