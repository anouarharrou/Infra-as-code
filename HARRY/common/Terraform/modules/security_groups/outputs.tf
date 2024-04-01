output "id_list" {
  value = [for secgroup in cloudplatform_compute_security_group_v2.secgroups : secgroup.id]
}

output "name_list" {
  value = [for secgroup in cloudplatform_compute_security_group_v2.secgroups : secgroup.name]
}

output "id_mappedby_name" {
  value = { for secgroup in cloudplatform_compute_security_group_v2.secgroups : secgroup.name => secgroup.id }
}