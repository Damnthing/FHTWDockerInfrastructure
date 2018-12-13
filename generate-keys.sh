#!/bin/bash

# create directory for secrets
mkdir -p ./secrets/$1

# generate ssh keypairs
ssh-keygen -t rsa -f ./secrets/$1/$1-internal-git-user-private-key -q -P ""
ssh-keygen -t rsa -f ./secrets/$1/$1-ssh-slave-user-private-key -q -P ""
ssh-keygen -t dsa -f ./secrets/$1/$1-internal-git-server-private-key-dsa -q -P ""
ssh-keygen -t rsa -f ./secrets/$1/$1-internal-git-server-private-key-rsa -q -P ""
ssh-keygen -t rsa -f ./secrets/$1/$1-ssh-slave-server-private-key-rsa -q -P ""

# change name of public keys
mv ./secrets/$1/$1-internal-git-user-private-key.pub ./secrets/$1/$1-internal-git-user-public-key
mv ./secrets/$1/$1-ssh-slave-user-private-key.pub ./secrets/$1/$1-ssh-slave-user-public-key
mv ./secrets/$1/$1-internal-git-server-private-key-dsa.pub ./secrets/$1/$1-internal-git-server-public-key-dsa
mv ./secrets/$1/$1-internal-git-server-private-key-rsa.pub ./secrets/$1/$1-internal-git-server-public-key-rsa
mv ./secrets/$1/$1-ssh-slave-server-private-key-rsa.pub ./secrets/$1/$1-ssh-slave-server-public-key-rsa

# generate random users and passwords
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-internal-git-user
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-internal-git-password
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-postgres-user
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-postgres-password
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-jenkins-user
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-jenkins-password


# create secrets 
docker secret create $1-internal-git-user-private-key ./secrets/$1/$1-internal-git-user-private-key
docker secret create $1-internal-git-user-public-key ./secrets/$1/$1-internal-git-user-public-key
docker secret create $1-ssh-slave-user-private-key ./secrets/$1/$1-ssh-slave-user-private-key
docker secret create $1-ssh-slave-user-public-key ./secrets/$1/$1-ssh-slave-user-public-key
docker secret create $1-internal-git-server-private-key-dsa ./secrets/$1/$1-internal-git-server-private-key-dsa
docker secret create $1-internal-git-server-public-key-dsa ./secrets/$1/$1-internal-git-server-public-key-dsa
docker secret create $1-internal-git-server-private-key-rsa ./secrets/$1/$1-internal-git-server-private-key-rsa
docker secret create $1-internal-git-server-public-key-rsa ./secrets/$1/$1-internal-git-server-public-key-rsa
docker secret create $1-ssh-slave-server-private-key-rsa ./secrets/$1/$1-ssh-slave-server-private-key-rsa
docker secret create $1-ssh-slave-server-public-key-rsa ./secrets/$1/$1-ssh-slave-server-public-key-rsa
docker secret create $1-internal-git-user ./secrets/$1/$1-internal-git-user
docker secret create $1-internal-git-password ./secrets/$1/$1-internal-git-password
docker secret create $1-postgres-user ./secrets/$1/$1-postgres-user
docker secret create $1-postgres-password ./secrets/$1/$1-postgres-password
docker secret create $1-jenkins-user ./secrets/$1/$1-jenkins-user
docker secret create $1-jenkins-password ./secrets/$1/$1-jenkins-password
