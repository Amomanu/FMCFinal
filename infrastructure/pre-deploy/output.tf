output "resource_group" {
  value = azurerm_resource_group.terraform.name
}

output "storage_account" {
  value = azurerm_storage_account.terraform.name
}

output "storage_container" {
  value = azurerm_storage_container.terraform.*.name
}

output "paths_to_state_configs" {
  value = local_file.backend_config.*.filename
}
