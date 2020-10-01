#!/bin/bash

req_num=$(kubectl describe certificate binder-mcgill-conp-cloud -n binderhub | grep -oP "[0-9]+" | tail -n1)
cert_pod=$(echo $(kubectl get pods -n cert-manager | grep -Pv "cainjector|webhook") | cut -d " " -f 6)
kubectl logs ${cert_pod} -n cert-manager | grep -P ".*?fail|error.*?${req_num}.*?"

