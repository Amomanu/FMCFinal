module "postgres-vm" {
  source              = "./modules/linuxvm"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  vnet_subnet_id      = module.networking.vnet_subnets[0]
  ssh_key             = var.vm_public_ssh_key == "" ? module.vm_ssh_key.public_ssh_key : var.vm_public_ssh_key
  vm_size             = var.postgres_vm_size
  vm_hostname         = "${var.env_name}-postgres"
  tags                = {
    app = "postgres"
    env = var.env_name
  }
  sg_port = "5432"
  sg_source_address = module.networking.vnet_subnets_address_prefix[0]
  public_ip_enabled = true
}

module "storage" {
  source            = "./modules/storage"
  enabled           = var.postgres_backups_enabled
  storage_name      = azurerm_storage_account.storage.name
  storage_id        = azurerm_storage_account.storage.id
  container_name    = "postgres"
  vm_identity       = module.postgres-vm.vm_principal_id
}

resource "null_resource" "run-ansible-playbook-postgres" {
  provisioner "local-exec" {
    command = "echo ${module.postgres-vm.private_ip_address} | sleep 20 | ansible-playbook -i '../ansible/inventory/inventory.azure_rm.yml' -u ubuntu ../ansible/postgres-vm.yaml --extra-vars='playbook_hosts=tag_app_postgres:&tag_env_${var.env_name} path=${module.storage.container_path} db_name=${var.db_name} db_user=${data.azurerm_key_vault_secret.postgres_user.value} db_password=${data.azurerm_key_vault_secret.postgres_password.value}' --key-file ${module.vm_ssh_key.private_ssh_key_filename} --ssh-common-args='-o StrictHostKeyChecking=no' -e 'ansible_python_interpreter=python3'"
  }
  depends_on = [ module.postgres-vm ]
}

