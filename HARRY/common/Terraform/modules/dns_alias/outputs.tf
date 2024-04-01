
output "dns_fqdn" {
  value       = cloudplatform_dns_alias.alias[*].fqdn
  description = "DNS alias fqdn "
}
