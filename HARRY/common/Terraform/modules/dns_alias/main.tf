data "cloudplatform_dns_zone" "dns_zones" {
  name = var.dns_zone
}

## Fetch SLB data if target is slb_vip
data "cloudplatform_slb_load_balancer" "slb" {
  count             = contains(keys(var.target), "slb_vip_name") ? 1 : 0
  availability_zone = var.target["slb_az"]
  name              = "${var.resource_prefix}${var.target["slb_name"]}"
}

data "cloudplatform_slb_vip" "slb_vip" {
  count = contains(keys(var.target), "slb_vip_name") ? 1 : 0

  name            = var.target["slb_vip_name"]
  loadbalancer_id = data.cloudplatform_slb_load_balancer.slb[count.index].id
}

locals {
  resource_prefix = replace(var.resource_prefix, "_", "-")
  name_key        = replace(var.name_key, "_", "-")

  targets = (
contains(keys(var.target), "slb_vip_name") ? [data.cloudplatform_slb_vip.slb_vip[0].fqdn] : (contains(keys(var.target), "vcs_server_name") ? flatten([for key, value in var.vcs_fqdns : [for k,v in value : v if startswith(k, "${var.target.vcs_server_name}")]]) : [var.target.fqdn_target] )

  )
}
resource "cloudplatform_dns_alias" "alias" {
  count = length(local.targets)

  name    = format("%s%s%s", var.use_prefix ? local.resource_prefix : "", local.name_key, length(local.targets) > 1 ? "-${count.index}" : "")
  target  = local.targets[count.index]
  ttl     = var.ttl
  zone_id = data.cloudplatform_dns_zone.dns_zones.id
  tags    = var.tags
}