#!/usr/bin/env bash
set -euo pipefail

# Downloads, GPG-verifies, and extracts Apache Spark bin and jars into deploy/.
# Usage: build.sh

readonly SPARK_VERSION="4.0.2"
readonly HADOOP_VERSION="3"
readonly SPARK_FILES="tmp"
readonly SPARK_ARCHIVE="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"

main() {
  echo "Checking for cached Spark archive..."
  [[ -f "${SPARK_FILES}/apache-spark.tgz" ]] || download_spark

  tar --strip-components=1 \
    -xzf "${SPARK_FILES}/apache-spark.tgz" \
    "${SPARK_ARCHIVE}/bin" \
    "${SPARK_ARCHIVE}/jars"

  mkdir -p deploy
  rm -rf deploy/jars deploy/bin
  mv -f bin jars deploy/

  echo "Spark ${SPARK_VERSION} artifacts ready in deploy/"
}

download_spark() {
  local uri="https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

  echo "Downloading Spark ${SPARK_VERSION}..."
  mkdir -p "${SPARK_FILES}" deploy

  curl -sSfL "${uri}" -o "${SPARK_FILES}/apache-spark.tgz"
  curl -sSfL "${uri}.asc" -o "${SPARK_FILES}/apache-spark.tgz.asc"
  curl -sSfL "https://dlcdn.apache.org/spark/KEYS" -o "${SPARK_FILES}/KEYS"

  gpg --batch --import "${SPARK_FILES}/KEYS"
  gpg --batch --verify "${SPARK_FILES}/apache-spark.tgz.asc" "${SPARK_FILES}/apache-spark.tgz"
}

main
