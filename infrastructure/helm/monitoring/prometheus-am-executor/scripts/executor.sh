#!/bin/bash
#set -euo pipefail

CURRENT_TIME=`date --iso-8601=seconds`

CLIENT_ID=`grep -Po '"'"aadClientId"'"\s*:\s*"\K([^"]*)' ./azure.json`
TENANT_ID=`grep -Po '"'"tenantId"'"\s*:\s*"\K([^"]*)' ./azure.json`
SECRET_ID=`grep -Po '"'"aadClientSecret"'"\s*:\s*"\K([^"]*)' ./azure.json`

#CLIENT_ID="${AAD_CLIENT_ID}"
#TENANT_ID="${TENANT_ID}"
#SECRET_ID="${CLIENT_SECRET}"

read -r -d '' PAYLOAD <<-_EOF_
{
    "time": "${CURRENT_TIME}",
    "data": {
        "baseData": {
            "metric": "Prometheus Watchdog",
            "namespace": "Prometheus",
            "dimNames": [
              "FiringValues"
            ],
            "series": [
              {
                "dimValues": [
                  "Alerts"
                ],
                "min": 5,
                "max": 5,
                "sum": 5,
                "count": 1
              }
            ]
        }
    }
}
_EOF_

echo "${PAYLOAD}" > payload.json


if [[ "$AMX_STATUS" != "firing" ]]; then
   exit 0
fi

# Authenticate
AUTH=$(curl -s -X POST https://login.microsoftonline.com/${TENANT_ID}/oauth2/token -F "grant_type=client_credentials" -F "client_id=${CLIENT_ID}" -F "client_secret=${SECRET_ID}" -F "resource=https://monitoring.azure.com/")
echo "${AUTH}" > access_token.json

ACCESS_TOKEN=`grep -Po '"'"access_token"'"\s*:\s*"\K([^"]*)' access_token.json`

# Send metric
curl -s -X POST https://${REGION}.monitoring.azure.com${CLUSTER_ID}/metrics -H "Content-Type: application/json" -H "Authorization: Bearer ${ACCESS_TOKEN}" -d @payload.json

echo "Alert from ${AMX_EXTERNAL_URL} sent."