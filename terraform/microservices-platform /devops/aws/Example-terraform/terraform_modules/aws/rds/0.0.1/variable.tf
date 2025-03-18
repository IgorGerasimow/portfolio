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

variable "tags" {

  default     = {}
  description = "Additional tags for db"
}

# Network 

variable "availability_zone" {
  default = null
  type        = string
  description = "Availability zone for db"
}

variable "multi_az" {
  default     = false
  type        = bool
  description = "Should it be multi az "
}

variable "publicly_accessible" {
  default     = false
  type        = bool
  description = "Should db pulicly accessible"
}


variable "subnets" {
  type        = list
  description = "List of subnets where it should run"
}

variable "vpc_security_group_ids" {
  type        = list
  description = "List of seg_groups where it should run"
}

# Instances and db type  

variable "engine" {
  type        = string
  description = "DB engine"
}

variable "engine_version" {
  type        = string
  description = "DB engine version"
}

variable "instance_class" {
  type        = string
  description = "DB instance aws type"

}


variable "allocated_storage" {
  default     = 15
  type        = number
  description = "Storage size"
}

variable "storage_type" {
  default     = "gp2"
  type        = string
  description = "Storage size"
}

variable "iops" {
  default     = 0
  type        = number
  description = "Storage size"
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}

variable "username" {
  type        = string
  description = "Main db username"
}

variable "password" {
  type        = string
  description = "Main db username"
}

# Backup and monitoring 

variable "backup_retention_period" {
  type        = number
  default     = 10
  description = "Retain backup time 0-35"
}

variable "backup_window" {
  default     = "05:00-06:00"
  type        = string
  description = "When craate backup"
}

variable "copy_tags_to_snapshot" {
  default     = true
  type        = bool
  description = "Mark backups"
}

variable "delete_automated_backups" {
  default     = false
  type        = bool
  description = "Delete backupd with db"
}

variable "deletion_protection" {
  default     = false
  type        = bool
  description = "Protect db from deletion"

}

variable "skip_final_snapshot" {
  default     = false
  type        = bool
  description = "Do final snapshot"
}

variable "maintenance_window" {
  default = "Sun:06:00-Sun:07:00"

}

variable "monitoring_interval" {
  default = 15
}


variable "monitoring_role_arn" {
  default     = ""
  description = "Cloudwatch monitor role"
  type        = string

}

variable "enabled_cloudwatch_logs_exports" {
  default = ["postgresql","upgrade"]
  type    = list

}






