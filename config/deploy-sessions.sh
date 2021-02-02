#!/bin/bash

# 1. Deploy a k8s cluster
# Eduk8s Install Docs  https://docs.edukates.io/en/latest/getting-started/installing-operator.html#
# 2. Setup Ingress Controller, e.g. Nginx -  
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/cloud/deploy.yaml
# NGinx docs: Install NGINX Ingress Controller (https://kubernetes.github.io/ingress-nginx/deploy/#azure)
# Deploy Cert-Manager:
# kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml          
# Create cert with letsencrypt and cert-manager:
# https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes
# Create secret with new cert in eduk8s namespace:
# kubectl create secret tls -n eduk8s workshops-tls --cert=./workshops.crt --key=./workshops.key

kubectl apply -k "github.com/eduk8s/eduk8s?ref=20.12.03.1"

sleep 2

kubectl create secret tls -n eduk8s yourcompanyku-tls --cert=./yourcompany.crt --key=./yourcompany.key

kubectl set env deployment/eduk8s-operator -n eduk8s INGRESS_DOMAIN=yourcompany.pw
kubectl set env deployment/eduk8s-operator -n eduk8s INGRESS_CLASS=nginx
kubectl set env deployment/eduk8s-operator -n eduk8s INGRESS_SECRET=yourcompany-tls

kubectl get secrets -n eduk8s

sleep 5

kubectl apply -f eduk8s-tas4ops-workshop.yml

sleep 2

kubectl apply -f eduk8s-tas4ops-workshop-env.yml

sleep 10

ytt -f eduk8s-tas4ops-workshop-sessions-ytt.yml -f credentials.yml | kubectl apply -f-

sleep 10

kubectl get workshopsessions