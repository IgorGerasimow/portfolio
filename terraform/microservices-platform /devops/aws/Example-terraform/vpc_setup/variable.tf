

variable "env" { }
variable "platform" {
  default = "tgmodern"
}
variable "name_platform" {
  default = "tgmodern"
}

variable "region" { 

}


variable "group" {
  default = "devops"
}

variable "subnets_int_0" {
  default = {}
}

variable "subnets_int" {
  default = {}
}

variable "subnets_ext" {
  default = {}
}

variable "subnets_ext_1" {
  default = {}
}

variable "vpc_cidr" {
  default = ""
}

variable "az_count" {
  default = 3
}

variable "route53_zone_ext" {
  
}

variable "route53_zone_int" {
  
}

variable "tag_internal" {
  
}

variable "tag_external" {
  
}


