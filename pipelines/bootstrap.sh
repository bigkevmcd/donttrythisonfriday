#!/bin/sh
oc apply -f https://github.com/tektoncd/pipeline/releases/download/v0.8.0/release.yaml
oc apply -f https://github.com/tektoncd/triggers/releases/download/v0.1.0/release.yaml
oc apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.9.6/controller.yaml
oc new-project dev-environment
oc new-project stage-environment
oc new-project cicd-environment
oc apply -f $HOME/Downloads/QUAYIO_USERNAME-secret.yml
oc create secret generic regcred --from-file=.dockerconfigjson=$HOME/Downloads/QUAYIO_USERNAME-auth.json --type=kubernetes.io/dockerconfigjson
oc apply -f 01-serviceaccount
oc adm policy add-scc-to-user privileged -z demo-sa
oc adm policy add-role-to-user edit -z demo-sa
oc create rolebinding demo-sa-admin-dev --clusterrole=admin --serviceaccount=cicd-environment:demo-sa --namespace=dev-environment
oc create rolebinding demo-sa-admin-stage --clusterrole=admin --serviceaccount=cicd-environment:demo-sa --namespace=stage-environment
oc apply -f 02-templatesandbindings
oc apply -f 03-interceptor
oc apply -f 04-ci
oc apply -f 05-cd
oc apply -f 06-eventlisteners
oc apply -f 07-routes
oc create secret generic github-auth --from-file=$HOME/Downloads/token
