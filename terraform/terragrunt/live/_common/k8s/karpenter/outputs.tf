output "karpenter_instance_profile_role_name" {
  description = "The name of the Karpenter instance profile role"
  value       = module.karpenter.karpenter_instance_profile_role_name
}

output "karpenter_instance_profile_role_arn" {
  description = "The ARN of the Karpenter instance profile role"
  value       = module.karpenter.karpenter_instance_profile_role_arn
}

output "karpenter_discover_tag" {
  description = "Discovery tag for Karpenter. Karpenter will use this tag to discover VPC subnets, security group of nodes, and EKS cluster"
  value       = module.karpenter.karpenter_discover_tag
}
