#!/bin/bash

# create ssh directory
mkdir -p /opt/gitblit-data-initial/ssh

# copy key
cp /run/secrets/git-internal-public-key /opt/gitblit-data-initial/ssh/git-internal-public-key.keys

# run gitblit under the correct path
sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' /opt/gitblit-data-initial/gitblit.properties

# start the server
/run.sh
