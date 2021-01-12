data "azurerm_key_vault" "keyvault" {
  name = var.key_vault_name
  resource_group_name = "terraform"
}

data "azurerm_client_config" "current" {
}

data "azurerm_key_vault_secret" "azure_subscription_id" {
  name = "azureSubscriptionId"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "azure_tenant_id" {
  name = "azureTenantId"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

resource "random_string" "redispassword" {
 length = 32
 upper = false
 special = false
}

resource "azurerm_key_vault_secret" "redispassword" {
  name         = "redispassword"
  value        = random_string.redispassword.result
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

data "azurerm_key_vault_secret" "redispassword" {
  name = "redispassword"
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
  depends_on = [ azurerm_key_vault_secret.redispassword]
}

data "azurerm_key_vault_secret" "azure_client_id" {
  name = "azureClientId"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "azure_client_secret" {
  name = "azureClientSecret"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "dns_azure_tenant_id" {
  name = "azureDNSTenantId"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "dns_azure_subscription_id" {
  name = "azureDNSSubscriptionId"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "dns_azure_client_id" {
  name = "azureDNSClientId"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "dns_azure_client_secret" {
  name = "azureDNSClientSecret"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "postgres_user" {
  name = "postgresUser"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

resource "random_string" "postgres_password" {
 length = 30
 upper = false
 special = false
}

data "azurerm_key_vault_secret" "elastic_user" {
  name = "elasticUser"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

resource "random_string" "elastic_password" {
 length = 30
 upper = false
 special = false
}

data "azurerm_key_vault_secret" "grafana_user" {
  name = "grafanaUser"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

resource "random_string" "grafana_password" {
 length = 30
 upper = false
 special = false
}

data "azurerm_key_vault_secret" "alert_slack_1_webhook" {
  name = "slackWebhookUrl"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "alert_slack_2_webhook" {
  name = "slackWebhookUrl"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "alert_slack_watchdog_webhook" {
  name = "slackWebhookUrl"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "registry_user" {
  name = "dockerUser"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "registry_password" {
  name = "dockerPassword"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "google_maps_api_key" {
  name = "googleMapsApiKey"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "branch_key" {
  name = "branchKey"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "email_host_password" {
  name = "emailPassword"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "sendgrid_api_key" {
  name = "emailPassword"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "firebase_secret" {
  name = "firebaseSecret"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

# twilio
data "azurerm_key_vault_secret" "twilio_from_tel" {
  name = "twilioFromTel"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "twilio_account_sid" {
  name = "twilioAccountSid"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "twilio_auth_token" {
  name = "twilioAuthToken"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

# fastfield
data "azurerm_key_vault_secret" "fastfield_username" {
  name = "fastfieldUsername"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "fastfield_password" {
  name = "fastfieldPassword"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "fastfield_api_key" {
  name = "fastFieldApiKey"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

# azure dns
data "azurerm_key_vault_secret" "azure_dns_client" {
  name = "azureDNSClientId"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}
data "azurerm_key_vault_secret" "azure_dns_key" {
  name = "azureDNSKey"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}
data "azurerm_key_vault_secret" "azure_dns_tenant_id" {
  name = "azureDNSTenantId"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

# Flower
resource "random_string" "flowercred" {
 length = 30
 upper = false
 special = false
}

# TLS
data "azurerm_key_vault_secret" "tls_key" {
  name = "TLSKEY"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}
data "azurerm_key_vault_secret" "tls_crt" {
  name = "TLSCRT"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

data "azurerm_key_vault_secret" "superuserEmail" {
  name = "superuserEmail"
  key_vault_id = "${data.azurerm_key_vault.keyvault.id}"
}

resource "random_string" "superuserPassword" {
 length = 30
 upper = false
 special = false
}

data "azurerm_dns_zone" "main" {
  provider              = azurerm.dns
  name                  = var.dns_zone
  resource_group_name   = var.dns_azure_resource_group
}

data "azurerm_subscription" "current" {
  subscription_id       = var.azure_subscription_id
}


resource "null_resource" "azure_vm_search_inventory_ansible" {
  provisioner "local-exec" {
    command = "cp ../ansible/inventory/inventory.azure_rm.yml_template ../ansible/inventory/inventory.azure_rm.yml"
  }
}

resource "null_resource" "azure_vm_search_inventory_ansible_replace_ubuntu" {
  provisioner "local-exec" {
    command = "sed -i 's#__NEW_ENVIRONMENT_NAME__#${var.env_name}-env#g' ../ansible/inventory/inventory.azure_rm.yml"
  }

  depends_on = [ null_resource.azure_vm_search_inventory_ansible ]
}

module "vm_ssh_key" {
  source         = "./modules/ssh-key"
  name           = "${var.env_name}-vm"
  public_ssh_key = var.vm_public_ssh_key == "" ? "" : var.vm_public_ssh_key
}

resource "azurerm_resource_group" "main" {
  name     = "${var.env_name}-env"
  location = var.location

  depends_on = [ null_resource.azure_vm_search_inventory_ansible_replace_ubuntu ]
}

resource "azurerm_key_vault" "env_specific_key_vault" {
  name                        = "terraformclient${var.env_name}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_key_vault_secret.azure_tenant_id.value

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_key_vault_secret.azure_tenant_id.value
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get", "list", "create",
    ]

    secret_permissions = [
      "list",
      "get",
      "set",
    ]

    storage_permissions = [
      "get",
    ]
  }
}

resource "azurerm_key_vault_secret" "postgres_user_env_specific" {
  name         = "postgresUser"
  value        = data.azurerm_key_vault_secret.postgres_user.value
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgresPassword"
  value        = random_string.postgres_password.result
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

data "azurerm_key_vault_secret" "postgres_password" {
  name = "postgresPassword"
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id

  depends_on = [ azurerm_key_vault_secret.postgres_password ]
}

resource "azurerm_key_vault_secret" "elastic_user_env_specific" {
  name         = "elasticUser"
  value        = data.azurerm_key_vault_secret.elastic_user.value
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

resource "azurerm_key_vault_secret" "elastic_password" {
  name         = "elasticPassword"
  value        = random_string.elastic_password.result
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

data "azurerm_key_vault_secret" "elastic_password" {
  name = "elasticPassword"
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id

  depends_on = [ azurerm_key_vault_secret.elastic_password ]
}

resource "azurerm_key_vault_secret" "grafana_user_env_specific" {
  name         = "grafanaUser"
  value        = data.azurerm_key_vault_secret.grafana_user.value
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

resource "azurerm_key_vault_secret" "grafana_password" {
  name         = "grafanaPassword"
  value        = random_string.grafana_password.result
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

data "azurerm_key_vault_secret" "grafana_password" {
  name = "grafanaPassword"
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id

  depends_on = [ azurerm_key_vault_secret.grafana_password ]
}

resource "azurerm_key_vault_secret" "flowercred" {
  name         = "flowerCred"
  value        = "bckjob:${random_string.flowercred.result}"
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

data "azurerm_key_vault_secret" "flowercred" {
  name = "flowerCred"
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id

  depends_on = [ azurerm_key_vault_secret.flowercred ]
}

resource "azurerm_key_vault_secret" "superuserEmail_env_specific" {
  name         = "superuserEmail"
  value        = data.azurerm_key_vault_secret.superuserEmail.value
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

resource "azurerm_key_vault_secret" "superuserPassword" {
  name         = "superuserPassword"
  value        = random_string.superuserPassword.result
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

data "azurerm_key_vault_secret" "superuserPassword" {
  name = "superuserPassword"
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id

  depends_on = [ azurerm_key_vault_secret.superuserPassword ]
}

resource "azurerm_storage_account" "storage" {
  name                      = "${var.env_name}${var.env_prefix}"
  resource_group_name       = azurerm_resource_group.main.name
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "media" {
  #count                 = 1
  name                  = "${var.azure_container}"
  storage_account_name  = "${var.env_name}${var.env_prefix}"
  container_access_type = "private"

  depends_on = [ azurerm_storage_account.storage ]
}

resource "azurerm_key_vault_secret" "storage_access_key" {
  name         = "storageAccessKey"
  value        = azurerm_storage_account.storage.primary_access_key
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id
}

resource "null_resource" "playbook-filebeat" {
  provisioner "local-exec" {
    command = "ansible-playbook -i '../ansible/inventory/inventory.azure_rm.yml' -u ubuntu --key-file ${module.vm_ssh_key.private_ssh_key_filename} ../ansible/filebeat-playbook.yaml --extra-vars='playbook_hosts=tag_env_${var.env_name} kibana_domain=${var.kibana_subdomain}-${local.env_dns_zone} elastic_domain=${var.elastic_subdomain}-${local.env_dns_zone} elastic_user=${data.azurerm_key_vault_secret.elastic_user.value} elastic_password=${data.azurerm_key_vault_secret.elastic_password.value}' --ssh-common-args='-o StrictHostKeyChecking=no' -e 'ansible_python_interpreter=python3'"
  }

  depends_on = [ module.postgres-vm, module.redis-vm, helm_release.elasticsearch, helm_release.external_dns, helm_release.cert_manager ]
}


#EY Adding credentials to connect to kubectl using creds defined on KubernetesProvider
provider "kubectl" {
  host                   = module.kubernetes.host
  client_certificate     = base64decode(module.kubernetes.client_certificate)
  client_key             = base64decode(module.kubernetes.client_key)
  cluster_ca_certificate = base64decode(module.kubernetes.cluster_ca_certificate)
  load_config_file       = false
}



####### HERE!!!!!!!!!!

#EY Assign permissions to kubernetes cluster 
resource "azurerm_role_assignment" "kv" {
  scope = azurerm_key_vault.env_specific_key_vault.id
  role_definition_name = "Reader"
  principal_id         = module.kubernetes.kubelet_identity.0.object_id
}
#EY
resource "azurerm_key_vault_access_policy" "aks" {
  key_vault_id       = azurerm_key_vault.env_specific_key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = module.kubernetes.kubelet_identity.0.object_id
  secret_permissions = ["Get"]
}
#EY install CRDs
resource "kubectl_manifest" "Akv2k8sCRD" {                                
    yaml_body = "${file("AzureKeyVaultSecret.yaml")}"
    }


#EY Adding demo secret

resource "azurerm_key_vault_secret" "demo" {
  name         = "ey-secret"
  value        = "ey-value"
  key_vault_id = azurerm_key_vault.env_specific_key_vault.id

  # Must wait for Terraform SP policy to kick in before creating secrets
  depends_on = [azurerm_key_vault.env_specific_key_vault]
}


#EY Installs chart
resource "helm_release" "spv-charts" {
  name       = "akv2k8s"
  chart      = "./helms/akv2k8s-1.1.26.tgz"
  namespace        = "akv2k8s"
  create_namespace = true
  depends_on = [module.kubernetes.main]
  }
 
 


    
