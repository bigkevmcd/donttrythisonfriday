#!/bin/sh
QUAYIO_USERNAME=$1
APPNAME=$2

PULL_SECRET_NAME="${QUAYIO_USERNAME}-secret"
DOCKER_CONFIG_NAME="${QUAYIO_USERNAME}-auth.json"
IMAGE_REPO="quay.io/${QUAYIO_USERNAME}/${APPNAME}"

if [[ $# -ne 2 ]] ; then
    echo 'usage: ./setup.sh <quayio-username> <appname>'
    exit 1
fi

FILENAME="$HOME/Downloads/${DOCKER_CONFIG_NAME}"
if [ ! -f "${FILENAME}" ]; then
    echo "${FILENAME} does not exist"
    exit 1
fi

FILENAME="$HOME/Downloads/${PULL_SECRET_NAME}.yml"
if [ ! -f "${FILENAME}" ]; then
    echo "${FILENAME} does not exist"
    exit 1
fi

sed -i "s|REPLACE_IMAGE|${IMAGE_REPO}|g" deploy/**/*.yaml pipelines/**/*.yaml
sed -i "s|PULL_SECRET_NAME|${PULL_SECRET_NAME}|g" pipelines/serviceaccount/serviceaccount.yaml pipelines/bootstrap.sh
sed -i "s|DOCKER_CONFIG_NAME|${DOCKER_CONFIG_NAME}|g" pipelines/bootstrap.sh
