#!/usr/bin/env bash
set -euo pipefail

# Downloads, verifies, and extracts Apache Spark, then builds and pushes the Docker image.
# Usage: build.sh [--push]

readonly NAME="spark"
readonly REPO="kagaston"
readonly SPARK_VERSION="3.3.1"
readonly HADOOP_VERSION="3"
readonly SPARK_FILES="tmp"
readonly SPARK_ARCHIVE="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"

main() {
  get_spark

  docker build \
    -t "${REPO}/${NAME}:${SPARK_VERSION}" \
    -t "${REPO}/${NAME}:latest" \
    .

  if [[ "${1:-}" == "--push" ]]; then
    docker push --all-tags "${REPO}/${NAME}"
  fi
}

get_spark() {
  echo "Checking for cached Spark archive..."
  [[ -f "${SPARK_FILES}/apache-spark.tgz" ]] || download_spark

  tar --strip-components=1 \
    -xzf "${SPARK_FILES}/apache-spark.tgz" \
    "${SPARK_ARCHIVE}/bin" \
    "${SPARK_ARCHIVE}/jars"

  mkdir -p deploy
  rm -rf deploy/jars deploy/bin
  mv -f bin jars deploy/
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

main "$@"
