#!/bin/bash

useradd bla
echo "bla:blubb" | chpasswd &> /dev/null
