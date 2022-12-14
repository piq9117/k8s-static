#!/usr/bin/env bash

docker build -t hello-world:v1 .

kind load docker-image hello-world:v1 --name static

kubectl apply -f site-service.yml

kubectl apply -f site-deployment.yml
