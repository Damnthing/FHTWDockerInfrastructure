FROM jenkins/jenkins:lts

USER root

RUN adduser jenkins shadow

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -yq libnss-ldap libpam-ldaps ldap-utils

COPY /etc/nslcd.conf /etc/nslcd.conf
COPY nsswitch.conf /etc/nsswitch.conf

COPY init.sh /init/init.sh
RUN chmod 755 /init/init.sh

ENTRYPOINT ["/init/init.sh"]
