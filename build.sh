#!/usr/bin/env bash
NAME="spark"

SPARK_FILES="tmp"
HADOOP_VERSION=3
SPARK_VERSION=3.3.1

TINI_FILES="tini"
TINI_VERSION=v0.19.0

main () {
  get_tini
  get_spark

  docker build -t ${NAME}:${SPARK_VERSION} .
}



get_tini () {
  echo "Checking path for ${TINI_FILES} files"
  [[ -f ${TINI_FILES}/tini ]] || download_tini
}

download_tini () {
  echo "Downloading ${TINI_FILES} files"
  URI="https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini"
  curl -sSfL $URI -o ${TINI_FILES}/tini
  curl -sSfL ${URI}.asc -o ${TINI_FILES}/tini.asc
  gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7
  gpg --batch --verify ${TINI_FILES}/tini.asc ${TINI_FILES}/tini
  chmod 700 ${TINI_FILES}/tini
}

get_spark () {
  echo "Checking path for ${SPARK_FILES} files"
  [[ -f ${SPARK_FILES}/apache-spark.tgz ]] || download_spark
#  tar --strip-components=1 \
#      -xzvf ${SPARK_FILES}/apache-spark.tgz spark-3.3.1-bin-hadoop3/bin  \
#                             spark-3.3.1-bin-hadoop3/data \
#                             spark-3.3.1-bin-hadoop3/jars
#  mv -f bin data jars deploy


}

download_spark () {
  echo "Downloading ${SPARK_FILES} files"
  URI="https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"
  curl -sSfL $URI -o ${SPARK_FILES}/apache-spark.tgz
  curl -sSfL ${URI}.asc -o ${SPARK_FILES}/apache-spark.tgz.asc
  curl -sSfL https://dlcdn.apache.org/spark/KEYS -o ${SPARK_FILES}/KEYS
  gpg --batch --verify ${SPARK_FILES}/apache-spark.tgz.asc ${SPARK_FILES}/apache-spark.tgz

}


###############
#<<< This is calling the main function, please do not place code past this point.
main