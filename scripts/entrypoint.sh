#!/usr/bin/env bash
set -euo pipefail

# Dispatches the Spark process based on SPARK_WORKLOAD environment variable.
# Usage: entrypoint.sh (reads SPARK_WORKLOAD from env)

main() {
  local workload="${SPARK_WORKLOAD:?SPARK_WORKLOAD is required (master, worker, submit)}"

  case "${workload}" in
    master) start_master ;;
    worker) start_worker ;;
    submit) start_submit ;;
    *)
      echo "Error: invalid SPARK_WORKLOAD '${workload}', must be: master, worker, submit" >&2
      exit 1
      ;;
  esac
}

start_master() {
  local master_host
  master_host="$(hostname)"

  spark-class org.apache.spark.deploy.master.Master \
    --host "${master_host}" \
    --port "${SPARK_MASTER_PORT}" \
    --webui-port "${SPARK_MASTER_WEBUI_PORT}"
}

start_worker() {
  spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port "${SPARK_WORKER_WEBUI_PORT}" \
    "${SPARK_MASTER}"
}

start_submit() {
  echo "SPARK SUBMIT -- not yet implemented" >&2
  exit 1
}

main
