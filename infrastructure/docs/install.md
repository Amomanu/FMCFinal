# Cluster deployment instruction

Deployment here means either provisioning new cluster/workload or updating existing ones unless otherwise provided.

## Prerequisites

Install necessary cli utilities on local machine:

- `python3` ([Installation instructions](https://docs.python.org/3/using/index.html) with [pip](https://pip.pypa.io/en/stable/installing/)
- `terraform` ([Installation instructions](https://learn.hashicorp.com/terraform/getting-started/install.html). Current required version is > 0.12. Latest version can be found on [terraform releases](https://releases.hashicorp.com/terraform/) page.)
- `helm2` ([Installation instructions](https://v2.helm.sh/docs/using_helm/))
- `az` ([Installation instructions](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest))
- `kubectl` ([Installation instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/)). Ideally kubectl version should be equal to server version. Acceptable difference is no more than 2 minor versions.
- python dependencies:
```
pip3 install -r requirements.txt
```


## Deploying/updating cluster

#### Specify environment values

Create a new environment `.tfvars` file inside `terraform/environments/` directory, which includes configuration parameters for the infrastructure and deployed applications.

The example configuration and their description of parameters can be found in terraform/environments/client-k8s-demo.tfvars file.

---
#### Access Azure
Login to necessary Azure account:

Lets assume tenant id is: 9917dcc8-bdaf-4e03-928b-1e67b0d806c5 

```

az login --tenant 9917dcc8-bdaf-4e03-928b-1e67b0d806c5
# this will display subscriptions. get subscription ids and use below command
az account set --subscription="<subscription id>"
brew install gnu-tar  # in macos
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"   # in macos
export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"   # in macos
```
This command will open a browser window and request Azure account access details.

---
#### Create storage for Terraform state
(NOTE: This step is necessary only for spinning up a new environment. You do not need to run it to update existing environment.)

Configure and run pre-deployment Terraform files to create a storage account for storing Terraform states:
To do that add all necessary environment names into `state_envs` list and set a desired location in pre-deploy/terraform.tfvars

Apply Terraform:
```

# Navigate to pre-deploy directory
cd pre-deploy/
rm terraform.tfstate

# Initialize Terraform 
terraform init

# (Optional) Make sure only necessary resources are created
# lets assume you are going to create env : devops86
# then below <env> will be replaced with "devops86"
terraform plan --var state_envs='["<env>"]'

# Apply changes
terraform apply --var state_envs='["<env>"]'
```
The last command will output local backend config files for each environment in terraform/backends directory.

---

#### Deploy New environment with single bash script

```
# Run below, it will ask for needed details
bash deploy_new_env.sh
```

#### Deploy step by step terraform commands
Run Terraform to deploy all necessary resources:

```

cd ..
# Navigate to terraform directory
cd terraform/

# Remove .terraform directory if it exists
rm -rf .terraform/

# check terraform.tfstate verify env names. correct if needed

# Initialize Terraform. Replace <env> with the desired environment from the pre-deploy list.
terraform init -backend-config=backends/<env>.tfvars

# (Optional) Make sure only necessary resources are created
terraform plan -var-file=environments/parameters.tfvars --var env_name='<env>'


# Apply changes
terraform apply -var-file=environments/parameters.tfvars --var env_name='<env>'


# extra commands for reference
helm init --upgrade
terraform destroy --target="helm_release.client-application" -var-file=environments/devops-k8s-demo.tfvars
# keep changin memory every 2ms as its timing out
# helm init --upgrade --service-account tiller --history-max 3
# kubectl -n kube-system get po
# kubectl patch deployment tunnelfront -p '{"spec":{"template":{"spec":{"containers":[{"name": "tunnel-front","resources":{"requests":{"cpu":"100m"}}}]}} }}' -n kube-system
# kubectl -n kube-system delete po -l component=tunnel
# kubectl delete pod coredns-autoscaler-79b778686c-5v8xs coredns-b696649d9-7d95t coredns-b696649d9-9x8l9 kube-proxy-678d9 kube-proxy-d8xvj -n kube-system

``` 
---
## Post-deployment steps

Manual:
Monitor Alerts > Manage Actions > Add action Group > 
  <env_name>-actiongroup > actiongo > Attach Logic app with comman alert scema "true"

Post-deployments steps are available [here](post-deploy.md).

## Application config changes examples
An example for added additional environment variable for application is available [here](additional_var.md).
