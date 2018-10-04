FROM jacekkow/gitblit

COPY jenkins-slave-rsa.pub /opt/gitblit-data/ssh/jenkins.keys

COPY init.sh /init.sh
RUN chmod +x /init.sh

CMD /init.sh
