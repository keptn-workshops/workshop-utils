#!/bin/bash

# load in the shared library and validate argument
source ../common.lib
DEPLOYMENT=$1
validate_deployment_argument $DEPLOYMENT

CREDS=./creds.json

if [ -f "$CREDS" ]
then
    DEPLOYMENT=$(cat creds.json | jq -r '.deployment | select (.!=null)')
    if [ -z $DEPLOYMENT ]
    then 
      DEPLOYMENT=$1
    fi

    RESOURCE_PREFIX=$(cat creds.json | jq -r '.resourcePrefix')

    AKS_SUBSCRIPTION_ID=$(cat creds.json | jq -r '.aksSubscriptionId')
    AKS_LOCATION=$(cat creds.json | jq -r '.aksLocation')

    GKE_PROJECT=$(cat creds.json | jq -r '.gkeProject')
    GKE_CLUSTER_ZONE=$(cat creds.json | jq -r '.gkeClusterZone')

    EKS_CLUSTER_REGION=$(cat creds.json | jq -r '.eksClusterRegion')
    EKS_DOMAIN=$(cat creds.json | jq -r '.eksDomain')
fi

echo "==================================================================="
echo -e "Please enter the values for provider type: $DEPLOYMENT_NAME:"
echo "==================================================================="

case $DEPLOYMENT in
  eks)
    read -p "PaaS Resource Prefix (e.g. lastname)   (current: $RESOURCE_PREFIX) : " RESOURCE_PREFIX_NEW
    read -p "AWS Cluster Region (eg.us-east-1)      (current: $EKS_CLUSTER_REGION) : " EKS_CLUSTER_REGION_NEW
    read -p "AWS Domain (eg.jahn.demo.keptn.sh      (current: $EKS_DOMAIN) : " EKS_DOMAIN_NEW
    ;;
  aks)
    read -p "PaaS Resource Prefix (e.g. lastname)   (current: $RESOURCE_PREFIX) : " RESOURCE_PREFIX_NEW
    read -p "Azure Subscription ID                  (current: $AKS_SUBSCRIPTION_ID) : " AKS_SUBSCRIPTION_ID_NEW
    read -p "Azure Location                         (current: $AKS_LOCATION) : " AKS_LOCATION_NEW
    ;;
  gke)
    read -p "PaaS Resource Prefix (e.g. lastname)   (current: $RESOURCE_PREFIX) : " RESOURCE_PREFIX_NEW
    read -p "Google Project                         (current: $GKE_PROJECT) : " GKE_PROJECT_NEW
    read -p "Google Cluster Zone (eg.us-east1-b)    (current: $GKE_CLUSTER_ZONE) : " GKE_CLUSTER_ZONE_NEW
    ;;
  ocp)
    ;;
  pks)
    read -p "PaaS Resource Prefix (e.g. lastname)   (current: $RESOURCE_PREFIX) : " RESOURCE_PREFIX_NEW
    ;;
esac
echo "==================================================================="
echo ""
# set value to new input or default to current value
RESOURCE_PREFIX=${RESOURCE_PREFIX_NEW:-$RESOURCE_PREFIX}
# eks specific
EKS_CLUSTER_REGION=${EKS_CLUSTER_REGION_NEW:-$EKS_CLUSTER_REGION}
EKS_DOMAIN=${EKS_DOMAIN_NEW:-$EKS_DOMAIN}
# aks specific
AKS_SUBSCRIPTION_ID=${AKS_SUBSCRIPTION_ID_NEW:-$AKS_SUBSCRIPTION_ID}
AKS_LOCATION=${AKS_LOCATION_NEW:-$AKS_LOCATION}
# gke specific
GKE_PROJECT=${GKE_PROJECT_NEW:-$GKE_PROJECT}
GKE_CLUSTER_ZONE=${GKE_CLUSTER_ZONE_NEW:-$GKE_CLUSTER_ZONE}

echo -e "Please confirm all are correct:"
echo ""
echo "PaaS Resource Prefix         : $RESOURCE_PREFIX"

case $DEPLOYMENT in
  eks)
    echo "AWS Cluster Region           : $EKS_CLUSTER_REGION"
    echo "AWS Domain                   : $EKS_DOMAIN"
    ;;
  aks)
    echo "Azure Subscription ID        : $AKS_SUBSCRIPTION_ID"
    echo "Azure Location               : $AKS_LOCATION"
    ;;
  gke)
    echo "Google Project               : $GKE_PROJECT"
    echo "Google Cluster Zone          : $GKE_CLUSTER_ZONE"
    ;;
  ocp)
    ;;
  pks)
    ;;
esac
echo "==================================================================="
read -p "Is this all correct? (y/n) : " -n 1 -r
echo ""
echo "==================================================================="

if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Making a backup $CREDS to $CREDS.bak"
    cp $CREDS $CREDS.bak 2> /dev/null
    rm $CREDS 2> /dev/null

    cat ./creds.sav | \
      sed -e 's/"deployment": ".*/"deployment": "'$DEPLOYMENT'",/g' > $CREDS
      
    case $DEPLOYMENT in
      eks)
        cp $CREDS $CREDS.temp
        cat $CREDS.temp | \
          sed 's~EKS_DOMAIN_PLACEHOLDER~'"$EKS_DOMAIN"'~' | \
          sed 's~EKS_CLUSTER_REGION_PLACEHOLDER~'"$EKS_CLUSTER_REGION"'~' | \
          sed 's~RESOURCE_PREFIX_PLACEHOLDER~'"$RESOURCE_PREFIX"'~' > $CREDS
        rm $CREDS.temp 2> /dev/null
        ;;
      aks)
        cp $CREDS $CREDS.temp
        cat $CREDS.temp | \
          sed 's~AKS_SUBSCRIPTION_ID_PLACEHOLDER~'"$AKS_SUBSCRIPTION_ID"'~' | \
          sed 's~AKS_LOCATION_PLACEHOLDER~'"$AKS_LOCATION"'~' | \
          sed 's~RESOURCE_PREFIX_PLACEHOLDER~'"$RESOURCE_PREFIX"'~' > $CREDS
        rm $CREDS.temp 2> /dev/null
        ;;
      gke)
        cp $CREDS $CREDS.temp
        cat $CREDS.temp | \
          sed 's~GKE_PROJECT_PLACEHOLDER~'"$GKE_PROJECT"'~' | \
          sed 's~GKE_CLUSTER_ZONE_PLACEHOLDER~'"$GKE_CLUSTER_ZONE"'~' | \
          sed 's~RESOURCE_PREFIX_PLACEHOLDER~'"$RESOURCE_PREFIX"'~' > $CREDS
        rm $CREDS.temp 2> /dev/null
        ;;
      ocp)
        ;;
      pks)
        ;;
    esac
    echo ""
    echo "The updated credentials file can be found here: $CREDS"
    echo ""
fi
