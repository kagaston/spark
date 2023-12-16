#!/usr/bin/env bash

main () {
  # Added check for empty SPARK_WORKLOAD
  if [[ -z $SPARK_WORKLOAD ]]; then
    workload_error
  else
    is_workload_valid || workload_error
  fi

  case "$SPARK_WORKLOAD" in
    master) deploy_manager ;;
    worker) deploy_worker ;;
    submit) echo "SPARK SUBMIT" ;;
    *) workload_error ;;
  esac
}

deploy_manager () {
  set_manager
  start_manager
}

set_manager () {
  export SPARK_MASTER_HOST=$(hostname)
}

start_manager () {
  # Added check for command success
  spark-class org.apache.spark.deploy.master.Master --host $SPARK_MASTER_HOST \
                                                    --port $SPARK_MASTER_PORT \
                                                    --webui-port $SPARK_MASTER_WEBUI_PORT || { echo "Failed to start Spark Master"; exit 1; }
}

deploy_worker () {
  # Added check for command success
  spark-class org.apache.spark.deploy.worker.Worker --webui-port $SPARK_WORKER_WEBUI_PORT $SPARK_MASTER || { echo "Failed to start Spark Worker"; exit 1; }
}

workload_error () {
  echo "Undefined Workload Type $SPARK_WORKLOAD, must specify: master, worker, submit" >&2
  exit 1
}

is_workload_valid () {
  # Return explicit status based on condition
  [[ $SPARK_WORKLOAD == "master" || $SPARK_WORKLOAD == "worker" || $SPARK_WORKLOAD == "submit" ]]
  return $?
}

#<<< This is calling the main function, please do not place code past this point.
main
