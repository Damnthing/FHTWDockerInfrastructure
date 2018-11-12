#!/bin/bash

export POSTGRES_USER=$(cat $POSTGRES_USER_FILE)
export POSTGRES_PASSWORD=$(cat $POSTGRES_PASSWORD_FILE)

# copy app to right directory
mv /app /$VIRTUAL_SUBDIRECTORY

cd /$VIRTUAL_SUBDIRECTORY

# replace placeholders with environment variables
sed -i 's|$POSTGRES_USER|'"$POSTGRES_USER"'|g' ./Web.config
sed -i 's|$POSTGRES_PASSWORD|'"$POSTGRES_PASSWORD"'|g' ./Web.config
sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' ./Web.config
sed -i 's|$VIRTUAL_SUBDIRECTORY|'"$VIRTUAL_SUBDIRECTORY"'|g' /opt/mono-fastcgi
 

/opt/mono-fastcgi
