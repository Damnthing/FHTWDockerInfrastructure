FROM jenkins-slave:dev
 
USER root

RUN apt-get update
RUN apt-get install -y python
RUN apt-get install -y python-pip

WORKDIR /

RUN git clone https://git.openstack.org/openstack-infra/jenkins-job-builder

WORKDIR /jenkins-job-builder

RUN pip install jenkins-job-builder

COPY jenkins-job-builder-conf.ini /jenkins-job-builder/etc/jenkins-job-builder-conf.ini

COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

#CMD jenkins-jobs --conf /jenkins-job-builder/etc/jenkins-job-builder-conf.ini update /jenkins-job-builder/tests/yamlparser/fixtures/templates002.yaml
