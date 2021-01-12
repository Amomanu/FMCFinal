# --------------------------------------------------------------------------------------------------
# General Settings
# --------------------------------------------------------------------------------------------------
# Environmennt name used as various resources/entities prefix. Should differ in different environments
env_prefix		   = "fmc"
# Azure location used to deploy resources
# location                  = "eastus2"
# DNS zone used to add subdomain for various services
dns_zone                  = "pestpressure.com"

# Azure resource group where dns_zone is hosted
dns_azure_resource_group  = "PestDetection"

# --------------------------------------------------------------------------------------------------
# AKS cluster
# --------------------------------------------------------------------------------------------------
# VM types for Kubernetes nodes
kubernetes_agents_size  = "Standard_DS2_v2"
# Amount of Kubernetes nodes
kubernetes_agents_count = "3"
# Kubernetes version
kubernetes_version      = "1.18.10"

# --------------------------------------------------------------------------------------------------
# Postgres
# --------------------------------------------------------------------------------------------------
# VM types for Postgres
# Standard_B1s
postgres_vm_size  = "Standard_E4s_v3"

postgres_backups_enabled = true
# --------------------------------------------------------------------------------------------------
# Redis
# --------------------------------------------------------------------------------------------------
# VM types for Redis
redis_vm_size = "Standard_DS2_v2"

# --------------------------------------------------------------------------------------------------
# Elastic stack chart
# --------------------------------------------------------------------------------------------------
# Volume size for Elasticsearch
elastic_storage     = "10Gi"
# Subdomain for Elasticsearch ingress. FQDN is elastic_subdomain + dns_zone
elastic_subdomain   = "elastic"
# Subdomain for Kibana ingress. FQDN is kibana_subdomain + dns_zone
kibana_subdomain    = "kibana"

# --------------------------------------------------------------------------------------------------
# Monitoring charts
# --------------------------------------------------------------------------------------------------
# Subdomain for Grafana ingress. FQDN is grafana_subdomain + dns_zone
grafana_subdomain   = "grafana"
# Whether the 1st Slack will be used to send alerts
alert_slack_1_enabled = false
# 1st Slack 1 channel used to send alert notifications
alert_slack_1_channel = "deploymentchannel"
# Whether 2nd Slack will be used to send alerts
alert_slack_2_enabled = true
# 2nd Slack channel used to send alert notifications
alert_slack_2_channel = "deploymentchannel"
# Volume size for Prometheus
prometheus_storage  = "10Gi"

# --------------------------------------------------------------------------------------------------
# Application chart
# --------------------------------------------------------------------------------------------------
app_name          = "fmc-app"
# Docker image for the app (including tag)
app_image         = "pestdetectioncr.azurecr.io/backendapp-fmclive:latest"
adminapp_image	  = "pestdetectioncr.azurecr.io/live/adminwebapp:latest"
# Docker registry with the app image
image_registry    = "pestdetectioncr.azurecr.io"
# Subdomain for Grafana ingress. FQDN is grafana_subdomain + dns_zone
app_subdomain     = ""
# Volume size for Application
storage_size      = "100Mi"

debug_enabled = "false"
# Postgres DB port for application config
db_port       = "5432"
# Postgres DB name for application config
db_name       = "fmcpgdb"

# Misc parameters for application config
google_maps_api_key   = ""
azure_account_name    = ""
azure_account_key     = ""  # Not needed
azure_container       = "media"
branch_key            = ""
email_port            = "587"
email_use_tls         = "true"
email_host            = "smtp.sendgrid.net"
email_host_user       = "apikey"
email_host_password   = ""
sendgrid_api_key      = ""
domain_url            = "https://pestpressure.com"
default_from_email    = "no-reply@arc.fmc.com"
#broker_url            = "redis://redis:6379/0"
#celery_result_backend = "redis://redis:6379/0"
firebase_secret       = ""
firebase_id           = ""
twilio_from_tel       = ""
twilio_account_sid    = ""
twilio_auth_token     = ""
fastfield_username    = ""
fastfield_password    = ""
fastfield_api_key     = ""
fastfield_url         = "https://api.fastfieldforms.com/services/v3/"
backend_api_url	      = "https://pestpressure.com"
azure_dns_client	  = ""
azure_dns_key	      = ""
azure_dns_tenant_id	  = ""
flowercred			  =	""
kubernetes_lb_ip               =   ""   # Not needed
