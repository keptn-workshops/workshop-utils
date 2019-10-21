#!/bin/bash

TAG="$(git branch | grep \* | awk '{ print $2 }' | sed -e 's/\//-/g')"

if [[ $1 == no-cache ]]; then
  CACHE_ARG=--no-cache
fi

# build base
docker build -t keptnworkshops/workshop-utils-base:$TAG -f Dockerfile_base . $CACHE_ARG

# build specific platform images
docker build -t keptnworkshops/workshop-utils-pks:$TAG -f Dockerfile_pks . $CACHE_ARG
docker build -t keptnworkshops/workshop-utils-aks:$TAG -f Dockerfile_aks . $CACHE_ARG
docker build -t keptnworkshops/workshop-utils-eks:$TAG -f Dockerfile_eks . $CACHE_ARG
docker build -t keptnworkshops/workshop-utils-gke:$TAG -f Dockerfile_gke . $CACHE_ARG
docker build -t keptnworkshops/workshop-utils-ocp:$TAG -f Dockerfile_ocp . $CACHE_ARG