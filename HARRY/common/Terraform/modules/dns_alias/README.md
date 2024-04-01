# DNS alias

## Description

Manage DNS alias
See [DNS documentation](https://documentation.cloud.socgen/private/products/network/dns/concepts/product_description.html).
> DNS is a service for managing Société Générale's Domain names. This service allows users to associate IPAM service IP addresses to human-friendly, readable and easy to remember names. In the same time, each IP address used in the DNS is known in the IPAM (IP Address Management).

## Example (tfvars)  

The variable `dns_aliases` is a map:   
- its keys are the `name_key` of the DNS alias to create, 
- its values are the specification of each DNS alias (see [Inputs](#inputs) below).  

This module can take `slb vip`, `ocs_port` or `traffic_manager fqdn` as target.


```terraform
dns_aliases = {
  acid_web = {
    target    = { slb_vip_name = "vip_demo", slb_az = "eu-fr-paris-1", slb_name = "master_slb" } # An example using slb vip as target
    # target  = { ocs_port_name_target = "acid_ocs_dev_vm" }  # This is an example using ocs_port (fixed ip) as target, it takes vm name_key
    # targtet = { fqdn_target = "acid-dev-traffic-manager.gslb.cloud.socgen" }  # This is an example using fqdn as target 
    ttl       = 1800
    tags      = ["acid_dev"]
    dns_zones = ["fr.world.socgen"]
  }
}
```
**Note:**
The dns will have a prefix composed by `app_name` and `env` for example : `app_name:` acid, `env`: dev  the dns alias fqdn will be `acid-dev-acid-web-dev.fr.world.socgen`

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| cloudplatform_dns_alias.alias | resource |
| cloudplatform_dns_zone.dns_zones | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | List of DNS zones in which the alias will be created | `list(string)` | n/a | yes |
| <a name="input_name_key"></a> [name\_key](#input\_name\_key) | the name of the alias that will be suffixed by the name of the zone | `string` | n/a | yes |
| <a name="input_ocs_ports"></a> [ocs\_ports](#input\_ocs\_ports) | OCS Ports created | `list(any)` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags of the resource | `list(string)` | `[]` | no |
| <a name="input_target"></a> [target](#input\_target) | the target of the CNAME (alias) DNS record ,reference to an fqdn directly  (with fqdn\_target) or ocs port (with ocs\_port\_name\_target) | `map(string)` | n/a | yes |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | TTL of The DNS record (From April 2022, minimum value is 60s) | `number` | `1800` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_fqdn"></a> [dns\_fqdn](#output\_dns\_fqdn) | DNS alias fqdn |
<!-- END_TF_DOCS -->