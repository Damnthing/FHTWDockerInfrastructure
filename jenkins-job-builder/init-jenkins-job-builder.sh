#!/bin/bash

git clone "https://git-inf.technikum-wien.at/ueb-inf/$FACH_FULL"

cd "$FACH_FULL/jenkins-jobs"

jenkins-jobs --conf /jenkins-job-builder/etc/jenkins-job-builder-conf.ini update *
