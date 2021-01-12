# How to add additional env variable for the application

Includes steps and examples for adding an additional variable called `ADDITIONAL_VARIABLE` for the application deployment.

## Add the variable in chart values file

Add new variable name in [helm/client-application/values.yaml](https://bitbucket.org/fmcdevops/fmc-devops/src/cod-18_deploy_everything/helm/client-application/values.yaml) file.

The variables which are passed to the application are inside `parameters:` block:

```yaml
parameters:
  FASTFIELD_API_KEY: ""
  FASTFIELD_URL: ""
  ADDITIONAL_VARIABLE: ""
```
---
## Add a variable for Terraform

Terraform should have its own variable created which then can be overridden in [terraform/variables.tf](https://bitbucket.org/fmcdevops/fmc-devops/src/cod-18_deploy_everything/terraform/variables.tf) file:

It can be set as an empty string.

```hcl-terraform
variable "additional_variable" {
  default = ""
}
```
---
## Pass Terraform variable to helm_release resource

Now Terraform variable content can be used as a value for `ADDITIONAL_VARIABLE` and be passed to `helm_release` resource in [terraform/k8s_client_app.tf](https://bitbucket.org/fmcdevops/fmc-devops/src/cod-18_deploy_everything/terraform/k8s_client_app.tf) file by adding a new `set{}` block:

```hcl-terraform
set {
  name  = "parameters.ADDITIONAL_VARIABLE"
  value = var.additional_variable
}
```

If you need to pass data type other than a string e.g. numbers or boolean values - use `set_string {}` instead of `set {}`.

---
## Specify `ADDITIONAL_VARIABLE` env-specific value

To specify the value for `ADDITIONAL_VARIABLE` update the `.tfvar` file e.g. [environments/client-k8s-demo.tfvars](https://bitbucket.org/fmcdevops/fmc-devops/src/cod-18_deploy_everything/environments/client-k8s-demo.tfvars) :

```hcl-terraform
additional_variable = "a_value"
```

---
# How to run Terraform for a single module/resource

It is possible to apply Terraform changes for a single resource rather than for the whole infrastructure.

To do that use `-target` parameter in Terraform command. [This](https://www.terraform.io/docs/internals/resource-addressing.html) is how resources are addressed in Terraform.

If only helm chart for the client application should be updated, then the following commands should be run:

```
# Navigate to terraform directory
cd terraform/

# Initialize Terraform 
terraform init

# Make sure only necessary resources are created
terraform plan -var-file="../environments/client-k8s-demo.tfvars" -target=helm_release.client-application

# Apply changes
terraform apply -var-file="../environments/client-k8s-demo.tfvars" -target=helm_release.client-application
```  
