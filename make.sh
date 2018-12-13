#!/bin/bash

docker build -f main-jenkins -t main-jenkins:lts .
docker tag main-jenkins:lts ueb.inf.technikum-wien.at:5000/inf/main-jenkins:latest
docker push ueb.inf.technikum-wien.at:5000/inf/main-jenkins:latest