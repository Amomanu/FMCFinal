

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  features {}
  version = "=2.15.0"
}

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  features {}
  version = "=2.15.0"
  alias             = "dns"
  subscription_id   = var.dns_azure_subscription_id
}


provider "azuread" {
  version           = "=0.7.0"
  alias             = "main"
}

provider "azuread" {
  version           = "=0.7.0"
  alias             = "dns"
  subscription_id   = var.dns_azure_subscription_id
}

provider "kubernetes" {
  version                = "=1.10.0"

  host                   = module.kubernetes.host
  client_certificate     = base64decode(module.kubernetes.client_certificate)
  client_key             = base64decode(module.kubernetes.client_key)
  cluster_ca_certificate = base64decode(module.kubernetes.cluster_ca_certificate)
  load_config_file       = false
}

provider "external" {
  version = "~> 1.2"
}

provider "local" {
  version = "~> 1.4"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

provider "tls" {
  version = "~> 2.1"
}

##EY adding provider for kubectl

terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
