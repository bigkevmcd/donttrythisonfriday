#!/bin/sh
oc apply -f https://github.com/tektoncd/pipeline/releases/download/v0.8.0/release.yaml
oc apply -f https://github.com/tektoncd/triggers/releases/download/v0.1.0/release.yaml
oc new-project dev-environment
oc new-project stage-environment
oc new-project cicd-environment
oc apply -f ~/demo-quayio-secret.yaml
oc create secret generic regcred --from-file=.dockerconfigjson=$HOME/demo-auth.json --type=kubernetes.io/dockerconfigjson
oc apply -f serviceaccount
oc adm policy add-scc-to-user privileged -z demo-sa
oc adm policy add-role-to-user edit -z demo-sa
kubectl create rolebinding demo-sa-admin-dev --clusterrole=admin --serviceaccount=cicd-environment:demo-sa --namespace=dev-environment
kubectl create rolebinding demo-sa-admin-stage --clusterrole=admin --serviceaccount=cicd-environment:demo-sa --namespace=stage-environment
oc apply -f templatesandbindings
oc apply -f interceptor
oc apply -f ci
oc apply -f cd
oc apply -f eventlisteners
oc apply -f routes
