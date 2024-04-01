output "slb_id" {
  value       = cloudplatform_slb_load_balancer_v1.slb.id
  description = "The slb id"
}

output "slb_vips" {
  value = { for vip in cloudplatform_slb_vip_v1.vip : vip.name => vip.id }
}

output "slb_healthchecks" {
  value = { for health_check in cloudplatform_slb_healthcheck_v1.health_check : health_check.name => health_check.id }
}


output "slb_pools" {
  value = { for pool in cloudplatform_slb_pool_v1.pool : pool.name => pool.id }
}

output "slb_listeners" {
  value = { for slb_listener in cloudplatform_slb_listener_v1.slb_listener : slb_listener.name => slb_listener.id }
}

output "slb_certificates" {
  value = { for certificate in cloudplatform_slb_certificate_v1.slb_certificate : certificate.name => certificate.id }
}
