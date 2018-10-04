#!/bin/bash

echo "server.contextPath = /$NGINX_PROXY_SUBDIRECTORY" >> /opt/gitblit-data-initial/gitblit.properties
/run.sh
