# <img alt="Security Group" src="https://insights.eu-fr-paris.cloud.socgen/api/internal/logos/64fced15-0007-4439-a083-93883fa5dc36?type=domain&height=56&width=56" style="vertical-align: middle"> Security Groups

## Description

Creates security groups for either OCS or VCS instances.
See [Security Group documentation](https://documentation.cloud.socgen/private/products/network/security_group/index.html).
Security groups control which traffic should be allowed into or from its compute instances.

Required scopes to use this brick are: `psg:read` and `psg:write`.

## Example (tfvars)

The variable `security_groups` is a map: its keys are the `name_key` of the security groups (name without global resource prefix), and its values are the specification of each security group (see [Inputs](#inputs) below).

1. Creating the security groups and rules:

    ```terraform
    security_groups = {
      http_all = {
        description = "ingress: https-8080 (from any IP)"
        tags        = ["https", "any"]
        ecosystem   = "ocs"
        rules = [
          {
            description  = "ingress: https-8080 (from any IP)"
            direction    = "ingress"
            remote_type  = "ipRange"
            remote_value = "0.0.0.0/0"
            protocol     = "tcp"
            port_range   = "8080-8080"
          },
        ]
      }
      http_internal = {
        description = "ingress: https-8080 (from common sg)"
        tags        = ["https", "internal"]
        ecosystem   = "ocs"
        rules = [
          {
            description  = "ingress: https-8080 (from common sg)"
            direction    = "ingress"
            remote_type  = "securityGroupName"
            remote_value = "common"
            protocol     = "tcp"
            port_range   = "8080-8080"
          },
        ]
      }
      common = {
        description = "ingress: icmp+ssh (from any IP)"
        tags        = ["common"]
        ecosystem   = "ocs"
        rules = [
          {
            description  = "icmp ingress"
            direction    = "ingress"
            remote_type  = "ipRange"
            remote_value = "0.0.0.0/0"
            protocol     = "tcp"
            port_range   = "22-22"
          },
          {
            description  = "icmp ingress"
            direction    = "ingress"
            remote_type  = "ipRange"
            remote_value = "0.0.0.0/0"
            protocol     = "icmp"
            port_range   = "8-8"
          },
        ]
      }
    }
    ```

    **Tip:**
      You can create a `common` security group and associate it to all of your instances to define rules that should apply to every instance.

    **Note:**
      Remote type `securityGroupName` or `securityGroupId` can be used to allow network traffic to/from all of the instances that are associated to the specified security group.
      This is useful to restrict rules to internal traffic without having to hardcode IP addresses.

2. Associating the security groups to OCS or VCS instances:

    * OCS

        ```terraform
        ocs_ports = {
          my_ports = {
            port_count = 2
            ...
            security_groups = [
              { name_key  = "common" },
              { name_key  = "http_internal" },
              { full_name = "my_external_secgroup" },
            ]
            ...
          }
        }

        ocs_instances = {
          my_instances = {
            instance_count = 2
            ...
            ports = { name_key = "my_ports" }
            ...
          }
        }
        ```

        **Info:**
          Security groups associated to OCS instances must be created with argument `ecosystem = "ocs"`.

    * VCS

        ```terraform
        vcs_servers = {
          my_servers = {
            server_count = 2
            ...
            security_groups = [
              { name_key  = "common" },
              { name_key  = "http_internal" },
              { full_name = "my_external_secgroup" },
            ]
            with_micro_segmentation = true
            ...
          }
        }
        ```

        **Info:**
          Security groups associated to VCS instances must be created with argument `ecosystem = "vcs"`.

    **Warning:**
      `name_key` must be used to reference security groups created in Terraform, or `full_name` otherwise.
      When using `name_key`, you must provide the name of the key from the `security_groups` map (`full_name` without the global name prefix).

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| cloudplatform_compute_security_group_v2.secgroups | resource |
| cloudplatform_compute_security_rule_v2.rules | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the security group | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags of the security group | `set(string)` | `[]` | no |
| <a name="input_ecosystem"></a> [ecosystem](#input\_ecosystem) | The target ecosystem of the security group (ocs or vcs) | `string` | `"ocs"` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | The rules of the security group | `list(object)` | `[]` | no |

Objects in the `rules` list may contain the following arguments:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the security rule | `string` | `""` | no |
| <a name="input_direction"></a> [direction](#input\_direction) | The direction of the allowed flow. 2 possibles values : ingress or egress | `string` | n/a | yes |
| <a name="input_remote_type"></a> [remote\_type](#input\_remote\_type) | The type of remote definition: ipRange, securityGroupId, or securityGroupName | `string` | n/a | yes |
| <a name="input_remote_value"></a> [remote\_value](#input\_remote\_value) | <ul><li>If remote\_type is ipRange the CIDR block allowed</li><li>If remote\_type is securityGroupId, the UUID of the security group allowed</li><li>If remote\_type is securityGroupName, the name of the security group allowed</li></ul> | `string` | n/a | yes |
| <a name="input_ether_type"></a> [ether\_type](#input\_ether\_type) | The layer 3 protocol. At April 2020, only one value IPv4 | `string` | `"IPv4"` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | The (layer 4) protocol. Example : tcp, udp, icmp | `string` | n/a | yes |
| <a name="input_port_range"></a> [port\_range](#input\_port\_range) | The port\_range allowed, should be in `x-y` format:<ul><li>80-80 to allow the port tcp/80 if protocol is tcp</li><li>1024-65535 to allow ports 1024 to 65535 in tcp if protocol is tcp</li><li>8-8 to allow icmp message ECHO if protocol is icmp</li></ul>If missing, all the protocol is allowed | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id_list"></a> [id\_list](#output\_id\_list) | n/a |
| <a name="output_name_list"></a> [name\_list](#output\_name\_list) | n/a |
<!-- END_TF_DOCS -->
