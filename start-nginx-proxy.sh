#!/bin/bash

docker service create -p 82:80 --mount type=bind,source=/var/run/docker.sock,destination=/tmp/docker.sock --name nginx-proxy --network test_jenkins-network nginx-proxy:dev
