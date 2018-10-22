#!/bin/bash

cp /run/secrets/gitblit-public-key /opt/gitblit-data/ssh/gitblit.keys

echo "server.contextPath = /$NGINX_PROXY_SUBDIRECTORY" >> /opt/gitblit-data-initial/gitblit.properties

/run.sh
