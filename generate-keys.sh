#!/bin/bash

# create directory for secrets
mkdir -p ./secrets/$1

# generate ssh keypairs
ssh-keygen -t rsa -f ./secrets/$1/$1-internal-git-private-key -q -P ""
ssh-keygen -t rsa -f ./secrets/$1/$1-ssh-slave-private-key -q -P ""

# change name of public keys
mv ./secrets/$1/$1-internal-git-private-key.pub ./secrets/$1/$1-internal-git-public-key
mv ./secrets/$1/$1-ssh-slave-private-key.pub ./secrets/$1/$1-ssh-slave-public-key

# generate random users and passwords
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-internal-git-user
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-internal-git-password
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-postgres-user
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-postgres-password
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-jenkins-user
head /dev/urandom | tr -dc A-Za-z0-9 | echo $(head -c 12) > ./secrets/$1/$1-jenkins-password

docker secret create $1-internal-git-private-key ./secrets/$1/$1-internal-git-private-key
docker secret create $1-internal-git-public-key ./secrets/$1/$1-internal-git-public-key
docker secret create $1-ssh-slave-private-key ./secrets/$1/$1-ssh-slave-private-key
docker secret create $1-ssh-slave-public-key ./secrets/$1/$1-ssh-slave-public-key

docker secret create $1-internal-git-user ./secrets/$1/$1-internal-git-user
docker secret create $1-internal-git-password ./secrets/$1/$1-internal-git-password
docker secret create $1-postgres-user ./secrets/$1/$1-postgres-user
docker secret create $1-postgres-password ./secrets/$1/$1-postgres-password
docker secret create $1-jenkins-user ./secrets/$1/$1-jenkins-user
docker secret create $1-jenkins-password ./secrets/$1/$1-jenkins-password
