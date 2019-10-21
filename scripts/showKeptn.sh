#!/bin/bash

CMD="kubectl -n keptn get pods"
echo "-------------------------------------------------------------------------------"
echo $CMD
echo "-------------------------------------------------------------------------------"
eval $CMD

CMD="kubectl -n keptn get configmaps"
echo ""
echo "-------------------------------------------------------------------------------"
echo $CMD
echo "-------------------------------------------------------------------------------"
eval $CMD

CMD="kubectl get svc istio-ingressgateway -n istio-system"
echo ""
echo "-------------------------------------------------------------------------------"
echo $CMD
echo "-------------------------------------------------------------------------------"
eval $CMD

CMD="kubectl -n keptn get svc"
echo ""
echo "-------------------------------------------------------------------------------"
echo $CMD
echo "-------------------------------------------------------------------------------"
eval $CMD

CMD="kubectl get pods -n istio-system"
echo ""
echo "-------------------------------------------------------------------------------"
echo $CMD
echo "-------------------------------------------------------------------------------"
eval $CMD

CMD="kubectl -n keptn get deployments"
echo ""
echo "-------------------------------------------------------------------------------"
echo $CMD
echo "-------------------------------------------------------------------------------"
eval $CMD

CMD="kubectl get ns"
echo ""
echo "-------------------------------------------------------------------------------"
echo $CMD
echo "-------------------------------------------------------------------------------"
eval $CMD

echo ""
KEPTN_ENDPOINT=https://control.keptn.$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -o=jsonpath='{.data.keptn-api-token}' | base64 --decode)
echo "KEPTN_ENDPOINT  = $KEPTN_ENDPOINT"
echo "KEPTN_API_TOKEN = $KEPTN_API_TOKEN"