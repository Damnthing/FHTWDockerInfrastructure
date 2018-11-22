#!/bin/bash

(
	cd nginx-proxy
	docker image build --no-cache -t nginx-proxy:dev .
)
(
	cd jenkins-master
	docker image build --no-cache -t jenkins-master:dev .
)
(
	cd jenkins-slave
	docker image build --no-cache -t jenkins-slave:dev .
)
(
	cd jenkins-job-builder
	docker image build --no-cache -t jenkins-job-builder:dev .
)
(
	cd jenkins-slave-build-essential
	docker image build --no-cache -t jenkins-slave-build-essential:dev .
)
(
	cd gitblit
	docker image build --no-cache -t gitblit:dev .
)
(
	cd database
	docker image build --no-cache -t database:dev .
)
(
	cd application
	docker image build --no-cache -t application:dev .
)
