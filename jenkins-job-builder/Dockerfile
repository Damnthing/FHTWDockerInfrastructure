
FROM jenkins-slave:dev
 
USER root

RUN apt-get update \
	&& apt-get install -y python python-pip \ 
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /

RUN git clone https://git.openstack.org/openstack-infra/jenkins-job-builder

WORKDIR /jenkins-job-builder

RUN pip install jenkins-job-builder

COPY jenkins-job-builder-conf.ini /jenkins-job-builder/etc/jenkins-job-builder-conf.ini

COPY init-jenkins-job-builder.sh /init/init-jenkins-job-builder.sh
RUN chmod +x /init/init-jenkins-job-builder.sh

#CMD jenkins-jobs --conf /jenkins-job-builder/etc/jenkins-job-builder-conf.ini update /jenkins-job-builder/tests/yamlparser/fixtures/templates002.yaml
