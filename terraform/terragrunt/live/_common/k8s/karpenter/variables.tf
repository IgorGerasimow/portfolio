# ============================ #
# Will be filled by Terragrunt #
# ============================ #

variable "aws_region" {}
variable "terraform_remote_state_s3_bucket" {}
variable "terraform_remote_state_dynamodb_table" {}
variable "terraform_remote_state_file_name" {}
variable "default_provider_tags" {
  type = map(any)
}
variable "env" {}

# =================== #
# Mandatory variables #
# =================== #

variable "karpenter_settings" {
  description = "Map of Karpenter configuration settings"
  type = object({
    # Namespace
    karpenter_namespace = optional(string, "karpenter")

    # Version
    karpenter_version = optional(string, "0.16.1")

    # Replica count
    karpenter_replicas = optional(number, 1)

    # Provisioners configuration
    karpenter_provisioners = map(object({
      # Provisioner name
      name = string

      # Manually specify which instance types to provision. By default Karpenter automatically choose which instance type
      # to provision.
      # If set to true - set the instance_types variable value
      manual_instance_type_enabled = optional(bool, false)

      # Works only if manual_instance_type_enabled is set to true.
      instance_types = optional(list(string), [])

      # If set to true - set the instance_size variable value
      manual_instance_size_enabled = optional(bool, false)

      # Works only if manual_instance_size_enabled is set to true.
      instance_size  = optional(list(string), [])

      # "spot" or "on-demand"
      capacity_types = optional(list(string), ["spot"])

      # Provisioner architecture
      architecture = optional(list(string), ["amd64"])

      # CPU Limits
      limits_resources_cpu = optional(string, "1000")

      # TTL Settings (Node expiration/deletion)
      ttl_seconds_after_empty_enabled = optional(bool, false)
      ttl_seconds_after_empty         = optional(string, "30")

      # Consolidation (helps save money)
      consolidation_enabled = optional(bool, true)

      # Provisioner Taints
      taints_enabled = optional(bool, false)
      taint_effect   = optional(string, "NoSchedule")
      taint_key      = optional(string, "example/special-taint-key")
      taint_value    = optional(string, "example/special-taint-value")
    }))

    # Karpenter Affinity & Tolerations (where to place Karpenter controller)
    taint_key            = optional(string, "type/startup")
    taint_value          = optional(string, "infra")
    tolerations_operator = optional(string, "Equal")
    tolerations_effect   = optional(string, "NoSchedule")
    affinity_operator    = optional(string, "In")
  })
}

variable "tags" {
  description = "The map of tags"
  type        = map(string)
  default     = {}
}
