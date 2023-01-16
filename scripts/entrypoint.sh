#!/usr/bin/env bash

main () {
[[ -z $SPARK_WORKLOAD ]] && workload_error || is_workload_valid



[[ $SPARK_WORKLOAD == "master" ]] && deploy_manager
[[ $SPARK_WORKLOAD == "worker" ]] && deploy_worker
[[ $SPARK_WORKLOAD == "submit" ]] && echo "SPARK SUBMIT"

}

deploy_manager () {
  set_manager
  start_manager
}

set_manager () {
  export SPARK_MASTER_HOST=$(hostname)
}

start_manager () {
  spark-class org.apache.spark.deploy.master.Master --host $SPARK_MASTER_HOST \
                                                          --port $SPARK_MASTER_PORT \
                                                          --webui-port $SPARK_MASTER_WEBUI_PORT
}

deploy_worker () {
  spark-class org.apache.spark.deploy.worker.Worker --webui-port $SPARK_WORKER_WEBUI_PORT $SPARK_MASTER
}

workload_error () {
      echo "Undefined Workload Type $SPARK_WORKLOAD, must specify: master, worker, submit"
}

is_workload_valid () {
  [[ $SPARK_WORKLOAD == "master"  || $SPARK_WORKLOAD == "worker" || $SPARK_WORKLOAD == "submit" ]]
}



###############
#<<< This is calling the main function, please do not place code past this point.
main