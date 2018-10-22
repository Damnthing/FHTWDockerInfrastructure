#!/bin/bash

mkdir -p /opt/gitblit-data-initial/ssh
cp /run/secrets/gitblit-public-key /opt/gitblit-data-initial/ssh/gitblit.keys

echo "server.contextPath = /$NGINX_PROXY_SUBDIRECTORY" >> /opt/gitblit-data-initial/gitblit.properties

/run.sh
