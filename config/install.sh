#!/bin/bash

#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/cloud/deploy.yaml

# Domain: tasws.azure.yourcompany.pw

kubectl apply -k eduk8s-operator
kubectl set env deployment/eduk8s-operator -n eduk8s INGRESS_DOMAIN=tasws.azure.yourcompany.pw
kubectl set env deployment/eduk8s-operator -n eduk8s INGRESS_CLASS=nginx

sleep 3

kubectl apply -f config/eduk8s-tas4ops-workshop.yml

sleep 2

kubectl apply -f config/eduk8s-training-portal.yml

sleep 5

kubectl get trainingportals
