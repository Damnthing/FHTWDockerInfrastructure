#!/bin/bash

(
	cd nginx-proxy
	docker image build -t nginx-proxy:dev .
)
(
	cd jenkins-master-origin
	docker image build -t jenkins-master-origin:dev .
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
	cd gitblit
	docker image build -t gitblit:dev .
)
