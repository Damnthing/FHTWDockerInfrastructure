# use official jenkins-slave image
FROM jenkins-slave:dev

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

# copy init script
COPY init-jenkins-job-builder.sh /init/init-jenkins-job-builder.sh
RUN chmod +x /init/init-jenkins-job-builder.sh

#CMD jenkins-jobs --conf /jenkins-job-builder/etc/jenkins-job-builder-conf.ini update /jenkins-job-builder/tests/yamlparser/fixtures/templates002.yaml
