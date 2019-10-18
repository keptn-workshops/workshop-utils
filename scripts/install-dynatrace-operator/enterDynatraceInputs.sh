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
    DT_HOSTNAME=$(cat creds.json | jq -r '.dynatraceHostName')
    DT_API_TOKEN=$(cat creds.json | jq -r '.dynatraceApiToken')
    DT_PAAS_TOKEN=$(cat creds.json | jq -r '.dynatracePaaSToken')
fi

echo "==================================================================="
echo -e "Please enter the values for provider type: $DEPLOYMENT_NAME:"
echo "==================================================================="
echo "Dynatrace Host Name (e.g. abc12345.live.dynatrace.com)"
read -p "                                       (current: $DT_HOSTNAME) : " DT_HOSTNAME_NEW
read -p "Dynatrace API Token                    (current: $DT_API_TOKEN) : " DT_API_TOKEN_NEW
read -p "Dynatrace PaaS Token                   (current: $DT_PAAS_TOKEN) : " DT_PAAS_TOKEN_NEW
echo "==================================================================="
echo ""
# set value to new input or default to current value
DT_HOSTNAME=${DT_HOSTNAME_NEW:-$DT_HOSTNAME}
DT_API_TOKEN=${DT_API_TOKEN_NEW:-$DT_API_TOKEN}
DT_PAAS_TOKEN=${DT_PAAS_TOKEN_NEW:-$DT_PAAS_TOKEN}

echo -e "Please confirm all are correct:"
echo ""
echo "Dynatrace Host Name          : $DT_HOSTNAME"
echo "Dynatrace API Token          : $DT_API_TOKEN"
echo "Dynatrace PaaS Token         : $DT_PAAS_TOKEN"

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
      sed -e 's/"deployment": ".*/"deployment": "'$DEPLOYMENT'",/g' | \
      sed 's~DYNATRACE_HOSTNAME_PLACEHOLDER~'"$DT_HOSTNAME"'~' | \
      sed 's~DYNATRACE_API_TOKEN_PLACEHOLDER~'"$DT_API_TOKEN"'~' | \
      sed 's~DYNATRACE_PAAS_TOKEN_PLACEHOLDER~'"$DT_PAAS_TOKEN"'~' > $CREDS

    echo ""
    echo "The updated credentials file can be found here: $CREDS"
    echo ""
fi
