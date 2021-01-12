output "resource_group" {
  value = azurerm_resource_group.main.name
}

output "vnet_address_space" {
  value = module.networking.vnet_address_space
}