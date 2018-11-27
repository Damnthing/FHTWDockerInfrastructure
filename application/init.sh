#!/bin/bash

# set environment variables in current shell
export POSTGRES_USER=$(cat $POSTGRES_USER_FILE)
export POSTGRES_PASSWORD=$(cat $POSTGRES_PASSWORD_FILE)

# replace placeholders with environment variables
sed -i 's|$POSTGRES_USER|'"$POSTGRES_USER"'|g' /app/Web.config
sed -i 's|$POSTGRES_PASSWORD|'"$POSTGRES_PASSWORD"'|g' /app/Web.config
sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' /app/Web.config
sed -i 's|$VIRTUAL_SUBDIRECTORY|'"$VIRTUAL_SUBDIRECTORY"'|g' /opt/mono-fastcgi

# start the mono-fastcgi-server4
/opt/mono-fastcgi
