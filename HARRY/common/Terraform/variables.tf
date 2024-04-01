########## GLOBAL ##############################################################
variable "app_name" {
  description = "The short name of your application"
  type        = string
}

variable "infra_env" {
  description = "The name of the environment to deploy to (dev, homol, prod, ...)"
  type        = string
}

variable "region" {
  description = "The Cloud platform region (example : eu-fr-paris, eu-fr-north, etc)"
  type        = string
}

########## COMPUTE #############################################################

variable "vcs_instances" {
  description = "Map of vcs instances"
  type        = any
  default     = {}
}

########## NETWORK #############################################################

variable "security_groups" {
  description = "Network access rules to limit the types of traffic that have access to instances"
  type        = any
  default     = {}
}

########## LOADBALANCE #########################################################

variable "slb_load_balancers" {
  description = "Map of slb load balancers"
  type        = any
  default     = {}
}

variable "traffic_managers" {
  description = "Map of traffic managers"
  type        = any
  default     = {}
}

variable "dns_aliases" {
  description = "Map of DNS Aliases"
  type        = any
  default     = {}
}

variable "pki_certs" {
  description = "Map of PKI Certs"
  type        = any
  default     = {}
}