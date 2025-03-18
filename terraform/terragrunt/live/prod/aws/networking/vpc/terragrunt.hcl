include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/networking/vpc?ref=v0.1.109-vpc"
}

inputs = {
  vpc_cidr_block = "10.111.240.0/20"

  eks_private_subnets_cidr_blocks = [
    "10.111.244.0/22",
    "10.111.248.0/22",
    "10.111.252.0/22",
  ]
  private_subnets_cidr_blocks = [
    "10.111.241.0/24",
    "10.111.242.0/24",
    "10.111.243.0/24",
  ]
  public_subnets_cidr_blocks = [
    "10.111.240.0/28",
    "10.111.240.16/28",
    "10.111.240.32/28",
  ]

  # EKS Platform Karpenter integration
  eks_platform_karpenter_integration_enabled = true
}
