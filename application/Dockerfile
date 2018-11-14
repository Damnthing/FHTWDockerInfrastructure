FROM mono:5.16

# set working directory
WORKDIR /build

# install mono-fastcgi-server4 and git
RUN apt-get update
RUN apt-get install -y mono-fastcgi-server4 git
RUN rm -rf /var/lib/apt/lists/* /tmp/*

# build the application
RUN git clone https://inf-swe-git.technikum-wien.at/r/SYSTEM/Assignment.git
WORKDIR /build/Assignment
RUN nuget restore Assignment.sln
RUN msbuild Assignment.sln

# copy application
RUN mkdir -p /app/App_Data
RUN cp -R ./Assignment/bin /app/bin
RUN cp -R ./Assignment/Content /app/Content
RUN cp -R ./Assignment/fonts /app/fonts
RUN cp -R ./Assignment/Scripts /app/Scripts
RUN cp -R ./Assignment/Views /app/Views
RUN cp -R ./Assignment/favicon.png /app/favicon.png
RUN cp -R ./Assignment/Global.asax /app/Global.asax
RUN cp -R ./Assignment/Docker.Web.config /app/Web.config
RUN cp -R ./Assignment/Views/_ViewStart.cshtml /app/ViewStart.cshtml

# copy git libs (putting right a bug)
RUN cp -R ./Assignment/bin/lib/linux/x86_64/*.so /lib/
RUN cp -R ./Assignment/bin/lib/ /app/lib/

WORKDIR /

COPY mono-fastcgi /opt/mono-fastcgi
RUN chmod +x /opt/mono-fastcgi

# copy init script
COPY init.sh /init/init.sh
RUN chmod +x /init/init.sh

EXPOSE 9000

# start image with init.sh script
ENTRYPOINT [ "/init/init.sh" ]
