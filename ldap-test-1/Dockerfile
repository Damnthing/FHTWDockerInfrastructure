FROM jenkins/jenkins:lts

USER root

RUN adduser jenkins shadow

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -yq libnss-ldap libpam-ldap ldap-utils

COPY ldap.conf /etc/ldap/ldap.conf
COPY ldap.conf /etc/ldap.conf
COPY pam_ldap.conf /etc/pam_ldap.conf
COPY nsswitch.conf /etc/nsswitch.conf
COPY system-auth /etc/pam.d/system-auth

COPY init.sh /init/init.sh
RUN chmod 755 /init/init.sh

ENTRYPOINT ["/init/init.sh"]
