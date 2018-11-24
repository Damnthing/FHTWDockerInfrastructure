#!/bin/bash

# set environment variables in current shell
export INTERNAL_GIT_USER=$(cat $INTERNAL_GIT_USER_FILE)
export INTERNAL_GIT_PASSWORD=$(cat $INTERNAL_GIT_PASSWORD_FILE)

# create ssh directory
mkdir -p /opt/gitblit-data-initial/ssh

# copy key and set permissions
cp "${INTERNAL_GIT_PUBLIC_KEY_FILE}" "/opt/gitblit-data-initial/ssh/${INTERNAL_GIT_USER}.keys"
chmod 0700 -R /opt/gitblit-data-initial/ssh

# run gitblit under the correct path
sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' /opt/gitblit-data-initial/gitblit.properties

# remove admin / admin and create internal git user
sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' /opt/gitblit-data-initial/gitblit.properties
sed -i 's|$JENKINS_SUBDIRECTORY|'"$JENKINS_SUBDIRECTORY"'|g' /opt/gitblit-data-initial/gitblit.properties
sed -i 's|$INTERNAL_GIT_USER|'"$INTERNAL_GIT_USER"'|g' /opt/gitblit-data-initial/users.conf
sed -i 's|$INTERNAL_GIT_PASSWORD|'"$INTERNAL_GIT_PASSWORD"'|g' /opt/gitblit-data-initial/users.conf

# start the server
/run.sh
