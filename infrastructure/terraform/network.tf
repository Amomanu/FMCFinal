module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.main.name
  vnet_name           = "${var.env_name}-vnet"
  location            = var.location
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names
  tags                = var.tags
}
