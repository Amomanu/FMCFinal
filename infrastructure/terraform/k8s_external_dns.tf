module "external_dns_service_principal" {
  source   = "./modules/service_principal_dns"
  name     = "${var.env_name}-external-dns"
  end_date = "2Y"
  dns_azure_client_id = "${data.azurerm_key_vault_secret.dns_azure_client_id.value}"
  dns_azure_client_secret = "${data.azurerm_key_vault_secret.dns_azure_client_secret.value}"
  dns_azure_subscription_id = "${data.azurerm_key_vault_secret.dns_azure_subscription_id.value}"

  providers = {
    azuread = azuread.dns
  }
}

/*
resource "azurerm_role_assignment" "external_dns_zone" {
  provider             = azurerm.dns
  scope                = "/subscriptions/${data.azurerm_key_vault_secret.dns_azure_subscription_id.value}/resourceGroups/${var.dns_azure_resource_group}/providers/Microsoft.Network/dnsZones/${var.dns_zone}"
  role_definition_name = "Contributor"
  principal_id         = module.external_dns_service_principal.object_id
}

resource "azurerm_role_assignment" "external_dns_resourcegroup" {
  provider             = azurerm.dns
  scope                = "/subscriptions/${data.azurerm_key_vault_secret.dns_azure_subscription_id.value}/resourceGroups/${var.dns_azure_resource_group}"
  role_definition_name = "Reader"
  principal_id         = module.external_dns_service_principal.object_id
}
*/

resource "kubernetes_namespace" "external_dns" {
  metadata {
    annotations = {
      name = "external-dns"
    }

    name = "external-dns"
  }
}


resource "helm_release" "external_dns" {
  name          = "external-dns"
  namespace     = kubernetes_namespace.external_dns.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"

  chart         = "external-dns"
  version       = "4.5.0"
  timeout       = 600

  values = [
    "${file("${path.module}/../helm/external-dns/values.yaml")}"
  ]

  set {
    name  = "txtOwnerId"
    value = var.env_name
  }

  set {
    name  = "domainFilters[0]"
    value = var.dns_zone
  }

  set {
    name  = "azure.resourceGroup"
    value = var.dns_azure_resource_group
  }

  set {
    name  = "azure.tenantId"
    value = data.azurerm_key_vault_secret.dns_azure_tenant_id.value
  }

  set {
    name  = "azure.subscriptionId"
    value = data.azurerm_key_vault_secret.dns_azure_subscription_id.value
  }

  set {
    name  = "azure.aadClientId"
    value = module.external_dns_service_principal.client_id
  }

  set {
    name  = "azure.aadClientSecret"
    value = module.external_dns_service_principal.client_secret
  }
}

