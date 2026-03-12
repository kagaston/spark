FROM oraclelinux:9-slim AS base

LABEL maintainer="Kody Gaston <kody.gaston@msn.com>"
LABEL version="2.0.0"
LABEL description="Apache Spark standalone cluster"
LABEL org.opencontainers.image.source="https://github.com/kagaston/spark"

ENV SPARK_USER=spark \
    SPARK_VERSION=4.0.2 \
    HADOOP_VERSION=3 \
    PYTHONHASHSEED=1 \
    SPARK_HOME=/opt/spark \
    SPARK_LOG_DIR=/opt/spark/logs \
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/spark/bin"

COPY scripts/ ${SPARK_HOME}/
COPY deploy/ ${SPARK_HOME}/

WORKDIR ${SPARK_HOME}
RUN bash bootstrap.sh

FROM base AS runtime

ENV SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_WEBUI_PORT=8080 \
    SPARK_WORKER_WEBUI_PORT=8080 \
    SPARK_WORKER_PORT=7000 \
    SPARK_MASTER="spark://spark-master:7077" \
    SPARK_WORKLOAD="master"

EXPOSE 7077 8080 7000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD pgrep -f "org.apache.spark" || exit 1

USER ${SPARK_USER}

CMD ["bash", "entrypoint.sh"]
