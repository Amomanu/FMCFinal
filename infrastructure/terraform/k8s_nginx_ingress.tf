
resource "azurerm_public_ip" "nginxlb_ip" {
  name                = "${var.env_name}-pub-ip"
  location            = "${var.location}"
  resource_group_name = "MC_${var.env_name}-env_${var.env_name}-aks_${var.location}"
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = var.tags

  depends_on = [ kubernetes_namespace.cert_manager ]
}

resource "azurerm_dns_a_record" "elastic" {
  provider            = azurerm.dns
  name                = "elastic-${var.env_name}"
  zone_name           = data.azurerm_dns_zone.main.name
  resource_group_name = var.dns_azure_resource_group
  ttl                 = 60
  records             = [azurerm_public_ip.nginxlb_ip.ip_address]
}

resource "azurerm_dns_a_record" "grafana" {
  provider            = azurerm.dns
  name                = "grafana-${var.env_name}"
  zone_name           = data.azurerm_dns_zone.main.name
  resource_group_name = var.dns_azure_resource_group
  ttl                 = 60
  records             = [azurerm_public_ip.nginxlb_ip.ip_address]
}

resource "azurerm_dns_a_record" "kibana" {
  provider            = azurerm.dns
  name                = "kibana-${var.env_name}"
  zone_name           = data.azurerm_dns_zone.main.name
  resource_group_name = var.dns_azure_resource_group
  ttl                 = 60
  records             = [azurerm_public_ip.nginxlb_ip.ip_address]
}

resource "azurerm_dns_a_record" "maindns" {
  provider            = azurerm.dns
  name                = "${var.env_name}"
  zone_name           = data.azurerm_dns_zone.main.name
  resource_group_name = var.dns_azure_resource_group
  ttl                 = 60
  records             = [azurerm_public_ip.nginxlb_ip.ip_address]
}

resource "azurerm_dns_a_record" "maindnsadmin" {
  provider            = azurerm.dns
  name                = "admin-${var.env_name}"
  zone_name           = data.azurerm_dns_zone.main.name
  resource_group_name = var.dns_azure_resource_group
  ttl                 = 60
  records             = [azurerm_public_ip.nginxlb_ip.ip_address]
}

resource "azurerm_dns_aaaa_record" "maindnsaaaa" {
  provider            = azurerm.dns
  name                = "${var.env_name}"
  zone_name           = data.azurerm_dns_zone.main.name
  resource_group_name = var.dns_azure_resource_group
  ttl                 = 60
  records             = ["2603:1030:403:3::1"]
}

resource "azurerm_dns_aaaa_record" "maindnsadminaaaa" {
  provider            = azurerm.dns
  name                = "admin-${var.env_name}"
  zone_name           = data.azurerm_dns_zone.main.name
  resource_group_name = var.dns_azure_resource_group
  ttl                 = 60
  records             = ["2603:1030:403:3::1"]
}

resource "azurerm_dns_a_record" "celerytasks" {
  provider            = azurerm.dns
  name                = "celerytasks-${var.env_name}"
  zone_name           = data.azurerm_dns_zone.main.name
  resource_group_name = var.dns_azure_resource_group
  ttl                 = 60
  records             = [azurerm_public_ip.nginxlb_ip.ip_address]
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://charts.helm.sh/stable"

  chart      = "nginx-ingress"
  namespace  = "default"
  timeout    = 600
  wait       = "false"

/*  values = [
    "${file("../helm/nginx-ingress/values.yaml")}"
  ]
*/
  set {
    name  = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.nginxlb_ip.ip_address
  }

  set {
	   name = "controller.service.externalIPs[0]"
	   value = azurerm_public_ip.nginxlb_ip.ip_address
  }

  depends_on = [ azurerm_public_ip.nginxlb_ip, helm_release.elasticsearch, helm_release.kibana ]
}


