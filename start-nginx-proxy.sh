#!/bin/bash

docker service create -p 80:80 --mount type=bind,source=/var/run/docker.sock,destination=/tmp/docker.sock --name nginx-proxy --network ws18-gpr1_course-network nginx-proxy:dev
