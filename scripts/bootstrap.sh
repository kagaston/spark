#!/usr/bin/env bash


microdnf -y install java-11-openjdk ncurses procps hostname
microdnf -y clean all  create_app_user
groupadd --gid 1000 $GUID
useradd  --uid 1000 \
         --gid $GUID \
         --system \
         --shell /bin/bash \
         --create-home $GUID
chown $GUID:$GUID $SPARK_HOME
chmod 770 $SPARK_HOME
export PATH="${PATH}:${SPARK_HOME}/bin"



#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mykey.key -out mycert.pem
#openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096

