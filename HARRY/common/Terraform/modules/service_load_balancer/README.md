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
| cloudplatform_slb_certificate_v1.slb_certificate | resource |
| cloudplatform_slb_healthcheck_v1.health_check | resource |
| cloudplatform_slb_http_policy_v1.http_policy | resource |
| cloudplatform_slb_listener_v1.slb_listener | resource |
| cloudplatform_slb_load_balancer_v1.slb | resource |
| cloudplatform_slb_pool_v1.pool | resource |
| cloudplatform_slb_vip_v1.vip | resource |
| cloudplatform_compute_instances.vms | data source |
| cloudplatform_slb_ssl_profile.ssl_profiles | data source |
| cloudplatform_slb_subnet.slb_subnet | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The availability zone | `string` | n/a | yes |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | n/a | <pre>map(object({<br><br>    # x509 certificate in PEM format<br>    certificate = string<br><br>    # x509 private key passphrase<br>    passphrase = string<br><br>    # x509 private key in PEM Encrypted format <br>    private_key = string<br>  }))</pre> | n/a | yes |
| <a name="input_health_checks"></a> [health\_checks](#input\_health\_checks) | HealthCheck | <pre>map(object({<br><br>    #Frequency of healthcheck (Choose between SLOW, STANDARD and AGGRESSIVE)<br>    health_check_type = string<br><br>    #Protocol of healthcheck (Either TCP or HTTP)<br>    protocol = string<br><br>    # If protocol is HTTP, it is mandatory . It is the HTTP Request tested during the healthcheck<br>    http_request = string<br><br>    #Target Port for healthcheck<br>    port = number<br><br>    # SSL profile name to use<br>    ssl_profile_name = string<br><br>  }))</pre> | n/a | yes |
| <a name="input_http_policies"></a> [http\_policies](#input\_http\_policies) | HTTP\_POLICY | <pre>map(object({<br><br>    request = object({<br>      case     = string<br>      criteria = string<br>      str      = string<br>      type     = string<br>    })<br><br>    #Pool name to associate to this http_policy<br>    pool_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | # Listeners | <pre>map(object({<br>    # The listener port<br>    port = number<br><br>    # if protocol is TCP, Proxy protocol could be set to VERSION_1 or VERSION_2<br>    proxy_protocol = string<br><br>    # Protocol of the listener (TCP / HTTP / UDP / HTTPS)<br>    protocol = string<br><br>    # If protocol is HTTP/HTTPS, inject X-Forwarded-For header<br>    xff = bool<br><br>    # List of tags of the resource<br>    tags = set(string)<br><br>    # Pool name to associate to the listener<br>    pool_name = string<br><br>    # List of HTTP policy names for routing requests<br>    http_policies_names = list(string)<br><br>    # SSL certificate name that will be used to secure<br>    certificate_name = string<br><br>    # VIP Name<br>    vip_name = string<br><br>    # SSL profile name<br>    ssl_profile_name = string<br><br>    # Optional, only possible for protocol HTTP/HTTPS: Ratelimiter parameter<br>    http_rate_limits = list(object({<br>      # 2 possible values : CLIENT_IP_REQUESTS_RATE_LIMIT, CLIENT_IP_TO_URI_REQUESTS_RATE_LIMIT <br>      http_rate_limit_type = string<br><br>      # Limit of number of request per time_period<br>      threshold = number<br><br>      # Time period (in seconds)<br>      time_period = number<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_name_key"></a> [name\_key](#input\_name\_key) | The name of the load balancer | `string` | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | # Pools | <pre>map(object({<br><br>    #The dispatching algorithm between backend servers (Either : ROUNDROBIN or LEASTCONNECTION)<br>    algorithm = string<br><br>    #The stickyness algorithm (Either COOKIE (only for listener in HTTP), SOURCEIP or NONE)<br>    persistence = string<br><br>    #The backend listening port<br>    port = number<br><br>    #The pool type . At April 2020, 3 possibles values : 'OCS','VCS', 'SGCLOUD'<br>    type = string<br><br>    #Method to update pool member<br>    replace_members_on_update = bool<br><br>    #The timeout for the persistence source ip in minutes (Possible values: 5, 15, 60, 120)<br>    persistence_source_ip_timeout = number<br><br>    # List of server name to add to the pool<br>    real_server_names = list(string)<br><br>    # List of server name to disable in the pool<br>    real_server_disabled_names = list(string)<br><br>    # Healt_check name<br>    health_check_name = string<br><br>    # SSL profile name to use<br>    ssl_profile_name = string<br><br>  }))</pre> | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The resource prefix | `string` | n/a | yes |
| <a name="input_slb_type"></a> [slb\_type](#input\_slb\_type) | 2 possibles values :( BASIC / PREMIUM ): Service class of the load balancer | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Subnet name for all vips will be created for this SLB | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags of the resource | `list(string)` | `[]` | no |
| <a name="input_vips"></a> [vips](#input\_vips) | n/a | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_slb_certificates"></a> [slb\_certificates](#output\_slb\_certificates) | n/a |
| <a name="output_slb_healthchecks"></a> [slb\_healthchecks](#output\_slb\_healthchecks) | n/a |
| <a name="output_slb_id"></a> [slb\_id](#output\_slb\_id) | The slb id |
| <a name="output_slb_listeners"></a> [slb\_listeners](#output\_slb\_listeners) | n/a |
| <a name="output_slb_pools"></a> [slb\_pools](#output\_slb\_pools) | n/a |
| <a name="output_slb_vips"></a> [slb\_vips](#output\_slb\_vips) | n/a |
