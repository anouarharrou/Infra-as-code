
variable "availability_zone" {
  type        = string
  description = "The availability zone"
}

variable "slb_type" {
  type        = string
  description = "2 possibles values :( BASIC / PREMIUM ): Service class of the load balancer"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name for all vips will be created for this SLB"
}

variable "name_key" {
  type        = string
  description = "The name of the load balancer"
}

variable "tags" {
  description = "List of tags of the resource"
  type        = list(string)
  default     = []
}

variable "resource_prefix" {
  description = "The resource prefix"
  type        = string
}

variable "vips" {
  type = list(string)
}

## Pools
variable "pools" {
  type = map(object({

    #The dispatching algorithm between backend servers (Either : ROUNDROBIN or LEASTCONNECTION)
    algorithm = string

    #The stickyness algorithm (Either COOKIE (only for listener in HTTP), SOURCEIP or NONE)
    persistence = string

    #The backend listening port
    port = number

    #The pool type . At April 2020, 3 possibles values : 'OCS','VCS', 'SGCLOUD'
    type = string

    #Method to update pool member
    replace_members_on_update = bool

    #The timeout for the persistence source ip in minutes (Possible values: 5, 15, 60, 120)
    persistence_source_ip_timeout = number

    # List of server name to add to the pool
    real_server_names = list(string)

    # List of server name to disable in the pool
    real_server_disabled_names = list(string)

    # Healt_check name
    health_check_name = string

    # SSL profile name to use
    ssl_profile_name = string

  }))
}

## Listeners
variable "listeners" {
  type = map(object({
    # The listener port
    port = number

    # if protocol is TCP, Proxy protocol could be set to VERSION_1 or VERSION_2
    proxy_protocol = string

    # Protocol of the listener (TCP / HTTP / UDP / HTTPS)
    protocol = string

    # If protocol is HTTP/HTTPS, inject X-Forwarded-For header
    xff = bool

    # List of tags of the resource
    tags = set(string)

    # Pool name to associate to the listener
    pool_name = string

    # List of HTTP policy names for routing requests
    http_policies_names = list(string)

    # SSL certificate name that will be used to secure
    certificate_name = string

    # VIP Name
    vip_name = string

    # SSL profile name
    ssl_profile_name = string

    # Optional, only possible for protocol HTTP/HTTPS: Ratelimiter parameter
    http_rate_limits = list(object({
      # 2 possible values : CLIENT_IP_REQUESTS_RATE_LIMIT, CLIENT_IP_TO_URI_REQUESTS_RATE_LIMIT 
      http_rate_limit_type = string

      # Limit of number of request per time_period
      threshold = number

      # Time period (in seconds)
      time_period = number
    }))
  }))
}


# HTTP_POLICY
variable "http_policies" {
  type = map(object({

    request = object({
      case     = string
      criteria = string
      str      = string
      type     = string
    })

    #Pool name to associate to this http_policy
    pool_name = string
  }))
}

# HealthCheck
variable "health_checks" {

  type = map(object({

    #Frequency of healthcheck (Choose between SLOW, STANDARD and AGGRESSIVE)
    health_check_type = string

    #Protocol of healthcheck (Either TCP or HTTP)
    protocol = string

    # If protocol is HTTP, it is mandatory . It is the HTTP Request tested during the healthcheck
    http_request = string

    #Target Port for healthcheck
    port = number

    # SSL profile name to use
    ssl_profile_name = string

  }))

}

variable "certificates" {
  type = map(object({

    # x509 certificate in PEM format
    certificate = string

    # x509 private key passphrase
    passphrase = string

    # x509 private key in PEM Encrypted format 
    private_key = string
  }))

}