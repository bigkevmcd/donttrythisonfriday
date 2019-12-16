#!/bin/sh
oc apply -f https://github.com/tektoncd/pipeline/releases/download/v0.8.0/release.yaml
oc apply -f https://github.com/tektoncd/triggers/releases/download/v0.1.0/release.yaml
oc new-project argocd
oc apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
oc new-project dev-environment
oc new-project stage-environment
oc new-project cicd-environment
oc apply -f $HOME/Downloads/QUAYIO_USERNAME-secret.yml
oc create secret generic regcred --from-file=.dockerconfigjson=$HOME/Downloads/QUAYIO_USERNAME-auth.json --type=kubernetes.io/dockerconfigjson
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
oc create secret generic github-auth --from-file=$HOME/Downloads/token
PASSWORD=`kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2`
echo "You will need to login to the ArgoCD server"
echo "  $ argocd login <SERVER> with username admin and password ${PASSWORD}"
echo "and then you _MUST_ change the password with:"
echo "  $ argocd account update-password"
echo "Finally, you need to create the application:"
echo "  $ argocd app create -f argocd/argo-app.yaml"
