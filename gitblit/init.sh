#!/bin/bash

# set environment variables in current shell
export INTERNAL_GIT_USER=$(cat $INTERNAL_GIT_USER_FILE)
export INTERNAL_GIT_PASSWORD=$(cat $INTERNAL_GIT_PASSWORD_FILE)

# create ssh directory
mkdir -p /opt/gitblit-data-initial/ssh

# copy key and set permissions
cp "${INTERNAL_GIT_USER_PUBLIC_KEY_FILE}" "/opt/gitblit-data-initial/ssh/${INTERNAL_GIT_USER,,}.keys"
chmod 0700 "/opt/gitblit-data-initial/ssh/${INTERNAL_GIT_USER}.keys"

# run gitblit under the correct path
sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' /opt/gitblit-data-initial/gitblit.properties

# remove admin / admin and create internal git user
sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' /opt/gitblit-data-initial/gitblit.properties
sed -i 's|$JENKINS_SUBDIRECTORY|'"$JENKINS_SUBDIRECTORY"'|g' /opt/gitblit-data-initial/gitblit.properties
sed -i 's|$INTERNAL_GIT_USER|'"$INTERNAL_GIT_USER"'|g' /opt/gitblit-data-initial/users.conf
sed -i 's|$INTERNAL_GIT_PASSWORD|'"$INTERNAL_GIT_PASSWORD"'|g' /opt/gitblit-data-initial/users.conf

# copy ssh keys for the server
cat $INTERNAL_GIT_SERVER_PRIVATE_KEY_DSA_FILE > /opt/gitblit-data/ssh-dsa-hostkey.pem
cat $INTERNAL_GIT_SERVER_PRIVATE_KEY_RSA_FILE > /opt/gitblit-data/ssh-rsa-hostkey.pem

# set permissions
chmod 0700 "/opt/gitblit-data/ssh-dsa-hostkey.pem"
chmod 0700 "/opt/gitblit-data/ssh-rsa-hostkey.pem"

# start the server
/run.sh
