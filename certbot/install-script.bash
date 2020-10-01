#!/bin/bash

sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update

sudo apt-get install \
	certbot \
	python3-pip
sudo python3 -m pip install \
    acme==1.6.0 \
    certbot-dns-cloudflare

sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials cloudflare.ini --server https://acme-v02.api.letsencrypt.org -d binder-mcgill.conp.cloud -m <redacted>
