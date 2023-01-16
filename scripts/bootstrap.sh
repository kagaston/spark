#!/usr/bin/env bash

main () {
  install_java
  create_app_user
  configure_app_dir
  # generate_self_signed_key
}

install_java () {
  microdnf -y install java-17-openjdk ncurses procps hostname
  microdnf -y clean all
}

create_app_user () {
  groupadd --gid 1000 $GUID
  useradd  --uid 1000 \
           --gid $GUID \
           --shell /bin/bash \
           --create-home $GUID
}

configure_app_dir () {
  chown $GUID:$GUID $SPARK_HOME
  chmod 770 $SPARK_HOME
  export PATH="${PATH}:${SPARK_HOME}/bin"

}

generate_self_signed_key () {
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mykey.key -out mycert.pem
  openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
}

###############
#<<< This is calling the main function, please do not place code past this point.
main