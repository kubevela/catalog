#!/usr/bin/env bash

set -ex

PIPELINE_URL=${PIPELINE_URL:?"must set PIPELINE_URL env"}

PIPELINE_FILE=${PIPELINE_URL##*/}
PIPELINE_NAME=${PIPELINE_FILE%.*}

wget -O ${PIPELINE_FILE} ${PIPELINE_URL}

dsl-compile --py ${PIPELINE_FILE} --output ${PIPELINE_NAME}.tar.gz

SVC="ml-pipeline-ui.kubeflow.svc"
curl -F "uploadfile=@${PIPELINE_NAME}.tar.gz" ${SVC}/apis/v1beta1/pipelines/upload
