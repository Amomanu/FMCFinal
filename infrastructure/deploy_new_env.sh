#!/bin/bash

set -e

alias python=python3

echo "ansible located at : $(which ansible-playbook)"
echo "kubectl located at : $(which kubectl)"
echo "helm2 located at   : $(which helm)"

read -p "Enter prefix of environment that you want to create ( Example: devops100 or dev001 or test001 ): " env_prefix
read -p "Enter azure subscription id: " env_azure_subscription
export env_azure_region=eastus2
read -p "Enter keyvault name: " env_key_vault_name
read -p "Enter TF state Storage account (must be unique and available to be created): " env_tf_state_storage

# Read the deployment Environment and update the application insights instance Key
read -p "Enter the Environment ( Ex: dev, qa, qat, prod): " env

echo $env
if [ $env = 'dev' ] 
then
  env_app_insights_key='53c3c0ae-d025-4451-a729-e473da1c6c0b'
elif [ $env = 'qa' ] 
then
  env_app_insights_key='f1d3df2f-f57e-445c-aeb2-7a8a09916cb9'
elif [ $env = 'uat' ] 
then
  env_app_insights_key='46941912-db1b-4581-952d-235d055be33f'
elif [ $env = 'prod' ] 
then
  env_app_insights_key='5f13a33f-7ae5-476a-8bc3-efb08d77585d'
else
  env_app_insights_key='53c3c0ae-d025-4451-a729-e473da1c6c0b'
fi

echo "Application Insights Key: $env_app_insights_key Set"

# for now set DEV subscription as default as only that has owner rights
az login --tenant 9917dcc8-bdaf-4e03-928b-1e67b0d806c5
az account set --subscription="${env_azure_subscription}"

cp ansible/inventory/inventory.azure_rm.yml_template ansible/inventory/inventory.azure_rm.yml
sed -i "s#__NEW_ENVIRONMENT_NAME__#${env_prefix}-env#g" ansible/inventory/inventory.azure_rm.yml

#EY Editing the name of the KeyVault in yaml files for akv2k8s.io
cd terraform/
ak2var="terraformclient${env_prefix}"
sed -i "s/kvnames/$ak2var/" "akvs-secret-sync.yaml"
sed -i "s/kvnames/$ak2var/" "akvs-secret-inject.yaml"
cd ../



# create terraform states and upload it to azure storage containers
cd pre-deploy/
rm -f terraform.tfstate
terraform init
terraform apply --var state_envs="[\"${env_prefix}\"]" --var key_vault_name="${env_key_vault_name}" --var tfstate_storage_account="${env_tf_state_storage}"

# start all component deployment having above terraform state
cd ../terraform/
rm -rf .terraform/
terraform init -backend-config="backends/${env_prefix}.tfvars"
terraform apply -var-file=environments/parameters.tfvars --var env_name="${env_prefix}" --var location="${env_azure_region}" --var azure_subscription_id="${env_azure_subscription}" --var key_vault_name="${env_key_vault_name}" --var app_insights_key="${env_app_insights_key}"
