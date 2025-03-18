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

variable "master_role_arn" {
    default = ""
    description = "Master role arn, is empty create module default"
    type = string
}

variable "worker_profile_name" {
    default = ""
    description = "Worker instance profile arn, is empty create module default"
    type = string
}

variable "eks_version" {
    default = "1.15"
    description = "EKS version"
    type = string
}

variable "eks_release" {
    default = "*"
    description = "EKS ami release"
    type = string
}

variable "endpoint_private_access" {
    default = true
    description =  "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
    type = bool
}

variable "endpoint_public_access" {
    default = false
    description =  "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
    type = bool
}

variable "enabled_cluster_log_types" {
    default = ["authenticator"]
    type = list 
    description = "Enable logging for master eks node"
}


variable "public_access_cidrs" {
    default = ["0.0.0.0/0"]
    description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. Terraform will only perform drift detection of its value when present in a configuration."
    type = list
}

variable "subnet_ids" {
    description = "List of subnet IDs. Min 2 in different az"
    type = list 
}

variable "security_group_ids_master" {
    default = []
    description = "Additional security group for eks master"
}


variable "security_group_ids_workers" {
    default = []
    description = "Asditional security group for eks workers"
}

variable "device_block_mappings" {
  default = [{
        device_name = "/dev/sda1"
        ebs_volume_size = 50
        }]
  description = "Device mapping for asg"
  type = list
}


variable "worker_instance_type" {
    description = "Instance type for workers"
    type = string
}


variable "key_name" {
    description = "SSH key names"
    type = string
}


variable "tags" {
    default = {}
    description = "Additional tag for resource(Not for asg ) "
    type = map
}


variable "tags_asg" {
    default = []
    description = "Additional tag for asg only"
    type = list
}

variable "min_size" {
    default = 1
    description = "Min worker count"
    type = number 
}

variable "max_size" {
    default = 1
    description = "Max worker count"
    type = number
}

variable "target_group_arns" {
    default = []
    description = "List of target group where worker should be connected"
    type = list
}


variable "health_check_type" {
  default = "EC2"
  description = "ASG group health check"
  type = string 
}

variable "mapUsers" {
    default = ""
    type = string  
}

variable "mapRoles" {
    default = ""
    type = string
    description = "Additional roles for access to cluster"
}


