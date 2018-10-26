FROM mono:5.16
WORKDIR /gpr1-assignment

RUN apt-get update
RUN apt-get install -y mono-fastcgi-server4
RUN rm -rf /var/lib/apt/lists/* /tmp/*

ENV BIND_TO=eth2
ENV VIRTUAL_ROOT=/assignment

RUN echo "#!/bin/sh\nexport MONO_OPTIONS="--debug"\nfastcgi-mono-server4 /applications=/gpr1-assignment:/gpr1-assignment /socket=tcp:\$(ip -4 addr show \$BIND_TO| grep -Po 'inet \K[\d.]+'):9000 /verbose=True /printlog=True" > /opt/mono-fastcgi
RUN chmod +x /opt/mono-fastcgi

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

#RUN sed -i 's|$POSTGRES_USER|'"$POSTGRES_USER"'|g' Web.config
#RUN sed -i 's|$POSTGRES_PASSWORD|'"$POSTGRES_PASSWORD"'|g' Web.config

RUN sed -i 's|$POSTGRES_USER|'"admin"'|g' Web.config
RUN sed -i 's|$POSTGRES_PASSWORD|'"admin"'|g' Web.config


EXPOSE 9000

CMD [ "/opt/mono-fastcgi" ]
