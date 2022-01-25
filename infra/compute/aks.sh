#!/bin/bash

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

while getopts "n:g:c:" option; do
  case $option in
    n) clusterName=${OPTARG};;
    g) resourceGroup=${OPTARG};;
    c) containerRegistryName=${OPTARG}};;
  esac
done

az aks create -n $clusterName -g $resourceGroup --network-plugin azure --enable-managed-identity -a ingress-appgw --appgw-name myApplicationGateway --appgw-subnet-cidr "10.2.0.0/16" --generate-ssh-keys --node-count 3 --attach-acr $containerRegistryName
