#!/usr/bin/env nix-shell
#!nix-shell -i bash
kind create cluster --config cluster.yml

./apply-components.sh
