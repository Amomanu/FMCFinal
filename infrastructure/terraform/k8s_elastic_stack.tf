resource "kubernetes_namespace" "logging" {
  metadata {
    annotations = {
      name = var.logging_namespace
    }

    name = var.logging_namespace
  }
}

resource "null_resource" "tls_move_placeholder_el" {
  provisioner "local-exec" {
    command = "cp ${path.module}/manifests/ssl-logging.yaml ${path.module}/manifests/ssl-logging-final.yaml"
  }
}

resource "null_resource" "tls_replace_common_el_crt_key" {
  provisioner "local-exec" {
    command = "sed -i 's#__TLSCRT__#${data.azurerm_key_vault_secret.tls_crt.value}#g' ${path.module}/manifests/ssl-logging-final.yaml && sed -i 's#__TLSKEY__#${data.azurerm_key_vault_secret.tls_key.value}#g' ${path.module}/manifests/ssl-logging-final.yaml"
  }

  depends_on = [null_resource.tls_move_placeholder_el]
}

/*
resource "null_resource" "tls_replace_macos_el_crt" {
  provisioner "local-exec" {
    command = "sed -i 's#__TLSCRT__#${data.azurerm_key_vault_secret.tls_crt.value}#g' ${path.module}/manifests/ssl-logging-final.yaml || true"
  }

  depends_on = [null_resource.tls_move_placeholder_el]
}
resource "null_resource" "tls_replace_macos_el_key" {
  provisioner "local-exec" {
    command = "sed -i 's#__TLSKEY__#${data.azurerm_key_vault_secret.tls_key.value}#g' ${path.module}/manifests/ssl-logging-final.yaml || true"
  }

  depends_on = [null_resource.tls_move_placeholder_el]
}

resource "null_resource" "tls_replace_ubuntu_el_key" {
  provisioner "local-exec" {
    command = "sed -i 's#__TLSKEY__#${data.azurerm_key_vault_secret.tls_key.value}#g' ${path.module}/manifests/ssl-logging-final.yaml || true"
  }

  depends_on = [null_resource.tls_move_placeholder_el]
}
resource "null_resource" "tls_replace_ubuntu_el_crt" {
  provisioner "local-exec" {
    command = "sed -i 's#__TLSCRT__#${data.azurerm_key_vault_secret.tls_crt.value}#g' ${path.module}/manifests/ssl-logging-final.yaml || true"
  }

  depends_on = [null_resource.tls_move_placeholder_el]
}
*/

resource "null_resource" "cert_manager_rapidssl_logging" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${module.kubernetes.kube_config_file} apply -f ${path.module}/manifests/ssl-logging-final.yaml"
  }

  /*triggers = {
    manifest_md5 = filemd5("${path.module}/manifests/ssl-logging-final.yaml")
  }*/

  depends_on = [kubernetes_namespace.logging, null_resource.tls_replace_common_el_crt_key]
}

resource "kubernetes_secret" "elastic-credentials" {
  metadata {
    name      = "elastic-credentials"
    namespace = kubernetes_namespace.logging.metadata[0].name
  }

  data = {
    username = data.azurerm_key_vault_secret.elastic_user.value
    password = data.azurerm_key_vault_secret.elastic_password.value
  }

  type = "Opaque"
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  #repository = data.helm_repository.elastic.metadata[0].name
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  = kubernetes_namespace.logging.metadata[0].name
  version    = "7.10.0"
  values     = [ file("${path.module}/../helm/elastic-kibana-filebeat/elasticsearch-values.yaml") ]
  timeout    = 600

  set {
    name  = "volumeClaimTemplate.resources.requests.storage"
    value = var.elastic_storage
  }

  set {
    name  = "ingress.hosts[0]"
    value = "${var.elastic_subdomain}-${local.env_dns_zone}"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "${var.elastic_subdomain}-${local.env_dns_zone}"
  }

  #set_string {
  #  name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/whitelist-source-range"
  #  value = "${module.postgres-vm.public_ip_address}\\,${module.redis-vm.public_ip_address}"
  #}

  /*
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${module.kubernetes.kube_config_file} patch deployment -n kube-system tiller-deploy -p \"{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"date\":\"`date +'%s'`\"}}}}}\" && sleep 20"
  }*/

  depends_on = [ kubernetes_secret.elastic-credentials ]
}

resource "helm_release" "filebeat" {
  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  namespace  = kubernetes_namespace.logging.metadata[0].name
  version    = "7.10.0"
  values     = [ file("${path.module}/../helm/elastic-kibana-filebeat/filebeat-values.yaml") ]

}

resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  namespace  = kubernetes_namespace.logging.metadata[0].name
  version    = "7.10.0"
  values     = [ file("${path.module}/../helm/elastic-kibana-filebeat/kibana-values.yaml") ]
  timeout    = 600

  set {
    name  = "ingress.hosts[0]"
    value = "${var.kibana_subdomain}-${local.env_dns_zone}"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "${var.kibana_subdomain}-${local.env_dns_zone}"
  }

  depends_on = [ kubernetes_secret.elastic-credentials, helm_release.filebeat ]
}

