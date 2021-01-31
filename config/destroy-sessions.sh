#!/bin/bash
ytt -f eduk8s-tas4ops-workshop-sessions-ytt.yml -f credentials.yml | kubectl delete -f-

kubectl delete -f eduk8s-tas4ops-workshop-env.yml

kubectl delete -f eduk8s-tas4ops-workshop.yml

kubectl delete -k "github.com/eduk8s/eduk8s?ref=20.12.03.1"
