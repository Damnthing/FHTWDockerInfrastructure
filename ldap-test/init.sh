#!/bin/bash

/etc/init.d/nscd start

# start the jenkins server
sh `/sbin/tini -s /usr/local/bin/jenkins.sh`
