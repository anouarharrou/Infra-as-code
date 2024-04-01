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
| cloudplatform_pki_certificate_subject_v2.cert | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ca_short_name"></a> [ca\_short\_name](#input\_ca\_short\_name) | Certificate authority short name. | `string` | n/a | yes |
| <a name="input_get_crypto_assets"></a> [get\_crypto\_assets](#input\_get\_crypto\_assets) | permit to get crypto assets directly from pki | `bool` | n/a | yes |
| <a name="input_name_key"></a> [name\_key](#input\_name\_key) | The display/human name of the certificate (without resource\_prefix and index) | `string` | n/a | yes |
| <a name="input_notifications_callback_payload"></a> [notifications\_callback\_payload](#input\_notifications\_callback\_payload) | A specific payload to include in the callback request for certificate notifications. | `map` | `{}` | no |
| <a name="input_notifications_callback_url"></a> [notifications\_callback\_url](#input\_notifications\_callback\_url) | The Url to be used for the callback request for certificate notifications | `string` | `"https://tf-pki-test.fr.world.socgen/testing"` | no |
| <a name="input_notifications_email"></a> [notifications\_email](#input\_notifications\_email) | Technical contact for this certificate | `string` | n/a | yes |
| <a name="input_notifications_ticketing_group"></a> [notifications\_ticketing\_group](#input\_notifications\_ticketing\_group) | assignment group to be used if you need a ticket | `string` | `"gts_par_mkt_sec_tsv"` | no |
| <a name="input_remove_name_on_delete"></a> [remove\_name\_on\_delete](#input\_remove\_name\_on\_delete) | This flag permits to remove some (or all) of the reserved names on the SAN. | `set(string)` | `[]` | no |
| <a name="input_subject"></a> [subject](#input\_subject) | Subject Keys parameters | <pre>object({<br>    # Country Code for the Certificate<br>    C = string<br><br>    # Location for the Certificate<br>    L = string<br><br>    # ST for the Certificate<br>    ST = string<br><br>    # Organization for the Certificate<br>    O = string<br><br>    # Organizational Unit for the Certificate<br>    OU = string<br><br>    # CommonName for the Certificate<br>    CN = string<br><br>  })</pre> | n/a | yes |
| <a name="input_subject_alt_names"></a> [subject\_alt\_names](#input\_subject\_alt\_names) | List of Subject Alternative Names to be used | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of assets where you will install the certificate. | `set(string)` | <pre>[<br>  "FQDN",<br>  "alias",<br>  "IPs",<br>  "IP:PORT"<br>]</pre> | no |
| <a name="input_wait_for_revocation"></a> [wait\_for\_revocation](#input\_wait\_for\_revocation) | Wheither you want to wait for the revocation at delete | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert"></a> [cert](#output\_cert) | n/a |
| <a name="output_cert_passphrase"></a> [cert\_passphrase](#output\_cert\_passphrase) | n/a |
| <a name="output_cert_pem"></a> [cert\_pem](#output\_cert\_pem) | n/a |
| <a name="output_cert_private_key_no_passphrase"></a> [cert\_private\_key\_no\_passphrase](#output\_cert\_private\_key\_no\_passphrase) | n/a |
