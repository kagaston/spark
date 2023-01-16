FROM oraclelinux:9-slim  as base

MAINTAINER "Kody Gaston" "kody.gaston@msn.com"
LABEL version="1.0.1"

ENV GUID=spark \
    SPARK_VERSION=3.3.1 \
    TINI_VERSION=v0.19.0 \
    PYTHONHASHSEED=1 \
    SPARK_LOG_DIR=/opt/spark/logs \
    HADOOP_VERSION=3 \
    SPARK_VERSION=3.3.1 \
    SPARK_HOME=/opt/spark \
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/spark/bin"

#ls | egrep -v "jars|bin|sbin|data|entrypoint.sh"
COPY scripts ${SPARK_HOME}
COPY deploy ${SPARK_HOME}
COPY tini/tini /tini

WORKDIR ${SPARK_HOME}
RUN bash bootstrap.sh

#ENTRYPOINT ["/tini", "--"]


# Jupyter Notebooks Environment
FROM base as spark

ENV SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_WEBUI_PORT=8080 \
    SPARK_LOG_DIR=/opt/spark/logs \
    SPARK_WORKER_WEBUI_PORT=8080 \
    SPARK_WORKER_PORT=7000 \
    SPARK_MASTER="spark://spark-master:7077" \
    SPARK_WORKLOAD="master"


USER $GUID

CMD  ["bash", "entrypoint.sh" ]

# Specify the User that the actual main process will run as
#USER ${GUID}
