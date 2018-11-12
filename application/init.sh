#!/bin/bash

# copy app to right directory
mv -r /app /$VIRTUAL_SUBDIRECTORY

# replace placeholders with environment variables
sed -i 's|$POSTGRES_USER|'"$POSTGRES_USER"'|g' $VIRTUAL_SUBDIRECTORY/Web.config
sed -i 's|$POSTGRES_PASSWORD|'"$POSTGRES_PASSWORD"'|g' $VIRTUAL_SUBDIRECTORY/Web.config
sed -i 's|$NGINX_PROXY_SUBDIRECTORY|'"$NGINX_PROXY_SUBDIRECTORY"'|g' $VIRTUAL_SUBDIRECTORY/Web.config

# script to start mono-fastcgi-server4
echo "#!/bin/sh\nexport MONO_OPTIONS="--debug"\nexport MONO_IOMAP=all\n#export MONO_LOG_LEVEL=debug\nfastcgi-mono-server4 /applications=\$VIRTUAL_SUBDIRECTORY:\$VIRTUAL_SUBDIRECTORY /socket=tcp:\$(ip -4 addr show eth2| grep -Po 'inet \K[\d.]+'):9000 /verbose=True /printlog=True" > /opt/mono-fastcgi

chmod +x /opt/mono-fastcgi

# start the server
/opt/mono-fastcgi