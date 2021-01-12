resource "helm_release" "client-application" {
  name       = var.app_name
  chart      = "${path.module}/../helm/client-application"
  namespace  = var.app_namespace
  values     = [ file("${path.module}/../helm/client-application/values.yaml") ]
  timeout    = 6000
  wait       = "false"

  depends_on = [null_resource.run-ansible-playbook-postgres, azurerm_storage_account.storage, helm_release.external_dns,  helm_release.nginx_ingress]

  set {
    name  = "env"
    value = var.env_name
  }

  set {
    name  = "nginxweb.app_name"
    value = var.app_name
  }

  set {
    name  = "imageCredentials.registry"
    value = var.image_registry
  }

  set {
    name  = "imageCredentials.username"
    value = data.azurerm_key_vault_secret.registry_user.value
  }

  set_sensitive {
    name  = "imageCredentials.password"
    value = data.azurerm_key_vault_secret.registry_password.value
  }

  set {
    name  = "backend.image"
    value = var.app_image
  }

  set {
    name  = "nginxweb.ingress.domainName"
####    value = var.app_subdomain != "" ? "${var.app_subdomain}.${local.env_dns_zone}" : local.env_dns_zone
    value = local.env_dns_zone
  }

  set {
    name  = "nginxweb.ingress.starDomainName"
    value = local.star_env_dns_zone
  }

  set {
    name  = "pvc.size"
    value = var.storage_size
    type = "string"
  }

  set {
    name  = "parameters.DEBUG"
    value = var.debug_enabled
    type = "string"
  }

  set {
    name  = "parameters.DB_HOST"
    value =  module.postgres-vm.private_ip_address
    type = "string"
  }

  set {
    name  = "parameters.DB_PORT"
    value = var.db_port
    type = "string"
  }

  set {
    name  = "parameters.DB_NAME"
    value = var.db_name
  }

  set {
    name  = "parameters.DB_USER"
    value = data.azurerm_key_vault_secret.postgres_user.value
  }

  set_sensitive {
    name  = "parameters.DB_PASSWORD"
    value = data.azurerm_key_vault_secret.postgres_password.value
  }

  set {
    name  = "parameters.GOOGLE_MAPS_API_KEY"
    value = data.azurerm_key_vault_secret.google_maps_api_key.value
  }

  set {
    name  = "parameters.AZURE_ACCOUNT_NAME"
    value = "${var.env_name}fmc"
  }

  set {
    name  = "parameters.AZURE_ACCOUNT_KEY"
    value = azurerm_storage_account.storage.primary_access_key
  }

  set {
    name  = "parameters.AZURE_CONTAINER"
    value = var.azure_container
  }

  set {
    name  = "parameters.BRANCH_KEY"
    value = data.azurerm_key_vault_secret.branch_key.value
  }

  set {
    name  = "parameters.EMAIL_PORT"
    value = var.email_port
    type = "string"
  }

  set {
    name  = "parameters.EMAIL_USE_TLS"
    value = var.email_use_tls
    type = "string"
  }

  set {
    name  = "parameters.EMAIL_HOST"
    value = var.email_host
  }

  set {
    name  = "parameters.EMAIL_HOST_USER"
    value = var.email_host_user
  }

  set {
    name  = "parameters.EMAIL_HOST_PASSWORD"
    value = data.azurerm_key_vault_secret.email_host_password.value
  }

  set {
    name  = "parameters.SENDGRID_API_KEY"
    value = data.azurerm_key_vault_secret.sendgrid_api_key.value
  }

  set {
    name  = "parameters.DOMAIN_URL"
    value = var.domain_url
  }

  set {
    name  = "parameters.DEFAULT_FROM_EMAIL"
    value = var.default_from_email
  }

  set {
    name  = "parameters.BROKER_URL"
    value = "redis://:${data.azurerm_key_vault_secret.redispassword.value}@${module.redis-vm.private_ip_address}:6379/0"
  }

  set {
    name  = "parameters.CELERY_RESULT_BACKEND"
    value = "redis://:${data.azurerm_key_vault_secret.redispassword.value}@${module.redis-vm.private_ip_address}:6379/0"
  }

  set {
    name  = "parameters.FIREBASE_SECRET"
    value = data.azurerm_key_vault_secret.firebase_secret.value
  }

  set {
    name  = "parameters.FIREBASE_ID"
    value = var.firebase_id
  }

  set {
    name  = "parameters.TWILIO_FROM_TEL"
    value = data.azurerm_key_vault_secret.twilio_from_tel.value
    type = "string"
  }

  set {
    name  = "parameters.TWILIO_ACCOUNT_SID"
    value = data.azurerm_key_vault_secret.twilio_account_sid.value
  }

  set {
    name  = "parameters.TWILIO_AUTH_TOKEN"
    value = data.azurerm_key_vault_secret.twilio_auth_token.value
  }

  set {
    name  = "parameters.FASTFIELD_USERNAME"
    value = data.azurerm_key_vault_secret.fastfield_username.value
  }

  set {
    name  = "parameters.FASTFIELD_PASSWORD"
    value = data.azurerm_key_vault_secret.fastfield_password.value
  }

  set {
    name  = "parameters.FASTFIELD_API_KEY"
    value = data.azurerm_key_vault_secret.fastfield_api_key.value
  }

  set {
    name  = "parameters.FASTFIELD_URL"
    value = var.fastfield_url
  }

  set {
    name  = "parameters.AZURE_DNS_CLIENT"
    value = data.azurerm_key_vault_secret.azure_dns_client.value
  }

  set {
    name  = "parameters.AZURE_DNS_KEY"
    value = data.azurerm_key_vault_secret.azure_dns_key.value
  }

  set {
    name  = "parameters.AZURE_SUBSCRIPTION_ID"
    value = var.azure_subscription_id
  }

  set {
    name  = "parameters.AZURE_DNS_TENANT_ID"
    value = data.azurerm_key_vault_secret.azure_dns_tenant_id.value
  }

  set {
    name  = "parameters.FLOWERCRED"
    value = data.azurerm_key_vault_secret.flowercred.value
  }

  set {
    name  = "adminwebappparameters.FIREBASE_ID"
    value = var.firebase_id
  }

  set {
    name  = "adminwebappparameters.BACKEND_API_URL"
    value = var.backend_api_url
  }

  set {
    name  = "adminwebapp.image"
    value = var.adminapp_image
  }

  set {
    name  = "celery.image"
    value = var.app_image
  }

  set {
    name  = "flower.image"
    value = var.app_image
  }

}

resource "null_resource" "playbook-client-app" {
  
  provisioner "local-exec" {
    command = "ansible-playbook -i '../ansible/inventory/inventory.azure_rm.yml' -u ubuntu --key-file ${module.vm_ssh_key.private_ssh_key_filename} ../ansible/client-app.yaml --extra-vars='playbook_hosts=tag_env_${var.env_name} client_app_domain=${local.env_dns_zone} kube_config_path=${module.kubernetes.kube_config_file} env_name=${var.env_name}'  --ssh-common-args='-o StrictHostKeyChecking=no' -e 'ansible_python_interpreter=python3'"
  }
  

/*  provisioner "local-exec" {
    command = "ansible-playbook ../ansible/client-app.yaml --extra-vars='playbook_hosts=localhost client_app_domain=admin-${local.env_dns_zone} kube_config_path=${module.kubernetes.kube_config_file} env_name=${var.env_name} superuserEmail=${data.azurerm_key_vault_secret.superuserEmail.value} superuserPassword=${data.azurerm_key_vault_secret.superuserPassword.value}'  --ssh-common-args='-o StrictHostKeyChecking=no' -e 'ansible_python_interpreter=python3'"
  }*/

  depends_on = [ helm_release.client-application ]
}
