# Azure Kubernetes Cluster with Client application

This repository contains code for deploying Kubernetes cluster on Azure with Client application:

- Terraform templates for creating infrastructure on the Azure side. Terraform is also used to create some
Kubernetes entities (like namespaces, services, auxiliary secrets) and deploy Helm charts.

- Helm charts and Helm charts value files for cluster workloads.

- Ansible playbooks and roles to install software to Azure VM (like PostgreSQL and Redis)

- See [install document](docs/install.md) for the installation instruction

- See [keys document](docs/keys.md) for instruction on how to access the bastion boxes (or other vms)

- See [migration document](migration.md) for instructions on how to migrate data from one cluster to another

## Running terraform for incremental changes

This code was stood up by BCG without thinking about running incremental changes - they conceived of it only for the purposes of a one-time deployment. However, when things change, we should be able to run it to deploy just the new things, or just the things that changed. Here is how I've gotten this to work:

```
virtualenv env36
source env36/bin/active
pip install -r requirements.txt

az account set --subscription="c608ed40-5c21-4fa0-af83-6f7436d7a2b7"

cd terraform

# note key vault name is for the secrets shared amongst the environments
# there is also a keyvault for this specific environment named terraformclientarcqa

mkdir backends
touch arcqa.tfvars

#populate tfvars like this:
resource_group_name  = "terraform"
storage_account_name = "terraformclientfmcqa"
container_name       = "terraform-arcqa"
key                  = "arcqa.terraform.tfstate"

terraform init -backend-config=backends/arcqa.tfvars

terraform plan -var-file=environments/parameters.tfvars \
    --var env_name="arcqa" \
    --var location="eastus2" \
    --var azure_subscription_id="c608ed40-5c21-4fa0-af83-6f7436d7a2b7" \
    --var key_vault_name="terraformclient"
 ```

## Creating django superuser

To get an initial login to django, you need to shell into the backend container and execute the following:

```python manage.py create_tenant_superuser --username=fmcadmin@fmcdemo.com --schema=public```
