import adal
import requests
import os
import json
import sys

incoming_data = json.loads(sys.stdin.read())

tenant_id = incoming_data['tenantid']
client_id = incoming_data['clientid']
secret_id = incoming_data['secretid']
subscription = incoming_data['subscription']
resource_group = incoming_data['resourcegroup']
workflow = incoming_data['workflow']
trigger = incoming_data['trigger']


authority_url = 'https://login.microsoftonline.com/' + tenant_id
resource = 'https://management.azure.com/'
context = adal.AuthenticationContext(authority_url)
token = context.acquire_token_with_client_credentials(resource, client_id, secret_id)
headers = {'Authorization': 'Bearer ' + token['accessToken'], 'Content-Type': 'application/json'}
params = {'api-version': '2019-05-01'}

url = 'https://management.azure.com/subscriptions/' + subscription + '/resourceGroups/' + resource_group + '/providers/Microsoft.Logic/workflows/' + workflow + '/triggers/' + trigger + '/listCallbackUrl'

r = requests.post(url, headers=headers, params=params)

resp_data = r.json()
data = {str(k):str(v) for k, v in resp_data.items() if k in ['value']}

json_str = json.dumps(data)

json.dump(data, sys.stdout)