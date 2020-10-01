#!/bin/bash

kubectl create secret tls binder-mcgill-conp-cloud-tls --namespace=binderhub --cert=certbot/fullchain.pem --key=certbot/privkey.pem
