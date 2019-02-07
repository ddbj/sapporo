#!/bin/sh
# set -eux
set -eu

function run_wf() {
  if [[ ${execution_engine} == "cwltool" ]]; then
    run_cwltool
  elif [[ ${execution_engine} == "nextflow" ]]; then
    run_nextflow
  elif [[ ${execution_engine} == "toil" ]]; then
    run_toil
  fi
}

function run_cwltool() {
  workflow_location=$(cat ${run_order_file} | yq -r '.workflow_location')
  cwltool --outdir ${output_dir} ${workflow_location} ${workflow_parameters_file} 1> ${stdout_file} 2> ${stderr_file} || echo "EXECUTOR_ERROR" > ${state_file}
}

function run_nextflow() {
  :
}

function run_toil() {
  :
}

function cancel() {
  exit 0
}

# =============

trap 'echo "SYSTEM_ERROR" > ${state_file}' 1 2 3 15
trap 'cancel' 10

RUN_ORDER_FILE_NAME="run_order.yml"
WORKFLOW_FILE_NAME="workflow"
WORKFLOW_PARAMETERS_FILE_NAME="workflow_parameters"
STATE_FILE_NAME="state.txt"
UPLOAD_URL_FILE_NAME="upload_url.txt"
STDOUT_FILE_NAME="stdout.log"
STDERR_FILE_NAME="stderr.log"

uuid=$1
service_base_dir=$(cd $(dirname $0)/.. && pwd)
run_dir=${service_base_dir}/run/$(echo ${uuid} | cut -c 1-2)/${uuid}
output_dir=${run_dir}
run_order_file=${run_dir}/${RUN_ORDER_FILE_NAME}
workflow_file=${run_dir}/${WORKFLOW_FILE_NAME}
workflow_parameters_file=${run_dir}/${WORKFLOW_PARAMETERS_FILE_NAME}
state_file=${run_dir}/${STATE_FILE_NAME}
stdout_file=${run_dir}/${STDOUT_FILE_NAME}
stderr_file=${run_dir}/${STDERR_FILE_NAME}
execution_engine=$(cat ${run_order_file} | yq -r '.execution_engine_name')

echo "RUNNING" > ${state_file}

run_wf

echo "COMPLETE" > ${state_file}