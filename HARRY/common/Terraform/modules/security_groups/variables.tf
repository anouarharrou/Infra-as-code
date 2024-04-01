variable "resource_prefix" {
  description = "The prefix to add to all resource names"
  type        = string
}

# Note: we had to create all the security groups in the same instance of the module to resolve order problem with remte_type=securityGroupName
variable "security_groups" {
  description = "Network access rules to limit the types of traffic that have access to instances"
  type = map(object({
    # The description of the security group
    description = string # default = ""

    # The tags of the security group
    tags = set(string) # default = []

    # The tags of the security group
    ecosystem = string # default = "ocs"

    # The rules of the security group
    rules = list(object({
      # The description of the security rule
      description = string # default = ""

      # The direction of the allowed flow. 2 possibles values : ingress or egress
      direction = string

      # The type of remote definition. At April 2020, 2 possibles values ipRange or securityGroupId
      # + custom value securityGroupName defined by the security_group module
      remote_type = string

      # * If remote_type is ipRange the CIDR block allowed
      # * If remote_type is securityGroupId, the UUID of the security group allowed
      # * If remote_type is securityGroupName, the name of the security group allowed
      remote_value = string

      # The layer 3 protocol. At April 2020, only one value IPv4
      ether_type = string # default = IPv4

      # The (layer 4) protocol. Example : tcp, udp, icmp
      protocol = string

      # The port_range allowed, should be in `x-y` format:
      # * 80-80 to allow the port tcp/80 if protocol is tcp
      # * 1024-65535 to allow ports 1024 to 65535 in tcp if protocol is tcp
      # * 8-8 to allow icmp message ECHO if protocol is icmp
      # If missing, all the protocol is allowed
      port_range = string # default = null
    }))
  }))
}
