locals {
  env_dns_zone = "${var.env_name}.${var.dns_zone}"
  star_env_dns_zone = "*.${var.dns_zone}"
}
