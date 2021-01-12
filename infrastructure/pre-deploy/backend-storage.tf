resource "azurerm_resource_group" "terraform" {
  name     = "terraform"
  location = var.location
}

data "azurerm_key_vault" "keyvault" {
  name = var.key_vault_name
  resource_group_name = "terraform"
}
 
data "azurerm_key_vault_secret" "azure_client_id" {
  name = "azureClientId"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

resource "azurerm_storage_account" "terraform" {
  name                     = var.tfstate_storage_account
  resource_group_name      = azurerm_resource_group.terraform.name
  location                 = azurerm_resource_group.terraform.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "terraform" {
  count                 = length(var.state_envs)

  name                  = "terraform-${element(var.state_envs, count.index)}"
  storage_account_name  = azurerm_storage_account.terraform.name
  container_access_type = "private"
}

data "template_file" "backend" {
  count               = length(var.state_envs)

  template = "${file("${path.module}/templates/backend.tpl")}"
  vars = {
    resource_group    = azurerm_resource_group.terraform.name
    storage_account   = var.tfstate_storage_account
    storage_container = azurerm_storage_container.terraform[count.index].name
    key               = "${element(var.state_envs, count.index)}.terraform.tfstate"
  }
}

resource "local_file" "backend_config" {
  count                = length(var.state_envs)

  content              = data.template_file.backend[count.index].rendered
  filename             = "${path.module}/../terraform/backends/${element(var.state_envs, count.index)}.tfvars"
  file_permission      = "0644"
  directory_permission = "0755"
}
