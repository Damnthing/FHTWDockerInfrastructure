#!/bin/bash

(
	cd jenkins-master
	docker image build -t jenkins-master:dev .
)
(
	cd jenkins-slave
	docker image build -t jenkins-slave:dev .
)
(
	cd jenkins-job-builder
	docker image build -t jenkins-job-builder:dev .
)
