locals {
  certificates_in_use        = { for key, pki in var.certificates : key => pki if contains([for listener in var.listeners : listener.certificate_name], key) }
  all_real_servers_names     = flatten([for pool in var.pools : pool.real_server_names]) # OCS
  all_vcs_real_servers_names = flatten([for pool in var.pools : pool.real_server_names if pool.type == "VCS"])
  all_ssl_profile_names = flatten([
    [for health_check in var.health_checks : health_check.ssl_profile_name if health_check.ssl_profile_name != null],
    [for pool in var.pools : pool.ssl_profile_name if pool.ssl_profile_name != null], [for listener in var.listeners : listener.ssl_profile_name if listener.ssl_profile_name != null]
  ])
}

data "cloudplatform_compute_instances" "vms" {
  for_each = toset(local.all_real_servers_names)

  name = each.key
}

## VCS
data "cloudplatform_vcs_servers" "vcs_vms" {
  for_each = toset(local.all_vcs_real_servers_names)

  name = each.key
}

data "cloudplatform_slb_subnet" "slb_subnet" {
  name = var.subnet_name
}

data "cloudplatform_slb_ssl_profile" "ssl_profiles" {
  for_each = toset(local.all_ssl_profile_names)

  name = each.key
}

resource "cloudplatform_slb_load_balancer_v1" "slb" {
  availability_zone = var.availability_zone
  name              = "${var.resource_prefix}${var.name_key}"
  type              = var.slb_type
  tags              = var.tags
}

## VIP
resource "cloudplatform_slb_vip_v1" "vip" {
  for_each = toset(var.vips)

  name            = each.key
  subnet_id       = data.cloudplatform_slb_subnet.slb_subnet.id
  loadbalancer_id = cloudplatform_slb_load_balancer_v1.slb.id
}

## HEALTHCHECK
resource "cloudplatform_slb_healthcheck_v1" "health_check" {
  for_each = var.health_checks

  name              = each.key
  loadbalancer_id   = cloudplatform_slb_load_balancer_v1.slb.id
  health_check_type = each.value.health_check_type
  protocol          = each.value.protocol
  http_request      = each.value.http_request
  port              = each.value.port
  ssl_profile_id    = each.value.ssl_profile_name != null ? data.cloudplatform_slb_ssl_profile.ssl_profiles[each.value.ssl_profile_name].id : null
}

locals {
  real_server_ids = {
    for pool_name, pool in var.pools : pool_name => flatten([
      for vm in data.cloudplatform_compute_instances.vms : [
        for instance in vm.instances : instance.id if contains(pool.real_server_names, instance.name)
      ]
    ])
  }

  real_server_disabled_ids = {
    for pool_name, pool in var.pools : pool_name => flatten([
      for vm in data.cloudplatform_compute_instances.vms : [
        for instance in vm.instances : instance.id if contains(pool.real_server_disabled_names, instance.name)
      ]
    ])
  }

  ## VCS
  real_vcs_server_ids = {
    for pool_name, pool in var.pools : pool_name => flatten([
      for vm in data.cloudplatform_vcs_servers.vcs_vms : [
        for instance in vm.instances : instance.id if contains(pool.real_server_names, instance.name)
      ]
    ])
  }

  real_vcs_server_disabled_ids = {
    for pool_name, pool in var.pools : pool_name => flatten([
      for vm in data.cloudplatform_vcs_servers.vcs_vms : [
        for instance in vm.instances : instance.id if contains(pool.real_server_disabled_names, instance.name)
      ]
    ])
  }
}

## POOL
resource "cloudplatform_slb_pool_v1" "pool" {
  for_each = var.pools

  name                          = each.key
  loadbalancer_id               = cloudplatform_slb_load_balancer_v1.slb.id
  algorithm                     = each.value.algorithm
  healthcheck_id                = cloudplatform_slb_healthcheck_v1.health_check[each.value.health_check_name].id
  persistence                   = each.value.persistence
  port                          = each.value.port
  real_server_ids               = each.value.type == "OCS" ? local.real_server_ids[each.key] : local.real_vcs_server_ids[each.key]
  real_server_disabled_ids      = each.value.type == "OCS" ? local.real_server_disabled_ids[each.key] : local.real_vcs_server_disabled_ids[each.key]
  ssl_profile_id                = each.value.ssl_profile_name != null ? data.cloudplatform_slb_ssl_profile.ssl_profiles[each.value.ssl_profile_name].id : null
  pool_type                     = each.value.type
  replace_members_on_update     = each.value.replace_members_on_update
  persistence_source_ip_timeout = each.value.persistence_source_ip_timeout
}

## LISTENER
resource "cloudplatform_slb_listener_v1" "slb_listener" {
  for_each = var.listeners

  name            = each.key
  vip_id          = cloudplatform_slb_vip_v1.vip[each.value.vip_name].id
  pool_id         = cloudplatform_slb_pool_v1.pool[each.value.pool_name].id
  loadbalancer_id = cloudplatform_slb_load_balancer_v1.slb.id
  port            = each.value.port
  protocol        = each.value.protocol
  xff             = each.value.xff
  proxy_protocol  = each.value.proxy_protocol
  ssl_profile_id  = each.value.ssl_profile_name != null ? data.cloudplatform_slb_ssl_profile.ssl_profiles[each.value.ssl_profile_name].id : null
  certificate_id  = each.value.protocol == "HTTPS" ? cloudplatform_slb_certificate_v1.slb_certificate[each.value.certificate_name].id : null
  http_policy_ids = [for http_policy_key, http_policy in cloudplatform_slb_http_policy_v1.http_policy : http_policy.id if contains(each.value.http_policies_names, http_policy_key)]
  tags            = each.value.tags

  dynamic "http_rate_limit" {
    for_each = each.value.http_rate_limits
    content {
      http_rate_limit_type = http_rate_limit.value.http_rate_limit_type
      threshold            = http_rate_limit.value.threshold
      time_period          = http_rate_limit.value.time_period
    }
  }
}

## HTTP_POLICY
resource "cloudplatform_slb_http_policy_v1" "http_policy" {
  for_each = var.http_policies

  name            = each.key
  loadbalancer_id = cloudplatform_slb_load_balancer_v1.slb.id

  action {
    pool_id = cloudplatform_slb_pool_v1.pool[each.value.pool_name].id
    type    = "pool"
  }

  request {
    case     = each.value.request.case
    criteria = each.value.request.criteria
    str      = each.value.request.str
    type     = each.value.request.type
  }
}

## CERTIFICATE
resource "cloudplatform_slb_certificate_v1" "slb_certificate" {
  for_each = local.certificates_in_use

  name            = each.key
  certificate     = each.value.certificate
  private_key     = each.value.private_key
  passphrase      = each.value.passphrase
  loadbalancer_id = cloudplatform_slb_load_balancer_v1.slb.id
}