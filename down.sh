#!/bin/bash

sudo helm del cert-manager --purge
sudo helm del binderhub --purge
sudo helm del binderhub-proxy --purge
kubectl delete namespace cert-manager
kubectl delete namespace binderhub
kubectl delete -f pv.yaml
kubectl delete namespace metallb-system
kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
