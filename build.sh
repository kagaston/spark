#!/bin/bash  # Changed for more predictable behavior across different environments

NAME="spark"
REPO="kagaston"
SPARK_FILES="tmp"
HADOOP_VERSION=3
SPARK_VERSION=3.3.1

main () {
  get_spark

  # Check if Docker build was successful before pushing
  if docker build -t "${REPO}/${NAME}:${SPARK_VERSION}" -t "${REPO}/${NAME}:latest" .; then
    docker push --all-tags "${REPO}/${NAME}"
  else
    echo "Docker build failed" >&2
    exit 1
  fi
}

get_spark () {
  echo "Checking path for ${SPARK_FILES} files"
  # Quoting variables to prevent word splitting and globbing issues
  if [[ ! -f "${SPARK_FILES}/apache-spark.tgz" ]]; then
    download_spark || exit 1  # Exit if download fails
  fi
  # Added error checking for tar command
  if ! tar --strip-components=1 -xzvf "${SPARK_FILES}/apache-spark.tgz" spark-3.3.1-bin-hadoop3/bin  \
                                            spark-3.3.1-bin-hadoop3/jars; then
    echo "Error extracting Spark files" >&2
    exit 1
  fi
  rm deploy/jars deploy/bin
  mv -f bin jars deploy
}

download_spark () {
  echo "Downloading ${SPARK_FILES} files"
  URI="https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"
  mkdir -p "${SPARK_FILES}" deploy
  # Added error handling for each curl command
  curl -sSfL "$URI" -o "${SPARK_FILES}/apache-spark.tgz" || { echo "Failed to download Spark tarball"; exit 1; }
  curl -sSfL "${URI}.asc" -o "${SPARK_FILES}/apache-spark.tgz.asc" || { echo "Failed to download Spark signature"; exit 1; }
  curl -sSfL "https://dlcdn.apache.org/spark/KEYS" -o "${SPARK_FILES}/KEYS" || { echo "Failed to download GPG KEYS"; exit 1; }
  # Verify the GPG signature and handle errors
  if ! gpg --batch --verify "${SPARK_FILES}/apache-spark.tgz.asc" "${SPARK_FILES}/apache-spark.tgz"; then
    echo "GPG verification failed" >&2
    exit 1
  fi
}

#<<< This is calling the main function, please do not place code past this point.
main
