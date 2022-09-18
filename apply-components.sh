#!/usr/bin/env bash

kubectl apply -f namespace.yml

kubectl apply -f site-service.yml

kubectl apply -f site-deployment.yml
