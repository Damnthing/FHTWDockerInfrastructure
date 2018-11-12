FROM mono:5.16

# set working directory
WORKDIR /app

# install mono-fastcgi-server4 and git
RUN apt-get update
RUN apt-get install -y mono-fastcgi-server4 git
RUN rm -rf /var/lib/apt/lists/* /tmp/*

# copy application
RUN mkdir -p ./App_Data
COPY ./publish/bin ./bin
COPY ./publish/Content ./Content
COPY ./publish/fonts ./fonts
COPY ./publish/Scripts ./Scripts
COPY ./publish/Views ./Views
COPY ./publish/favicon.png ./favicon.png
COPY ./publish/Global.asax ./Global.asax
COPY ./publish/Docker.Web.config ./Web.config
COPY ./publish/Views/_ViewStart.cshtml ./ViewStart.cshtml

# copy git libs (putting right a bug)
COPY ./publish/bin/lib/linux/x86_64/*.so /lib/
COPY ./publish/bin/lib/ ./lib/

# copy init script
COPY init.sh /init/init.sh

EXPOSE 9000

# start image with init.sh script
CMD [ "/init/init.sh" ]
