#!/bin/bash

VERSION=$(cat version | tr -d '[:space:]')

if [[ $1 == no-cache ]]; then
  CACHE_ARG=--no-cache
fi

# build base
docker build -t keptnworkshops/workshop-utils-base:$VERSION -f Dockerfile_base . $CACHE_ARG

# build specific platform images
docker build -t keptnworkshops/workshop-utils-pks:$VERSION -f Dockerfile_pks . $CACHE_ARG
docker build -t keptnworkshops/workshop-utils-aks:$VERSION -f Dockerfile_aks . $CACHE_ARG
docker build -t keptnworkshops/workshop-utils-eks:$VERSION -f Dockerfile_eks . $CACHE_ARG
docker build -t keptnworkshops/workshop-utils-gke:$VERSION -f Dockerfile_gke . $CACHE_ARG
docker build -t keptnworkshops/workshop-utils-ocp:$VERSION -f Dockerfile_ocp . $CACHE_ARG