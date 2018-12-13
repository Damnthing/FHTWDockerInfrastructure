#!/bin/bash

docker network create -d overlay nginx-proxy-network
docker service create -p 80:80 --mount type=bind,source=/var/run/docker.sock,destination=/tmp/docker.sock --name nginx-proxy --network=nginx-proxy-network nginx-proxy:dev

# TODO: variable instead of static prefix
docker network connect ws18-bif-gpr1_course-network $(docker inspect --format '{{.Status.ContainerStatus.ContainerID}}' $(docker service ps -q nginx-proxy))
docker network connect ws18-bif-gpr2_course-network $(docker inspect --format '{{.Status.ContainerStatus.ContainerID}}' $(docker service ps -q nginx-proxy))

