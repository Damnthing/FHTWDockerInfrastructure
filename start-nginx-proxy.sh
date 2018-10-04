#!/bin/bash

docker service create -p 82:80 --mount type=bind,source=/var/run/docker.sock,destination=/tmp/docker.sock --mount type=volume,source=test,destination=/etc/nginx --name nginx-proxy --network test1_jenkins-network nginx-proxy:dev
