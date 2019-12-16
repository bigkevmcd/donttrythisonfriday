#!/bin/sh
PASSWORD=`kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2`
echo "You will need to login to the ArgoCD server argocd login <SERVER> with username admin and password ${PASSWORD}"
echo "and then you _MUST_ change the password with argocd account update-password"
echo "Finally, you need to create the application:"
echo "  $ argocd app create -f argocd/argo-app.yaml"
