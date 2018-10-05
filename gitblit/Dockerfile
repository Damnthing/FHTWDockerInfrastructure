FROM jacekkow/gitblit

COPY jenkins-slave-rsa.pub /opt/gitblit-data/ssh/jenkins.keys

<<<<<<< HEAD
COPY init.sh /init.sh
RUN chmod +x /init.sh

CMD /init.sh
=======
RUN echo "server.contextPath = /gitblit" >> /opt/gitblit-data-initial/gitblit.properties
>>>>>>> f9ba1a0cdd8a9a76e8cbd4a8db1401a94edd155a
