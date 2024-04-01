########## GLOBAL ##############################################################

locals {
  # The prefix to add to all resource names (for example to add app_name and infra_env), but can be changed
  resource_prefix = "${var.app_name}_${var.infra_env}_"

  default_tags = [
    "app_name:${var.app_name}",
    "infra_env:${var.infra_env}",
  ]
}

########## COMPUTE #############################################################

module "vcs_instances" {
  source   = "./modules/vcs_instances"
  for_each = var.vcs_instances

  resource_prefix                 = local.resource_prefix
  name_key                        = each.key
  instance_count                  = each.value.instance_count
  names_override                  = lookup(each.value, "names_override", null)
  description                     = lookup(each.value, "description", null)
  tags                            = lookup(each.value, "tags", null)
  availability_zones              = each.value.availability_zones
  flavor                          = each.value.flavor
  image                           = each.value.image
  network                         = each.value.network
  disk_size                       = each.value.disk_size
  lease                           = lookup(each.value, "lease", 0)
  security_groups                 = lookup(each.value, "security_groups", null)
  security_group_id_mappedby_name = module.security_groups.id_mappedby_name
  with_micro_segmentation         = lookup(each.value, "with_micro_segmentation", true)
  msp_service_level               = lookup(each.value, "msp_service_level", "Standard")
  metadata                        = lookup(each.value, "metadata", {})
  check_public_modules            = lookup(each.value, "check_public_modules", true)
  modules = [for mod in lookup(each.value, "modules", []) : {
    name                = mod.name
    parameters          = lookup(mod, "parameters", {})
    wait_for_completion = lookup(mod, "wait_for_completion", true)
  }]
}

########## NETWORK #############################################################

module "security_groups" {
  source = "./modules/security_groups"

  resource_prefix = local.resource_prefix
  security_groups = {
    for name_key, secgroup in var.security_groups : name_key => {
      description = lookup(secgroup, "description", "")
      tags        = lookup(secgroup, "tags", [])
      ecosystem   = lookup(secgroup, "ecosystem", "ocs")
      rules = [for rule in secgroup.rules : {
        description  = lookup(rule, "description", "")
        direction    = rule.direction
        remote_type  = rule.remote_type
        remote_value = rule.remote_value
        ether_type   = lookup(rule, "ether_type", "IPv4")
        protocol     = rule.protocol
        port_range   = lookup(rule, "port_range", null)
      }]
    }
  }
}

########## DNS ALIAS #############################################################

module "dns_alias" {
  source     = "./modules/dns_alias"
  for_each   = var.dns_aliases

  resource_prefix = local.resource_prefix
  name_key        = each.key
  region          = var.region
  target          = each.value.target
  ttl             = lookup(each.value, "ttl", 1800)
  dns_zone        = each.value.dns_zone
  tags            = lookup(each.value, "tags", [])
  vcs_fqdns       = { for vcs_instance_key, vcs_instance in module.vcs_instances : vcs_instance_key => vcs_instance["vcs_name_fqdn"] }
  use_prefix      = lookup(each.value, "use_prefix", false)
}

########## LOADBALANCE #########################################################

module "service_load_balancer" {
  source   = "./modules/service_load_balancer"
  for_each = var.slb_load_balancers

  name_key          = each.key
  resource_prefix   = local.resource_prefix
  availability_zone = each.value.availability_zone
  slb_type          = each.value.slb_type
  subnet_name       = each.value.subnet_name
  tags              = lookup(each.value, "tags", [])
  vips              = each.value.vips

  health_checks = { for health_check_key, health_check in each.value.health_checks : health_check_key => {
    health_check_type = health_check["heath_check_type"]
    protocol          = health_check["protocol"]
    http_request      = lookup(health_check, "http_request", null)
    port              = health_check["port"]
    ssl_profile_name  = lookup(health_check, "ssl_profile_name", null)
    }
  }

  pools = { for pool_key, pool in each.value.pools : pool_key => {
    algorithm                     = pool["algorithm"]
    persistence                   = pool["persistence"]
    real_server_names             = pool["real_server_names"]
    real_server_disabled_names    = lookup(pool, "real_server_disabled_names", [])
    type                          = lookup(pool, "type", "OCS")
    port                          = pool["port"]
    replace_members_on_update     = lookup(pool, "replace_members_on_update", false)
    persistence_source_ip_timeout = lookup(pool, "persistence_source_ip_timeout", null)
    health_check_name             = pool["health_check_name"]
    ssl_profile_name              = lookup(pool, "ssl_profile_name", null)
    }
  }

  listeners = { for listener_key, listener in each.value.listeners : listener_key => {
    port                = listener["port"]
    protocol            = listener["protocol"]
    proxy_protocol      = lookup(listener, "proxy_protocol", null)
    xff                 = lookup(listener, "xff", false)
    tags                = lookup(listener, "tags", [])
    pool_name           = listener["pool_name"]
    http_policies_names = lookup(listener, "http_policies_names", [])
    certificate_name    = lookup(listener, "certificate_name", null)
    vip_name            = listener["vip_name"]
    ssl_profile_name    = lookup(listener, "ssl_profile_name", null)
    http_rate_limits    = lookup(listener, "http_rate_limits", [])
    }
  }

  http_policies = lookup(each.value, "http_policies", {})

  certificates = { for cert_name, cert_value in module.pki_certs :
    cert_name => {
      certificate = cert_value.cert_pem,
      private_key = cert_value.cert_private_key_no_passphrase,
      passphrase  = cert_value.cert_passphrase
    }
  }
}

########## PKI Certs ###########################################################

module "pki_certs" {
  source   = "./modules/pki_certs"
  for_each = var.pki_certs

  name_key                       = each.key
  ca_short_name                  = each.value.ca_short_name
  subject_alt_names              = each.value.subject_alt_names
  notifications_email            = each.value.notifications_email
  notifications_callback_url     = lookup(each.value, "notifications_callback_url", null)
  notifications_ticketing_group  = lookup(each.value, "notifications_ticketing_group", null)
  tags                           = lookup(each.value, "tags", null)
  wait_for_revocation            = lookup(each.value, "wait_for_revocation", null)
  subject                        = each.value.subject
  notifications_callback_payload = lookup(each.value, "notifications_callback_payload", null)
  get_crypto_assets              = lookup(each.value, "get_crypto_assets", false)
  remove_name_on_delete          = lookup(each.value, "remove_name_on_delete", [])
}
