variable "enabled" {
    default = true
    description = "Enable module or not"
    type = bool
}

variable "project" {
  type        = string
  description = "Project name"
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


variable "tags" {
    default = {}
    type = map  
}

variable "internal" {
    default = true
    type = bool 
}

variable "load_balancer_type" {
  default = "application"
  type = string 
}

variable "sg_ids" {
    default = []
    type = list 
}

variable "subnet_ids" {
  default = []
  type = list
}

variable "enable_deletion_protection" {
  default = false 
  type = bool
}

variable "idle_timeout" {
    default  = 60 
    type = number
}

variable "enable_http2" {
    default = true 
    type = bool 
}

variable "ip_address_type" {
  default = "ipv4"
  type = string 
}

variable "log_bucket" {
    default = ""
    type = string
  
}

variable "log_prefix" {
    default = ""
    type = string
  
}

variable "drop_invalid_header_fields" {
  default = null
  type = bool
}








