output "id_list" {
  value = cloudplatform_vcs_server_v1.vms[*].id
}

output "name_list" {
  value = cloudplatform_vcs_server_v1.vms[*].name
}

output "ip_list" {
  value = cloudplatform_vcs_server_v1.vms[*].ipv4
}

output "vcs_name_fqdn" {
  value = { for server in cloudplatform_vcs_server_v1.vms : server.name => server.fqdn }
}

output "vcs_name_id" {
  value = { for server in cloudplatform_vcs_server_v1.vms : server.name => server.id }
}