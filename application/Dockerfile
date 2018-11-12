FROM mono:5.16

# set working directory
WORKDIR /

# install mono-fastcgi-server4 and git
RUN apt-get update
RUN apt-get install -y mono-fastcgi-server4 git
RUN rm -rf /var/lib/apt/lists/* /tmp/*

# copy application
RUN mkdir -p /app/App_Data
COPY ./publish/bin /app/bin
COPY ./publish/Content /app/Content
COPY ./publish/fonts /app/fonts
COPY ./publish/Scripts /app/Scripts
COPY ./publish/Views /app/Views
COPY ./publish/favicon.png /app/favicon.png
COPY ./publish/Global.asax /app/Global.asax
COPY ./publish/Docker.Web.config /app/Web.config
COPY ./publish/Views/_ViewStart.cshtml /app/ViewStart.cshtml

# copy git libs (putting right a bug)
COPY ./publish/bin/lib/linux/x86_64/*.so /lib/
COPY ./publish/bin/lib/ /app/lib/

COPY mono-fastcgi /opt/mono-fastcgi
RUN chmod +x /opt/mono-fastcgi

# copy init script
COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

EXPOSE 9000

# start image with init.sh script
ENTRYPOINT [ "/init/init.sh" ]
