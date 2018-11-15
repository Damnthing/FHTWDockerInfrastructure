# use official jenkins-slave image
FROM jenkins/ssh-slave

# install mono and dot-net-core
RUN apt-get update \
		&& apt-get install apt-transport-https \ 
		&& wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
		&& mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
		&& wget -q https://packages.microsoft.com/config/debian/9/prod.list \
		&& mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
		&& chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
		&& chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
		&& apt-get update \
		&& apt-get install --no-install-recommends -y mono-runtime dotnet-sdk-2.1 \
		&& rm -rf /var/lib/apt/lists/*
		
# copy reporting tool
COPY ReportingTool.jar /workspace-custom/Common/ReportingTool.jar
COPY ReportingTool.properties /workspace-custom/Common/ReportingTool.properties

# copy git config
COPY config /init/config

# copy init script
COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

# start image with init.sh script
ENTRYPOINT ["/init/init.sh"]
