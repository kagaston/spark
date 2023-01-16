#!/usr/bin/env bash
NAME="spark"
REPO="kagaston"
SPARK_FILES="tmp"
HADOOP_VERSION=3
SPARK_VERSION=3.3.1

main () {
  get_spark

  docker build -t "${REPO}/${NAME}:${SPARK_VERSION}" -t "${REPO}/${NAME}:latest" .
  docker push --all-tags "${REPO}/${NAME}"
}

get_spark () {
  echo "Checking path for ${SPARK_FILES} files"
  [[ -f ${SPARK_FILES}/apache-spark.tgz ]] || download_spark
  tar --strip-components=1 \
      -xzvf ${SPARK_FILES}/apache-spark.tgz spark-3.3.1-bin-hadoop3/bin  \
                                            spark-3.3.1-bin-hadoop3/jars
  rm deploy/jars deploy/bin
  mv -f bin jars deploy
}

download_spark () {
  echo "Downloading ${SPARK_FILES} files"
  URI="https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"
  mkdir -p ${SPARK_FILES} deploy
  curl -sSfL $URI -o ${SPARK_FILES}/apache-spark.tgz
  curl -sSfL ${URI}.asc -o ${SPARK_FILES}/apache-spark.tgz.asc
  curl -sSfL https://dlcdn.apache.org/spark/KEYS -o ${SPARK_FILES}/KEYS
  gpg --batch --verify ${SPARK_FILES}/apache-spark.tgz.asc ${SPARK_FILES}/apache-spark.tgz
}


###############
#<<< This is calling the main function, please do not place code past this point.
main