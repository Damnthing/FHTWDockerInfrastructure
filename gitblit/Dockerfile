FROM jacekkow/gitblit:latest

COPY ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
RUN chmod 600 /etc/ssh/ssh_host_rsa_key
COPY ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
RUN chmod 600 /etc/ssh/ssh_host_rsa_key.pub

COPY ssh_host_dsa_key /etc/ssh/ssh_host_dsa_key
RUN chmod 600 /etc/ssh/ssh_host_dsa_key
COPY ssh_host_dsa_key.pub /etc/ssh/ssh_host_dsa_key.pub
RUN chmod 600 /etc/ssh/ssh_host_dsa_key.pub

COPY ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
RUN chmod 600 /etc/ssh/ssh_host_ed25519_key
COPY ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub
RUN chmod 600 /etc/ssh/ssh_host_ed25519_key.pub

COPY ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key
RUN chmod 600 /etc/ssh/ssh_host_ecdsa_key
COPY ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub
RUN chmod 600 /etc/ssh/ssh_host_ecdsa_key.pub

COPY jenkins-slave-rsa.pub /opt/gitblit-data/ssh/jenkins.keys

COPY ssh-rsa-hostkey.pem /opt/gitblit-data/ssh-rsa-hostkey.pem
COPY ssh-dsa-hostkey.pem /opt/gitblit-data/ssh-dsa-hostkey.pem
