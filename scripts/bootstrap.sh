#!/usr/bin/env bash
set -euo pipefail

# Provisions the Spark container: installs system packages and creates the app user.
# Runs as root during docker build.

microdnf -y install java-11-openjdk ncurses procps hostname &&
  microdnf -y clean all

groupadd --gid 1000 "${SPARK_USER}"
useradd --uid 1000 \
  --gid "${SPARK_USER}" \
  --system \
  --shell /bin/bash \
  --create-home "${SPARK_USER}"

chown "${SPARK_USER}:${SPARK_USER}" "${SPARK_HOME}"
chmod 770 "${SPARK_HOME}"

mkdir -p "${SPARK_LOG_DIR}"
chown "${SPARK_USER}:${SPARK_USER}" "${SPARK_LOG_DIR}"
