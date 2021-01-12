# https://hub.helm.sh/charts/jetstack/cert-manager

resource "null_resource" "cert_manager_crds" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${module.kubernetes.kube_config_file} apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml"
  }

  depends_on = [kubernetes_namespace.cert_manager]
}

resource "null_resource" "tls_move_placeholder" {
  provisioner "local-exec" {
    command = "cp ${path.module}/manifests/cluster-issuer.yaml ${path.module}/manifests/cluster-issuer-final.yaml"
  }
}

resource "null_resource" "tls_replace_common_crt_key" {
  provisioner "local-exec" {
    command = "sed -i 's#__TLSCRT__#${data.azurerm_key_vault_secret.tls_crt.value}#g' ${path.module}/manifests/cluster-issuer-final.yaml && sed -i 's#__TLSKEY__#${data.azurerm_key_vault_secret.tls_key.value}#g' ${path.module}/manifests/cluster-issuer-final.yaml"
  }

  depends_on = [null_resource.tls_move_placeholder]
}

/*
resource "null_resource" "tls_replace_macos_crt" {
  provisioner "local-exec" {
    command = "sed -i '' 's#__TLSCRT__#${data.azurerm_key_vault_secret.tls_crt.value}#g' ${path.module}/manifests/cluster-issuer-final.yaml || true"
  }

  depends_on = [null_resource.tls_move_placeholder]
}
resource "null_resource" "tls_replace_macos_key" {
  provisioner "local-exec" {
    command = "sed -i '' 's#__TLSKEY__#${data.azurerm_key_vault_secret.tls_key.value}#g' ${path.module}/manifests/cluster-issuer-final.yaml || true"
  }

  depends_on = [null_resource.tls_move_placeholder]
}

resource "null_resource" "tls_replace_ubuntu_key" {
  provisioner "local-exec" {
    command = "sed -i 's#__TLSKEY__#${data.azurerm_key_vault_secret.tls_key.value}#g' ${path.module}/manifests/cluster-issuer-final.yaml || true"
  }

  depends_on = [null_resource.tls_move_placeholder]
}

resource "null_resource" "tls_replace_ubuntu_crt" {
  provisioner "local-exec" {
    command = "sed -i 's#__TLSCRT__#${data.azurerm_key_vault_secret.tls_crt.value}#g' ${path.module}/manifests/cluster-issuer-final.yaml || true"
  }

  depends_on = [null_resource.tls_move_placeholder]
}
*/

resource "null_resource" "cert_manager_cluster_issuer" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${module.kubernetes.kube_config_file} apply -f ${path.module}/manifests/cluster-issuer-final.yaml"
  }

  /*
  triggers = {
    manifest_md5 = filemd5("${path.module}/manifests/cluster-issuer-final.yaml")
  }*/

  depends_on = [null_resource.cert_manager_crds, null_resource.tls_replace_common_crt_key ]
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name    = "cert-manager"
    labels  = {
      "certmanager.k8s.io/disable-validation" = "true"
    }
  }
}

resource "helm_release" "cert_manager" {
  name          = "cert-manager"
  namespace     = kubernetes_namespace.cert_manager.metadata[0].name
  #repository    = data.helm_repository.jetstack.metadata[0].url
  repository = "https://charts.jetstack.io"

  chart         = "cert-manager"
  version       = "v0.12.0"
  timeout       = 600

  values = [
    "${file("../helm/cert-manager/values.yaml")}"
  ]

  depends_on = [null_resource.cert_manager_crds]
}
