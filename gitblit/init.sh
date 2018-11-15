#!/bin/bash

# set environment variables in current shell
export GITBLIT_INTERNAL_USER=$(cat $GITBLIT_INTERNAL_USER_FILE)
export GITBLIT_INTERNAL_PASSWORD=$(cat $GITBLIT_INTERNAL_PASSWORD_FILE)

# create ssh directory
mkdir -p /opt/gitblit-data-initial/ssh

# copy key
cp /run/secrets/git-internal-public-key "/opt/gitblit-data-initial/ssh/${GITBLIT_INTERNAL_USER}.keys"

# run gitblit under the correct path
sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' /opt/gitblit-data-initial/gitblit.properties

# remove admin / admin and create internal git user
sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' /opt/gitblit-data-initial/gitblit.properties
sed -i 's|$GITBLIT_INTERNAL_USER|'"$GITBLIT_INTERNAL_USER"'|g' /opt/gitblit-data-initial/users.conf
sed -i 's|$GITBLIT_INTERNAL_PASSWORD|'"$GITBLIT_INTERNAL_PASSWORD"'|g' /opt/gitblit-data-initial/users.conf

# start the server
/run.sh
