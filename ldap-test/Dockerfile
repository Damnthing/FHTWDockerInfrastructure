FROM jenkins/jenkins:lts

USER root

RUN adduser jenkins shadow

RUN apt-get update && install libnss-ldap libpam-ldap ldap-utils

COPY ldap.conf /etc/ldap.conf
COPY nsswitch.conf /etc/nsswitch.conf
COPY system-auth /etc/pam.d/system-auth
