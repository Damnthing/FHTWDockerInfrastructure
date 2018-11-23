# use official jenkins-slave image
FROM jenkins/ssh-slave

# install python and python-pip
RUN apt-get update \
	&& apt-get install -y python python-pip \ 
	&& rm -rf /var/lib/apt/lists/*

# set working directory
WORKDIR /

# clone job-builder-repository
RUN git clone https://git.openstack.org/openstack-infra/jenkins-job-builder

# set working directory
WORKDIR /jenkins-job-builder

# install jenkins-job-builder
RUN pip install jenkins-job-builder

# copy jenkins-job-builder-configuration
COPY jenkins-job-builder-conf.ini /jenkins-job-builder/etc/jenkins-job-builder-conf.ini

# copy git config
COPY config /init/config

# copy init script
COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

# start image with init.sh script
ENTRYPOINT ["/init/init.sh"]
