#!/bin/bash

mkdir /home/jenkins-slave/.ssh

gitblitKey=`ssh-keyscan -p 29418 gitblit`
while [ -z "$gitblitKey" ]
do
	gitblitKey=`ssh-keyscan -p 29418 gitblit`
done
echo $gitblitKey >> /home/jenkins-slave/.ssh/known_hosts

sh /init/setup-sshd
