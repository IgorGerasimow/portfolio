variable "region" {
  type = string
}

variable "env" {
  type = string 
}

variable "svc" {
  default = "platform"
  type = string 
}

variable "project" {
  default = "tgm"
  type = string 
}

variable "certificate" {
  type = list 
  default = []
}

variable "lb" {
    type = map 
    default = {}
}

variable "target_group" {
    type = map 
    default = {}
}

variable "eks" {
    type = map 
    default = {}
}

variable "control_domain_dns" {
  type = string
}

variable "alb_dns_names" {
  type = list 
  default = []
}


variable "remote_bucket_source" {
  type = map
  default = {
    tgm = "tgm-devops-use1-tfstate-prod" 
    }
}

variable "namespaces" {
  default = []
  type = list
}

variable "cloudfront" {
  default = []
  type = list
}

variable "rds" {
  type = map  
}
