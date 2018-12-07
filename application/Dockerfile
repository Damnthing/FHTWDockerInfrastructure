# use official mono image
FROM mono:5.16 as builder

# set working directory
WORKDIR /build

# install git
RUN apt-get update
RUN apt-get install -y git
RUN rm -rf /var/lib/apt/lists/* /tmp/*

# build the application
RUN git clone https://inf-swe-git.technikum-wien.at/r/SYSTEM/Assignment.git
WORKDIR /build/Assignment
RUN nuget restore Assignment.sln
RUN msbuild Assignment.sln

# use official mono image
FROM mono:5.16

# install mono-fastcgi-server4 and git
RUN apt-get update
RUN apt-get install -y mono-fastcgi-server4 git
RUN rm -rf /var/lib/apt/lists/* /tmp/*

# copy application
RUN mkdir -p /app/App_Data
COPY --from=builder /build/Assignment/Assignment/bin /app/bin
COPY --from=builder /build/Assignment/Assignment/Content /app/Content
COPY --from=builder /build/Assignment/Assignment/fonts /app/fonts
COPY --from=builder /build/Assignment/Assignment/Scripts /app/Scripts
COPY --from=builder /build/Assignment/Assignment/Views /app/Views
COPY --from=builder /build/Assignment/Assignment/favicon.png /app/favicon.png
COPY --from=builder /build/Assignment/Assignment/Global.asax /app/Global.asax
COPY --from=builder /build/Assignment/Assignment/Docker.Web.config /app/Web.config
COPY --from=builder /build/Assignment/Assignment/Views/_ViewStart.cshtml /app/ViewStart.cshtml

# copy git libs (putting right a bug)
COPY --from=builder /build/Assignment/Assignment/bin/lib/linux/x86_64/*.so /lib/
COPY --from=builder /build/Assignment/Assignment/bin/lib/ /app/lib/

# set permissions
RUN chmod -R 0755 /app

WORKDIR /

# copy mono-fastcgi-server4 config and set permissions
COPY mono-fastcgi /opt/mono-fastcgi
RUN chmod 0755 /opt/mono-fastcgi

# copy init script and set permissions
COPY init.sh /init/init.sh
RUN chmod 0755 /init/init.sh

# expost port 9000
EXPOSE 9000

# start image with init.sh script
ENTRYPOINT [ "/init/init.sh" ]
