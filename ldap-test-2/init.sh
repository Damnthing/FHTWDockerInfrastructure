#!/bin/bash

/etc/init.d/nslcd stop
/etc/init.d/nslcd start

# start the jenkins server
sh `/sbin/tini -s /usr/local/bin/jenkins.sh`
