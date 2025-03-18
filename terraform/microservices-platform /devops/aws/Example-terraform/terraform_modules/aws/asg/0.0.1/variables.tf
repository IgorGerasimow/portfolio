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

variable "device_block_mappings" {
  type = list
  default = [
    {
      device_name     = "/dev/sda1",
      ebs_volume_size = 8
    }
  ]
  description = "Map of disks"

}

variable "disable_api_termination" {
  type        = bool
  default     = false
  description = "Premit manually delete instances"
}

variable "ebs_optimized" {
  type        = bool
  default     = true
  description = "Ebs optimized instance"
}

variable "iam_instance_profile" {
  type        = string
  description = "Arn of iam profile"
}

variable "image_id" {
  type        = string
  description = "Image id which will used by asg"
}

variable "instance_initiated_shutdown_behavior" {
  type        = string
  default     = "stop"
  description = "Shutdown behavior stop or terminate"
}

variable "instance_type" {
  type        = string
  description = "Instance type"

}

variable "key_name" {
  type        = string
  description = "Name of ssh key"
}

variable "security_groups" {
  type        = list
  default     = []
  description = "Lists of security list for instances"
}

variable "tags_asg" {

  default     = []
  description = "Additional tags for instances "
}


variable "tags" {

  default     = {}
  description = "Additional tags for instances launch"
}

variable "user_data" {
  default     = ""
  description = "Instances stratup script"
}

# ASG 

# variable "availability_zones" {
#   type        = list
#   description = "List of availability zones"
# }

variable "max_size" {
  default     = 0
  type        = number
  description = "Max host count"
}

variable "min_size" {
  default     = 0
  type        = number
  description = "Mix host count"
}

variable "load_balancers" {
  default     = null
  type        = list
  description = "List of load balancer"

}

variable "target_group_arns" {
  default     = null
  type        = list
  description = "List of target groups"

}

variable "subnets" {
  type        = list
  description = "List of subnets where it should run"

}

variable "health_check_type" {
  default     = "EC2"
  type        = string
  description = "Health check type EC2/ELB"
}




