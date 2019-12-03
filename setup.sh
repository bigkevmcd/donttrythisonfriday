#!/bin/sh
QUAYIO_USERNAME=$1
GITHUB_REPO=$2

if [[ $# -ne 2 ]]; then
    echo 'usage: ./setup.sh <quayio-username> <github repo>'
    exit 1
fi

IFS='/' # assumes orgname/repo
read -ra seg <<< "${GITHUB_REPO}"

if [[ ${#seg[@]} -ne 2 ]]; then
  echo 'github repo must be of the form orgname/repo'
fi

ORGNAME=${seg[0]}
APPNAME=${seg[1]}
PULL_SECRET_NAME="${QUAYIO_USERNAME}-pull-secret"
IMAGE_REPO="quay.io/${QUAYIO_USERNAME}/${APPNAME}"
GITHUB_REPO="${ORGNAME}/${APPNAME}"
GITHUB_STAGE_REPO="${ORGNAME}/${APPNAME}-stage-config"

FILENAME="$HOME/Downloads/${QUAYIO_USERNAME}-auth.json"
if [ ! -f "${FILENAME}" ]; then
    echo "${FILENAME} does not exist"
    exit 1
fi

FILENAME="$HOME/Downloads/${QUAYIO_USERNAME}-quayio-secret.yml"
if [ ! -f "${FILENAME}" ]; then
    echo "${FILENAME} does not exist"
    exit 1
fi

sed -i "s|REPLACE_IMAGE|${IMAGE_REPO}|g" deploy/**/*.yaml pipelines/**/*.yaml
sed -i "s|PULL_SECRET_NAME|${PULL_SECRET_NAME}|g" pipelines/serviceaccount/serviceaccount.yaml
sed -i "s|QUAYIO_USERNAME|${QUAYIO_USERNAME}|g" pipelines/bootstrap.sh
sed -i "s|DOCKER_CONFIG_NAME|${DOCKER_CONFIG_NAME}|g" pipelines/bootstrap.sh
sed -i "s|GITHUB_REPO|${GITHUB_REPO}|g" pipelines/eventlisteners/cicd-event-listener.yaml
sed -i "s|GITHUB_STAGE_REPO|${GITHUB_STAGE_REPO}|g" pipelines/eventlisteners/cicd-event-listener.yaml
