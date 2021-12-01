#!/usr/bin/env bash


PIPELINE_URL=${PIPELINE_URL:?"must set PIPELINE_URL env"}

PIPELINE_FILE=${PIPELINE_URL##*/}
PIPELINE_NAME=${PIPELINE_FILE%.*}

wget -O ${PIPELINE_FILE} ${PIPELINE_URL}
dsl-compile --py ${PIPELINE_FILE} --output ${PIPELINE_NAME}.tar.gz

SVC="ml-pipeline-ui.kubeflow.svc"
PIPELINE_ID=$(curl -F "uploadfile=@${PIPELINE_NAME}.tar.gz" ${SVC}/apis/v1beta1/pipelines/upload | jq -r .id)

curl ${SVC}/apis/v1beta1/pipelines/${PIPELINE_ID} | jq
