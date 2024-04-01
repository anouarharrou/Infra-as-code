variable "name_key" {
  description = "the name of the alias that will be suffixed by the name of the zone"
  type        = string
}

variable "resource_prefix" {
  type = string
}

variable "region" {
  description = "The Cloud platform region (example : eu-fr-paris, eu-fr-north, etc)"
  type        = string
}

variable "ttl" {
  description = "TTL of The DNS record (From April 2022, minimum value is 60s)"
  type        = number
  default     = 1800
}


variable "target" {
  description = "the target of the CNAME (alias) DNS record ,reference to an fqdn directly  (with fqdn_target) or ocs port (with ocs_port_name_target)"
  type        = map(string)
  validation {
    condition = (length(var.target) == 1 && (
      contains(keys(var.target), "fqdn_target")) ||
      (contains(keys(var.target), "slb_vip_name") && contains(keys(var.target), "slb_az") && contains(keys(var.target), "slb_name")) ||
      (contains(keys(var.target), "vcs_server_name"))
    )
    error_message = "References to target must contain exactly one of these keys (fqdn_target or (slb_vip_name && slb_az && slb_name))"
  }
}

variable "tags" {
  description = "List of tags of the resource"
  type        = list(string)
  default     = []
}

variable "dns_zone" {
  description = "The DNS zone in which the alias will be created"
  type        = string
}

variable "vcs_fqdns" {
  description = "Map of vcs servers name => fqdn map"
  type        = map(map(string))
}
variable "use_prefix" {
  description = "permit to add resource prefix to dns alias name, default value is true"
  type        = bool
}
