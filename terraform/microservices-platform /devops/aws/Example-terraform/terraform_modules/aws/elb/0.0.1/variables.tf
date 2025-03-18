variable "project" {
  type        = string
  description = "Project name"
}

variable "type" {
  default     = "int"
  type        = string
  description = "lb ext or int"
}


variable "enabled" {
  default = true
  type    = bool
}


variable "region" {
  type        = string
  description = "Region name"
}

variable "env" {
  type        = string
  description = "Enviroment name "
}

variable "svc" {
  type        = string
  description = "Name of service"
}

# variable "availability_zones" {
#   type = list 
#   description = "List of availability zones"
# }

variable "cross_zone_load_balancing" {
  default     = true
  type        = bool
  description = "Enable cross-zone load balancing"
}

variable "idle_timeout" {
  default     = 60
  type        = number
  description = "he time in seconds that the connection is allowed to be idle"
}

variable "connection_draining" {
  default     = true
  type        = bool
  description = "Boolean to enable connection draining"
}

variable "connection_draining_timeout" {
  default     = 300
  type        = number
  description = "The time in seconds to allow for connections to drain."
}

variable "tags" {

  default     = {}
  description = "Additional tags for instances launch"
}

variable "security_groups" {
  default = []
  type    = list

}

variable "subnets" {
  default = []
  type    = list

}

variable "listeners" {
  default = []
  type    = list
}

variable "instances" {
  default     = []
  type        = list
  description = "List of instances"
}


variable "access_log_enabled" {
  default = false
}

variable "access_log_bucket" {
  type = string
}


variable "access_log_prefix" {
  default = ""
}


variable "access_log_interval" {
  default = 60
}

variable "healthy_threshold" {
  default = 2
}


variable "unhealthy_threshold" {
  default = 3
}

variable "health_timeout" {
  default = 5
}

variable "health_target" {
  default = "/"
}

variable "health_interval" {
  default = 30
}