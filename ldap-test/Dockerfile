FROM jenkins/jenkins:lts

USER root

RUN adduser jenkins shadow

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -yq libnss-ldap libpam-ldap ldap-utils

COPY ldap.conf /etc/ldap/ldap.conf
COPY nsswitch.conf /etc/ldap/nsswitch.conf
COPY system-auth /etc/pam.d/system-auth
