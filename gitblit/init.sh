#!/bin/bash

mkdir -p /opt/gitblit-data-initial/ssh
cp /run/secrets/gitblit-public-key /opt/gitblit-data-initial/ssh/gitblit.keys

sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' /opt/gitblit-data-initial/gitblit.properties

/run.sh
