data "cloudplatform_vcs_flavor" "flavor" {
  name = var.flavor
}

data "cloudplatform_vcs_image" "image" {
  name = var.image
}

data "cloudplatform_vcs_network" "network" {
  count = var.instance_count

  name              = var.network
  availability_zone = element(var.availability_zones, count.index)
}

locals {
  #Retrieve list of ids of security_groups refecrenced by name_key
  security_groups_ids_refby_namekey = [
    for sg in var.security_groups : var.security_group_id_mappedby_name["${var.resource_prefix}${sg["name_key"]}"] if contains(keys(sg), "name_key")
  ]

  #Retrieve list of full_names of security_groups refecrenced by full_name
  security_groups_refby_fullname = [
    for sg in var.security_groups : sg["full_name"] if contains(keys(sg), "full_name")
  ]
}

data "cloudplatform_compute_security_group_v2" "security_groups" {
  count = length(local.security_groups_refby_fullname)

  name = local.security_groups_refby_fullname[count.index]
}

resource "cloudplatform_vcs_server_v1" "vms" {

  count = var.instance_count

  name                    = var.names_override != null ? var.names_override[count.index] : "${var.resource_prefix}${var.name_key}_${count.index + 1}"
  description             = var.description
  tags                    = var.tags
  availability_zone       = element(var.availability_zones, count.index) #Use element() to wrap-around the list of availabiltity_zones
  flavor_ref              = data.cloudplatform_vcs_flavor.flavor.id
  image_ref               = data.cloudplatform_vcs_image.image.id
  network                 = data.cloudplatform_vcs_network.network[count.index].id
  lease                   = var.lease
  metadata                = var.metadata
  check_public_modules    = var.check_public_modules
  disk_size               = var.disk_size
  security_groups         = concat(data.cloudplatform_compute_security_group_v2.security_groups[*].id, local.security_groups_ids_refby_namekey)
  with_micro_segmentation = var.with_micro_segmentation
  msp_service_level       = var.msp_service_level
  dynamic "modules" {
    for_each = var.modules
    content {
      name                = modules.value.name
      parameters          = modules.value.parameters
      wait_for_completion = modules.value.wait_for_completion
    }
  }
}