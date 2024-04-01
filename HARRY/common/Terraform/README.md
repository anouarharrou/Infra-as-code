<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_osfactory_images"></a> [osfactory\_images](#module\_osfactory\_images) | ./modules/osfactory_image | n/a |
| <a name="module_ocs_instances"></a> [ocs\_instances](#module\_ocs\_instances) | ./modules/ocs_instances | n/a |
| <a name="module_ocs_ports"></a> [ocs\_ports](#module\_ocs\_ports) | ./modules/ocs_ports | n/a |
| <a name="module_security_groups"></a> [security\_groups](#module\_security\_groups) | ./modules/security_groups | n/a |
| <a name="module_block_storage_volumes"></a> [block\_storage\_volumes](#module\_block\_storage\_volumes) | ./modules/block_storage_volumes | n/a |
| <a name="module_file_storage_consistency_groups"></a> [file\_storage\_consistency\_groups](#module\_file\_storage\_consistency\_groups) | ./modules/file_storage_consistency_group | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The short name of your application | `string` | n/a | yes |
| <a name="input_infra_env"></a> [infra\_env](#input\_infra\_env) | The name of the environment to deploy to (dev, homol, prod, ...) | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The Cloud platform region (example : eu-fr-paris, eu-fr-north, etc) | `string` | n/a | yes |
| <a name="input_osf_images"></a> [osf\_images](#input\_osf\_images) | Map of images | `any` | `{}` | no |
| <a name="input_ocs_instances"></a> [ocs\_instances](#input\_ocs\_instances) | Map of instances | `any` | `{}` | no |
| <a name="input_ocs_ports"></a> [ocs\_ports](#input\_ocs\_ports) | Map of ports | `any` | `{}` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Network access rules to limit the types of traffic that have access to instances | `any` | `{}` | no |
| <a name="input_dns_aliases"></a> [dns\_aliases](#input\_dns\_aliases) | Map of DNS Aliases | `any` | `{}` | no |
| <a name="input_block_storage_volumes"></a> [block\_storage\_volumes](#input\_block\_storage\_volumes) | Map of volumes | `any` | `{}` | no |
| <a name="input_file_storage_consistency_groups"></a> [file\_storage\_consistency\_groups](#input\_file\_storage\_consistency\_groups) | Map of consistency groups with nested filesystems | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ocs_ports_ip"></a> [ocs\_ports\_ip](#output\_ocs\_ports\_ip) | Map of {port\_name => port\_ip} |
| <a name="output_block_storage_volumes_mount_point"></a> [block\_storage\_volumes\_mount\_point](#output\_block\_storage\_volumes\_mount\_point) | Map of {volume\_name => volume\_mount\_point} |
| <a name="output_file_storage_filesystems_mount_device"></a> [file\_storage\_filesystems\_mount\_device](#output\_file\_storage\_filesystems\_mount\_device) | Map of {consistency\_group\_name => {filesystem\_name => filesystem\_mount\_device}} |
<!-- END_TF_DOCS -->
