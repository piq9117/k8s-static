#!/usr/bin/env bash
kind create cluster --config cluster.yml

./ingress-install.sh

./apply-components.sh
