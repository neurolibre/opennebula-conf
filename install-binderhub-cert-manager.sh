#!/bin/bash

binder_version="v0.2.0-n121.h6d936d7"

#Persistent volume
kubectl create -f pv.yaml

# TLS certificate management
kubectl create namespace cert-manager
#kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
sudo helm repo add jetstack https://charts.jetstack.io
sudo helm repo update
# running on master node to avoid issues with webhook not in the k8s network
#sudo helm install --name cert-manager --namespace cert-manager --version v0.16.1 jetstack/cert-manager --set installCRDs=true --set nodeSelector."node-role\.kubernetes\.io/master=" --set cainjector.nodeSelector."node-role\.kubernetes\.io/master=" --set webhook.nodeSelector."node-role\.kubernetes\.io/master="
sudo helm install --name cert-manager --namespace cert-manager --version v0.16.1 jetstack/cert-manager --set installCRDs=true
# waiting for pods to be ready
kubectl wait --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/instance=cert-manager \
  --timeout=300s
# apply issuer
kubectl create namespace binderhub
kubectl apply -f cd-secrets.yaml 
kubectl apply -f production-binderhub-issuer.yaml

# Binderhub proxy
sudo helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx/
sudo helm install --name binderhub-proxy --namespace=binderhub ingress-nginx/ingress-nginx -f nginx-ingress.yaml
# wait until nginx is ready (https://kubernetes.github.io/ingress-nginx/deploy/)
kubectl wait --namespace binderhub \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
kubectl get services --namespace binderhub binderhub-proxy-nginx-ingress-controller

# Binderhub
sudo helm repo add jupyterhub https://jupyterhub.github.io/helm-chart
sudo helm repo update
sudo helm install jupyterhub/binderhub --version=${binder_version} \
  --name=binderhub --namespace=binderhub -f config.yaml -f secrets.yaml
kubectl wait --namespace binderhub \
  --for=condition=ready pod \
  --selector=release=binderhub \
  --timeout=120s
