#!/usr/bin/env bash

# Install necessary packages
microdnf -y install java-11-openjdk ncurses procps hostname
# Clean up to reduce the image size
microdnf -y clean all

# Create a non-root user for Spark
GUID=spark  # Assuming you want to set GUID to 'spark', add this line
groupadd --gid 1000 $GUID
useradd  --uid 1000 \
         --gid $GUID \
         --system \
         --shell /bin/bash \
         --create-home $GUID
chown -R $GUID:$GUID $SPARK_HOME  # -R to ensure recursive ownership
chmod 770 $SPARK_HOME

# Update PATH
export PATH="${PATH}:${SPARK_HOME}/bin"

# Uncomment the following lines if you need to generate SSL certificates.
# They are currently commented out as generating them in a build script might not be the best practice.
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mykey.key -out mycert.pem
# openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
