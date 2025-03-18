include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/containers/eks?ref=v0.1.103-eks"
}

locals {
}

inputs = {
  eks_managed_node_group_defaults_instance_types = ["c6a.xlarge","c5a.xlarge"]
  cidr_postgresql_blocks = ["0.0.0.0/0"]
  cidr_redis_blocks = ["0.0.0.0/0"]
  cidr_minio_blocks = ["10.79.65.51/32"]
  cluster_version = "1.24"
  eks_managed_node_groups = {
    general = {
      max_size     = 10
      min_size     = 0
      desired_size = 1

      create_launch_template = true
      launch_template_name   = ""
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = "100"
            voliume_type = "gp3"
          }
        }
      }

      capacity_type  = "ON_DEMAND"
      update_config = {
        max_unavailable_percentage = 25 # or set `max_unavailable`
      }
    },
    spot = {
      max_size     = 9
      min_size     = 0
      desired_size = 0

      create_launch_template = true
      launch_template_name   = ""
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = "100"
            voliume_type = "gp3"
          }
        }
      }

      capacity_type  = "SPOT"
      update_config = {
        max_unavailable_percentage = 25 # or set `max_unavailable`
      }
    }
  }
  atlantis_role_arn = dependency.atlantis.outputs.atlantis_iam_role_arn
  # Karpenter integration
  # karpenter_integration_enabled = false
}

dependencies {
  paths = ["../../security/kms",
           "../../networking/route53",
           "../../networking/vpc",
          ]
}

dependency "atlantis" {
  config_path = "../../compute/containers/ecs/atlantis"
}
