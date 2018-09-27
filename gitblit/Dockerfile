FROM jacekkow/gitblit

COPY jenkins-slave-rsa.pub /opt/gitblit-data/ssh/jenkins.keys

RUN echo "server.contextPath = /gitblit" >> /opt/gitblit-data-initial/gitblit.properties
