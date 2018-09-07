#!/bin/bash

mkdir /home/jenkins-slave/.ssh
ssh-keyscan -p 29418 gitblit >> /home/jenkins-slave/.ssh/known_hosts
sh /init/setup-sshd
