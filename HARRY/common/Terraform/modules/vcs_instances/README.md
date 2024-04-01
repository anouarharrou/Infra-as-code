## Description

Creates VCS instances (servers). See [vcs Virtual Server documentation](https://documentation.cloud.socgen/private/products/compute/vcs/index.html).

VCS stands for VMware Virtual Compute Instances Managed.

**Info:**

Required scopes to use this brick are: `ccs:read` and `ccs:write`.

When adding or removing Puppet modules to a node, you also need `cmaas:read` and `cmaas:write` scopes.

To allow a user to log on any machine of an account by entitling her with a role containing the right/scope `virtualserver:rp:login_linux` (formerly `virtualserver:rp:login` or `ccs:rp:login`). The password required from the user for login is the `WHATS password`.

## Example (tfvars)

The variable `vcs_instances` is a map: its keys are the `name_key` of the instances (name without global resource prefix and index suffix), and its values are the specification of each instance (see [Inputs](#inputs) below).

```terraform
vcs_instances = {
  my_instance = {
    instance_count     = 2
    description        = "my description"
    tags               = ["tag1", "tag2"]
    availability_zones = ["eu-fr-paris-1", "eu-fr-paris-2"]
    flavor             = "Small 1vCPU-2GB"
    image              = "CENTOS 7 GTS"
    network            = "DCITS_DEV"
    disk_size          = "10"
    metadata           = {
      is_example = "yes"
    }
    security_groups    = [
      { name_key = "my_security_groups" },
    ]
  }
}
```

**Note:**
  You can create **multiple instances** of the same type using the `instance_count` variable.

  - Each instance's name will be suffixed with the index of the instance (starting at 1).
  - The `availability_zones` variable specifies the AZ of each instance. In this example, the first instance will be on `eu-fr-paris-1`, and the second one will be on `eu-fr-paris-2`. If there was a third instance, it would wrap-around on the list, so it would be `eu-fr-paris-1` too.

<!-- BEGIN_TF_Dvcs -->
## Resources

| Name | Type |
|------|------|
| cloudplatform_vcs_server_v1.vms | resource |
| cloudplatform_vcs_flavor.flavor | data source |
| cloudplatform_vcs_image.image | data source |
| cloudplatform_vcs_network.network | data source |
| cloudplatform_compute_security_group_v2.security_groups | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix to add to all resource names | `string` | n/a | yes |
| <a name="input_name_key"></a> [name\_key](#input\_name\_key) | The display/human name of the VMs (without resource\_prefix and index) | `string` | n/a | yes |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create using the same name prefix (resource\_prefix, name\_key) as name | `number` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The display/human description of the VMs | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags of the resource | `set(string)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availabilty zone of each instance (one for each instance\_count), with wraparound if index is out of range (modulo) | `list(string)` | n/a | yes |
| <a name="input_flavor"></a> [flavor](#input\_flavor) | The name of the flavor of the VMs (like the instance\_type for AWS) | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | RThe name of the OS Image of the VM (like the AMI in AWS) | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The name of the Network the VM will be connected to | `string` | n/a | yes |
| <a name="input_lease"></a> [lease](#input\_lease) | A value in days (set 0 to have an infinite lease) | `number` | n/a | yes |
| <a name="input_disk_size"></a> [disk_size](#input\_disk_size) | Data disk size of the server in GB. Specify a value between 1 and 2048 GB | `number` | n/a | no |
| <a name="input_with_micro_segmentation"></a> [with_micro_segmentation](#input\_with_micro_segmentation) | Enable micro segmentation or zero trust model on the VM | `bool` | n/a | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | The list of references to security groups to set on the instances (with name\_key or full\_name). Requires `with_micro_segmentation = true` | `list(map(string))` | <pre>[<br>  {<br>    "full_name": "default"<br>  }<br>]</pre> | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Map of metadata of the resource | `map(string)` | `{}` | no |
| <a name="input_modules"></a> [modules](#input\_modules) | Set of modules installed on the instance | <pre>list(object({<br>    # The module name must be the same as specified by CMAAS API, see the API here (GET /modules to see the public modules)<br>    name = string<br><br>    # Parameters of the Puppet module<br>    parameters = map(string) # default = {}<br><br>    # Wait for completion of the module application<br>    wait_for_completion = bool # default = true<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id_list"></a> [id\_list](#output\_id\_list) | n/a |
| <a name="output_name_list"></a> [name\_list](#output\_name\_list) | n/a |
| <a name="output_ip_list"></a> [ip\_list](#output\_ip\_list) | n/a |
<!-- END_TF_Dvcs -->
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudplatform"></a> [cloudplatform](#provider\_cloudplatform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| cloudplatform_files_filesystem_nfs_client_v1.nfs_clients | resource |
| cloudplatform_os_configuration_module_v0.nfs_mounts | resource |
| cloudplatform_vcs_server_v1.vms | resource |
| cloudplatform_compute_security_group_v2.security_groups | data source |
| cloudplatform_files_consistency_groups_v1.cg | data source |
| cloudplatform_files_filesystems_v1.fs | data source |
| cloudplatform_vcs_flavor.flavor | data source |
| cloudplatform_vcs_image.image | data source |
| cloudplatform_vcs_network.network | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The AZ list of the VMs. The first VM will be on the first AZ, the second VM on the second one, and so on. If count > length(availability\_zones), this list wraps around (modulo) | `list(string)` | n/a | yes |
| <a name="input_check_public_modules"></a> [check\_public\_modules](#input\_check\_public\_modules) | Check if the given modules are public modules | `bool` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The display/human description of the VM | `string` | n/a | yes |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Data disk size of the server in GB. Specify a value between 1 and 2048 GB | `number` | n/a | yes |
| <a name="input_flavor"></a> [flavor](#input\_flavor) | The name of the Flavor of the VM (like the instance\_type for AWS) | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | The name of the OS Image of the VM (like the AMI in AWS) | `string` | n/a | yes |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of servers to be created | `number` | n/a | yes |
| <a name="input_lease"></a> [lease](#input\_lease) | Specify a value in days (set 0 to have an infinite lease). The machine will be destroyed at the end of the lease. Be careful, this value is set to 1 day if not specified | `number` | n/a | yes |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Map of metadata of the resource | `map(string)` | n/a | yes |
| <a name="input_modules"></a> [modules](#input\_modules) | Set of modules installed on the instance | <pre>list(object({<br>    # The module name must be the same as specified by CMAAS API, see the API here (GET /modules to see the public modules)<br>    name = string<br><br>    # Parameters of the Puppet module<br>    parameters = map(string)<br><br>    # Wait for completion of the module application<br>    wait_for_completion = string<br>  }))</pre> | n/a | yes |
| <a name="input_msp_service_level"></a> [msp\_service\_level](#input\_msp\_service\_level) | MSP service level (Premium or Standard) | `string` | n/a | yes |
| <a name="input_name_key"></a> [name\_key](#input\_name\_key) | name of the vcs instance | `string` | n/a | yes |
| <a name="input_names_override"></a> [names\_override](#input\_names\_override) | The display/human name of the VMs - replacing the ones generated from resource\_prefix + name\_key + index | `list(string)` | `null` | no |
| <a name="input_network"></a> [network](#input\_network) | The name of the Network the VM will be connected to | `string` | n/a | yes |
| <a name="input_nfs_mounts"></a> [nfs\_mounts](#input\_nfs\_mounts) | The list of file storage filesystems to mount on the instances) | <pre>list(object({<br>    # Reference to the consistency group created in this Terraform configuration (with name_key)<br>    consistency_group = object({<br>      name_key = string<br>    })<br><br>    # Reference to the filesystem created in this Terraform configuration (with name_key)<br>    filesystem = object({<br>      name_key = string<br>    })<br><br>    # The mountpoint (path where to mount the filesystem). For nested paths, make sure the parent directory exists<br>    target = string<br><br>    # The user that will own the mount<br>    user = string # default = "cloud-user"<br><br>    # The group of the user that will own the mount<br>    group = string # default = "cloud-user"<br><br>    # The mount options<br>    options = string # default = "defaults,vers=4.1"<br><br>    # The permission given to this server (one of 2 values : read-write and read-only)<br>    permission = string # default = "read-write"<br><br>    # The protocol used to mount the filesystem (at April 2022, only one value allowed nfs4.1)<br>    protocol = string # default = "nfs4.1"<br>  }))</pre> | `[]` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix to add to all resource names | `string` | n/a | yes |
| <a name="input_security_group_id_mappedby_name"></a> [security\_group\_id\_mappedby\_name](#input\_security\_group\_id\_mappedby\_name) | List of all the ids of security groups mapped by name | `map(string)` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | The list of references to security groups to set on the ports (with name\_key or full\_name) | `list(map(string))` | <pre>[<br>  {<br>    "full_name": "default"<br>  }<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags of the resource | `set(string)` | n/a | yes |
| <a name="input_with_micro_segmentation"></a> [with\_micro\_segmentation](#input\_with\_micro\_segmentation) | Enable micro segmentation or zero trust model on the VM. When enabled, behaviour is default deny for inbound connections | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id_list"></a> [id\_list](#output\_id\_list) | n/a |
| <a name="output_ip_list"></a> [ip\_list](#output\_ip\_list) | n/a |
| <a name="output_name_list"></a> [name\_list](#output\_name\_list) | n/a |
<!-- END_TF_DOCS -->