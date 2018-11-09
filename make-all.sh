#!/bin/bash

(
	cd nginx-proxy
	docker image build -t nginx-proxy:dev .
)
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
(
	cd jenkins-slave-build-essential
	docker image build -t jenkins-slave-build-essential:dev .
)
(
	cd gitblit
	docker image build -t gitblit:dev .
)
(
	cd database
	docker image build -t database:dev .
)
(
	cd application
	docker image build -t application:dev .
)
