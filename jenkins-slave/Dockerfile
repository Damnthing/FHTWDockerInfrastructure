FROM jenkins/ssh-slave

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

COPY config /init/config

COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

ENTRYPOINT ["/init/init.sh"]
