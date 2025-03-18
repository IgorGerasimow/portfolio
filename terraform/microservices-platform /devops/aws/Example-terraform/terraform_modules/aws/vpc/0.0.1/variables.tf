# Enable variable
#########
variable "vpc_enable" {
  type        = bool
  default     = true
  description = "Enable disable module"

}

variable "vpc_cidr" {
  type        = string
  description = "Cidr block for vpc"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable dns hostname in vpc"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable dns at all in vpc"
  default     = true
}

# Tags variable 
##########
variable "tags" {
  type        = map
  description = "Map of tag which will be added to all resources"
}

variable "tags_internal_subnet" {
  type        = map
  default     = {}
  description = "Map of tag which will be added to all internal subnets"
}


variable "tags_external_subnet" {
  type        = map
  default     = {}
  description = "Map of tag which will be added to all external subnets"
}

# Common Variable
#########
variable "env" {
  type        = string
  description = "Env name"
}

variable "region" {
  type        = string
  description = "Region name"
}


variable "infra_name" {
  type        = string
  description = "Some unique name for you infra, example: xc "
}

# Subnets control
##########
variable "az_count" {
  type        = number
  description = "Number of az to use"
}

variable "az_list" {
  type        = list
  description = "List of availability zones names"
}

variable "subnets_int" {
  type        = map
  description = "Map of az to internal subnets"
}

variable "subnets_ext" {
  type        = map
  description = "Map of az to dmz subnets"
}


variable "map_public_ip_on_launch_int" {
  type        = bool
  description = "Map public ip to private hosts"
  default     = false
}

variable "map_public_ip_on_launch_ext" {
  type        = bool
  description = "Map public ip to dmz hosts"
  default     = false
}

# DHCP and DNS options 
###########
variable "domain_name" {
  type        = string
  description = "domain name for internal usage"
}

variable "domain_name_servers" {
  type        = list
  description = "List of dns servers"
  default     = ["AmazonProvidedDNS"]
}

variable "ntp_servers" {
  type        = list
  description = "List of ntp servers to use"
  default     = ["169.254.169.123"]
}

variable "netbios_name_servers" {
  type        = list
  description = "Netbios servers list"
  default     = ["127.0.0.1"]
}

variable "netbios_node_type" {
  type        = number
  description = "Netbios node type"
  default     = 2
}

# ACL options 
################
variable "default_network_acl_ingress" {
  description = "List of maps of ingress rules to set on the Default Network ACL"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "default_network_acl_egress" {
  description = "List of maps of egress rules to set on the Default Network ACL"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

variable "public_inbound_acl_rules" {
  description = "Public subnets inbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "public_outbound_acl_rules" {
  description = "Public subnets outbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_inbound_acl_rules" {
  description = "Private subnets inbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_outbound_acl_rules" {
  description = "Private subnets outbound network ACLs"
  type        = list(map(string))

  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}