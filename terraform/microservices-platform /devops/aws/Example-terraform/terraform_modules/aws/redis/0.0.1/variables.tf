variable "project" {
  type        = string
  description = "Project name"
}

variable "enabled" {
  default = true
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

variable "security_groups" {
  type        = list
  default     = []
  description = "Lists of security list for instances"
}

variable "subnet_ids" {
  type        = list
  default     = []
  description = "Lists of subnets"
}
# Reds=is 
variable "engine_version" {
  default     = "5.0.6"
  type        = string
  description = "Redis engine version"
}

variable "port" {
  default     = 6379
  type        = number
  description = "Redis port"
}

variable "maintenance_window" {
  default     = "sun:05:00-sun:09:00"
  type        = string
  description = "Redis maintanance window"
}

variable "num_cache_nodes" {
  default     = 1
  type        = number
  description = "Number of nodes in cluster"
}

variable "node_type" {
  type        = string
  description = "Node type for redis"
}


variable "parameter_group_name" {
  default     = "default.redis5.0.cluster.on"
  type        = string
  description = "Parameter group name"
}

variable "automatic_failover_enabled" {
  default = true

}


variable "apply_immediately" {
  default     = false
  type        = bool
  description = "apply changes immediatly"
}

variable "snapshot_arns" {
  default = []
}

variable "snapshot_name" {
  default = ""
}

variable "notification_topic_arn" {
  default = ""
}


variable "snapshot_window" {
  default = "03:00-05:00"
}

variable "snapshot_retention_limit" {
  default     = 0
  type        = number
  description = "How many snapshop save, 0 - off"
}


variable "tags" {
  default     = {}
  type        = map
  description = "Additional tags"
}

variable "at_rest_encryption_enabled" {
  default     = false
  type        = bool
  description = "Encrypt cluster"
}

variable "transit_encryption_enabled" {
  default     = false
  type        = bool
  description = "Protect access via password ?"
}

variable "auth_token" {
  default     = ""
  type        = string
  description = "Password for redis access"
}

variable "kms_key_id" {
  default = ""
}

variable "num_node_groups" {
  default = 1

}

variable "replicas_per_node_group" {
  default = 2

}

