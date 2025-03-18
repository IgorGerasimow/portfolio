include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/networking/securitygroups?ref=v0.1.110-sg"
}

inputs = {
  eventstore_pl_k8s_environment = "pl_k8s_prod_aws_shared"
  # EKS Platform Karpenter integration
  eks_platform_karpenter_integration_enabled = true
}
