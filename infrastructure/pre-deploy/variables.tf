variable "state_envs" {
  type        = list(string)
}

variable "location" {
  type        = string
  description = "The location for the AKS deployment"
}

variable "tfstate_storage_account" {
  default     = "terraformclient"
  description = "The name of storage account for Terraform"
}

variable "key_vault_name" {
  default     = "terraformclient"
  description = "The name of Key vault"
}
