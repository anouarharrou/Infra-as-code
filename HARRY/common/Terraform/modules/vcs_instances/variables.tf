variable "resource_prefix" {
  description = "The prefix to add to all resource names"
  type        = string
}

variable "name_key" {
  description = "name of the vcs instance"
  type        = string
}

variable "instance_count" {
  description = "Number of servers to be created"
  type        = number
}

variable "names_override" {
  description = "The display/human name of the VMs - replacing the ones generated from resource_prefix + name_key + index"
  type        = list(string)
  default     = null
}

variable "description" {
  description = "The display/human description of the VM"
  type        = string
}

variable "tags" {
  description = "List of tags of the resource"
  type        = set(string)
}

variable "availability_zones" {
  description = "The AZ list of the VMs. The first VM will be on the first AZ, the second VM on the second one, and so on. If count > length(availability_zones), this list wraps around (modulo)"
  type        = list(string)
}

variable "flavor" {
  description = "The name of the Flavor of the VM (like the instance_type for AWS)"
  type        = string
}

variable "image" {
  description = "The name of the OS Image of the VM (like the AMI in AWS)"
  type        = string
}

variable "network" {
  description = "The name of the Network the VM will be connected to"
  type        = string
}

variable "lease" {
  description = "Specify a value in days (set 0 to have an infinite lease). The machine will be destroyed at the end of the lease. Be careful, this value is set to 1 day if not specified"
  type        = number
}

variable "disk_size" {
  description = "Data disk size of the server in GB. Specify a value between 1 and 2048 GB"
  type        = number
}

variable "security_groups" {
  description = "The list of references to security groups to set on the ports (with name_key or full_name)"
  type        = list(map(string))
  default     = [{ full_name = "default" }]
  validation {
    condition = alltrue([for secgroup_ref in var.security_groups :
      length(secgroup_ref) == 1 && (
        contains(keys(secgroup_ref), "name_key") ||
        contains(keys(secgroup_ref), "full_name")
      )
    ])
    error_message = "References to security groups must contain exactly one key (name_key or full_name)."
  }
}

variable "security_group_id_mappedby_name" {
  description = "List of all the ids of security groups mapped by name"
  type        = map(string)
}

variable "with_micro_segmentation" {
  description = "Enable micro segmentation or zero trust model on the VM. When enabled, behaviour is default deny for inbound connections"
  type        = bool
}

variable "metadata" {
  description = "Map of metadata of the resource"
  type        = map(string)
}

variable "modules" {
  description = "Set of modules installed on the instance"
  type = list(object({
    # The module name must be the same as specified by CMAAS API, see the API here (GET /modules to see the public modules)
    name = string

    # Parameters of the Puppet module
    parameters = map(string)

    # Wait for completion of the module application
    wait_for_completion = string
  }))
}

variable "check_public_modules" {
  description = "Check if the given modules are public modules"
  type        = bool
}

variable "msp_service_level" {
  description = "MSP service level (Premium or Standard)"
  type        = string
}