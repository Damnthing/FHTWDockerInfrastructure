# The MIT License
#
#  Copyright (c) 2015, CloudBees, Inc.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

FROM openjdk:8-jdk
LABEL MAINTAINER="Nicolas De Loof <nicolas.deloof@gmail.com>"

# set arguments
ARG user=jenkins-slave
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}

# set environment variables
ENV JENKINS_AGENT_HOME ${JENKINS_AGENT_HOME}

# configure user and group
RUN groupadd -g ${gid} ${group} \
    && useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}"

# install oppenssh-server, mono-runtime and dotnet-sdk-2.1
RUN apt-get update \
	&& apt-get install apt-transport-https \ 
	&& wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
        && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
        && wget -q https://packages.microsoft.com/config/debian/9/prod.list \
        && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
        && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
        && chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
    	&& apt-get update \
	&& apt-get install --no-install-recommends -y openssh-server mono-runtime dotnet-sdk-2.1 \
    	&& rm -rf /var/lib/apt/lists/*
#RUN sed -i /etc/ssh/sshd_config \
#        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
#        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
#        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
#        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
#        -e 's/#LogLevel.*/LogLevel INFO/' && \
#    mkdir -p /var/run/sshd

# set working directory
WORKDIR "${JENKINS_AGENT_HOME}"

# create .ssh directory
RUN mkdir -p "${JENKINS_AGENT_HOME}/.ssh"

# copy git config
COPY config ${JENKINS_AGENT_HOME}/.ssh/config

# copy init script
COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

# expose port 22
EXPOSE 22

# start image with init.sh script
ENTRYPOINT ["/init/init.sh"]
