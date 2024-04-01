resource "cloudplatform_compute_security_group_v2" "secgroups" {
  for_each = var.security_groups

  name        = "${var.resource_prefix}${each.key}"
  description = each.value.description
  tags        = each.value.tags
  ecosystem   = each.value.ecosystem
}

locals {
  rules = flatten([
    for secgroup_name_key, secgroup in var.security_groups : [
      for i, rule in secgroup.rules : merge(rule, {
        secgroup_name_key = secgroup_name_key
        idx               = i
      })
    ]
  ])
}

resource "cloudplatform_compute_security_rule_v2" "rules" {
  for_each = { for rule in local.rules : "${rule.secgroup_name_key}_${rule.idx}" => rule }

  security_group_id = cloudplatform_compute_security_group_v2.secgroups[each.value.secgroup_name_key].id
  description       = each.value.description
  direction         = each.value.direction
  remote_type       = each.value.remote_type != "securityGroupName" ? each.value.remote_type : "securityGroupId"
  remote_value      = each.value.remote_type != "securityGroupName" ? each.value.remote_value : cloudplatform_compute_security_group_v2.secgroups[each.value.remote_value].id
  ether_type        = each.value.ether_type
  protocol          = each.value.protocol
  port_range        = each.value.port_range
}
