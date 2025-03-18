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

variable "sg_ids" {
    default = []
    type = list 
}

variable "subnet_ids" {
  default = []
  type = list
}

variable "lb_arn" {
    type = string
  
}

variable "vpc_id" {
    type = string
  
}

variable "port" {
  type = number
}

variable "listener_port" {
  type = number
  default = 0 
  description = "If 0 port number will be user"
}

variable "protocol" {
  type = string
}

variable "listener_protocol" {
  type = string
}


variable "action" {
  default = "forward"
  type = string
}

variable "ssl_policy" {
    default = "ELBSecurityPolicy-2016-08"
    type = string
  
}


variable "certificate_arn" {
    default = null
    type = string
  
}


variable "tags" {
    default = {}
    type = map
  
}

variable "deregistration_delay" {
  default = 300
  type = number
  
}

variable "slow_start" {
  default = 0 
  type = number
}

variable "load_balancing_algorithm_type" {
  default = "round_robin"
  type = string
}

variable "proxy_protocol_v2" {
  default = null
  type = bool
}

variable "target_type" {
  default = "instance"
  type = string
}

variable "cookie_duration" {
  default = 86400
  type = number
}

variable "stickiness_enabled" {
  default = false
  type = bool
}

variable "healthcheck_interval" {
  default = 10
  type = number
}

variable "healthcheck_port" {
  default = "traffic-port"
  type = string
}

variable "healthcheck_protocol" {
  default = "HTTP"
  type = string
}

variable "healthcheck_path" {
  default = "/"
  type = string
}

variable "healthcheck_timeout" {
  default = 6
  type = number
}

variable "healthcheck_healthy_threshold" {
  default = 3
  type = number
}

variable "healthcheck_unhealthy_threshold" {
  default = 3
  type = number
}

variable "healthcheck_mathcer" {
  default = "200"
  type = string
}







