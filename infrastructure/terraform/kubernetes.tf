module "aks_service_principal" {
  source   = "./modules/service_principal"
  name     = "${var.env_name}-kubernetes"
  end_date = "2Y"
  azure_client_id = "${data.azurerm_key_vault_secret.azure_client_id.value}"
  azure_client_secret = "${data.azurerm_key_vault_secret.azure_client_secret.value}"
  azure_subscription_id = var.azure_subscription_id
}

module "kubernetes" {
  source                          = "./modules/kubernetes-cluster"
  env_name                        = var.env_name
  resource_group_name             = azurerm_resource_group.main.name
  location                        = var.location
  admin_username                  = var.kubernetes_admin_username
  admin_public_ssh_key            = var.kubernetes_public_ssh_key == "" ? module.kubernetes_ssh_key.public_ssh_key : var.kubernetes_public_ssh_key
  agents_size                     = var.kubernetes_agents_size
  agents_count                    = var.kubernetes_agents_count
  max_pods                        = var.kubernetes_max_pods
  kubernetes_version              = var.kubernetes_version
  vnet_subnet_id                  = module.networking.vnet_subnets[0]
}

module "kubernetes_ssh_key" {
  source         = "./modules/ssh-key"
  name           = "${var.env_name}-kubernetes"
  public_ssh_key = var.kubernetes_public_ssh_key == "" ? "" : var.kubernetes_public_ssh_key
}
