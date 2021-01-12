# --------------------------------------------------------------------------------------------------
# General Settings
# --------------------------------------------------------------------------------------------------
# Environmennt name used as various resources/entities prefix. Should differ in different environments
env_name                  = "${ENV_NAME}"
env_prefix		   = "${ENV_PREFIX}"
# Azure location used to deploy resources
location                  = "${AZURE_REGION}"
# DNS zone used to add subdomain for various services
dns_zone                  = "apollo-farm.com"

azure_subscription_id = "${AZURE_SUB}"
azure_tenant_id = "${AZURE_TENANT}"
azure_client_id = "${AZURE_UN}"
azure_client_secret = "${AZURE_PWD}"

# Azure tenant id where dns_zone is hosted. Main Azure account should be able to access this subscription
dns_azure_tenant_id       = "${AZURE_DNS_TENANT}"
# Azure subscription id where dns_zone is hosted. Main Azure account should be able to access this subscription
dns_azure_subscription_id = "${AZURE_DNS_SUB}"

dns_azure_client_id = "${AZURE_DNS_UN}"
dns_azure_client_secret = "${AZURE_DNS_PWD}"

# Azure resource group where dns_zone is hosted
dns_azure_resource_group  = "k8s-resource"

# --------------------------------------------------------------------------------------------------
# AKS cluster
# --------------------------------------------------------------------------------------------------
# VM types for Kubernetes nodes
kubernetes_agents_size  = "Standard_DS2_v2"
# Amount of Kubernetes nodes
kubernetes_agents_count = "3"
# Kubernetes version
kubernetes_version      = "1.15.7"

# --------------------------------------------------------------------------------------------------
# Postgres
# --------------------------------------------------------------------------------------------------
# VM types for Postgres
postgres_vm_size  = "Standard_B1s"
# Postgres DB user
postgres_user     = "postgres"
# Postgres DB password
postgres_password = "${POSTGRES_PWD}"

postgres_backups_enabled = false
# --------------------------------------------------------------------------------------------------
# Redis
# --------------------------------------------------------------------------------------------------
# VM types for Redis
redis_vm_size = "Standard_B1s"

# --------------------------------------------------------------------------------------------------
# Elastic stack chart
# --------------------------------------------------------------------------------------------------
# Username used to authentication in Elasticsearch and Kibana
elastic_user        = "elastic"
# Password used to authentication in Elasticsearch and Kibana
elastic_password    = "${ELASTIC_PWD}"
# Volume size for Elasticsearch
elastic_storage     = "10Gi"
# Subdomain for Elasticsearch ingress. FQDN is elastic_subdomain + dns_zone
elastic_subdomain   = "elastic"
# Subdomain for Kibana ingress. FQDN is kibana_subdomain + dns_zone
kibana_subdomain    = "kibana"

# --------------------------------------------------------------------------------------------------
# Monitoring charts
# --------------------------------------------------------------------------------------------------
# Username used to authentication in Grafana
grafana_user        = "admin"
# Password used to authentication in Grafana
grafana_password    = ""${GRAFANA_PWD}""
# Subdomain for Grafana ingress. FQDN is grafana_subdomain + dns_zone
grafana_subdomain   = "grafana"
# Whether the 1st Slack will be used to send alerts
alert_slack_1_enabled = false
# 1st Slack webhook URL used to send alert notifications
alert_slack_1_webhook = "${SLACK_WEBHOOK_1_URL}"
# 1st Slack 1 channel used to send alert notifications
alert_slack_1_channel = "${SLACK_WEBHOOK_1_CHANNEL}"
# Whether 2nd Slack will be used to send alerts
alert_slack_2_enabled = true
# 2nd Slack webhook URL used to send alert notifications
alert_slack_2_webhook = "${SLACK_WEBHOOK_2_URL}"
# 2nd Slack channel used to send alert notifications
alert_slack_2_channel = "${SLACK_WEBHOOK_2_CHANNEL}"
# Slack channel to send Deanman's Switch alerts
alert_slack_watchdog_webhook = "${SLACK_WEBHOOK_3_URL}"
# Volume size for Prometheus
prometheus_storage  = "10Gi"

# --------------------------------------------------------------------------------------------------
# Application chart
# --------------------------------------------------------------------------------------------------
app_name          = "${ENV_PREFIX}-app"
# Docker image for the app (including tag)
app_image         = "${DOCKER_BACKEND_IMAGE}"
adminapp_image	  = "${DOCKER_ADMIN_IMAGE}"
# Docker registry with the app image
image_registry    = "${DOCKER_REGISTRY_URL}"
# Username for Docker registry with the app image
registry_user     = "${DOCKER_REGISTRY_USER}"
# Password for Docker registry with the app image
registry_password = "${DOCKER_REGISTRY_PASSWORD}"
# Subdomain for Grafana ingress. FQDN is grafana_subdomain + dns_zone
app_subdomain     = "${ENV_PREFIX}-${ENV_NAME}"
# Volume size for Application
storage_size      = "100Mi"

debug_enabled = "true"
# Postgres DB port for application config
db_port       = "5432"
# Postgres DB name for application config
db_name       = "${POSTGRES_DB}"

# Misc parameters for application config
google_maps_api_key   = "${GOOGLE_MAPS_KEY}"
azure_account_name    = "${ENV_NAME}${ENV_PREFIX}"
# will be set once CREATE_CLUSTER action is executed
azure_account_key     = "${AZURE_ACCOUNT_KEY}"
azure_container       = "media"
branch_key            = "${BRANCH_KEY}"
email_port            = "587"
email_use_tls         = "true"
email_host            = "smtp.sendgrid.net"
email_host_user       = "apikey"
email_host_password   = "${SENDGRID_KEY}"
sendgrid_api_key      = "${SENDGRID_KEY}"
domain_url            = "https://${ENV_NAME}.apollo-farm.com"
default_from_email    = "no-reply@${ENV_NAME}.apollo-farm.com"
broker_url            = "redis://redis:6379/0"
celery_result_backend = "redis://redis:6379/0"
firebase_secret       = "${FIREBASE_SECRET}"
firebase_id           = ""
twilio_from_tel       = "${TWILIO_FROM_TEL}"
twilio_account_sid    = "${TWILIO_ACCOUNT_SID}"
twilio_auth_token     = "${TWILIO_AUTH_TOKEN}"
fastfield_username    = "${FASTFIELD_UNAME}"
fastfield_password    = "${FASTFIELD_PWD}"
fastfield_api_key     = "${FASTFIELD_API_KEY}"
fastfield_url         = "${FASTFIELD_URL}"
backend_api_url	      = "https://${ENV_NAME}.apollo-farm.com"

# azure "app registration in DNS azure account to allow domain update when new tenant added"
azure_dns_client	  = "${AZURE_DNS_APP_CLIENT_ID}"
azure_dns_key	      = "${AZURE_DNS_APP_KEY}"
azure_dns_tenant_id	  = "${AZURE_DNS_TENANT}"
flowercred			  =	"${FLOWERCRED}"
# will be set once CREATE_CLUSTER action is executed
kubernetes_lb_ip               =   "${KUBERNETES_LB_IP}"