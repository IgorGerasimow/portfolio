
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

variable "ami" {

}

variable "availability_zone" {
  default     = ""
  type        = string
  description = "AZ where i should run instances"
}

variable "placement_group" {
  default     = ""
  type        = string
  description = "Placement group id where i should run instances"
}


variable "ebs_optimized" {
  default     = true
  type        = bool
  description = "If true, the launched EC2 instance will be EBS-optimized."
}

variable "disable_api_termination" {
  default     = false
  type        = bool
  description = "If true, enables EC2 Instance Termination Protection"

}

variable "instance_initiated_shutdown_behavior" {
  default     = "stop"
  type        = string
  description = "Shutdown behavior for the instance"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to start."
}

variable "key_name" {
  type        = string
  description = "The key name of the Key Pair to use for the instance"
}

variable "monitoring" {
  default     = true
  type        = bool
  description = "If true, the launched EC2 instance will have detailed monitoring enabled."
}

variable "vpc_security_group_ids" {
  default     = []
  type        = list
  description = "A list of security group IDs to associate with."
}

variable "subnet_id" {
  type        = string
  description = "The VPC Subnet ID to launch in."
}

variable "associate_public_ip_address" {
  default     = false
  type        = bool
  description = "Associate a public ip address with an instance in a VPC. Boolean value."
}

variable "private_ip" {
  default     = ""
  type        = string
  description = "Private IP address to associate with the instance in a VPC."
}


variable "source_dest_check" {
  default     = true
  type        = bool
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs"

}

variable "user_data" {
  default     = ""
  type        = string
  description = "The user data to provide when launching the instance."

}

variable "iam_instance_profile" {
  default     = ""
  type        = string
  description = "The IAM Instance Profile to launch the instance with."
}

variable "tags" {
  default     = {}
  type        = map
  description = "A mapping of tags to assign to the resource for instances and volume"
}

variable "root_block_device" {
  default = {
    volume_type           = "gp2"
    volume_size           = "10"
    delete_on_termination = true
  }
  type        = map
  description = "Customize details about the root block device of the instance."
}

variable "ebs_block_device" {
  default     = []
  type        = list
  description = "List additional EBS block devices to attach to the instance"

}

variable "ephemeral_block_device" {
  default     = []
  type        = list
  description = "Customize Ephemeral (Don'r used for now )"
}
