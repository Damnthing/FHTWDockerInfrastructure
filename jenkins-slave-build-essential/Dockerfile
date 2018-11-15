# use jenkins slave image as base image
FROM jenkins-slave:dev

# install build-essentials
RUN apt-get update \
	&& apt-get install -y build-essential \
	&& rm -rf /var/lib/apt/lists/*
 
