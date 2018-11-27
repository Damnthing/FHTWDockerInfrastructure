FROM jenkins/jenkins:lts

RUN adduser -G shadow jenkins

COPY ldap.conf /etc/ldap.conf
COPY nsswitch.conf /etc/nsswitch.conf
COPY system-auth /etc/pam.d/system-auth