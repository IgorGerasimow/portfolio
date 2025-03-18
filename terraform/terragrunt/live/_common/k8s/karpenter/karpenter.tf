module "karpenter" {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/k8s/karpenter"

  # Namespace
  karpenter_namespace = var.karpenter_settings.karpenter_namespace

  # Karpenter version
  karpenter_version = var.karpenter_settings.karpenter_version

  # Replica count
  karpenter_replicas = var.karpenter_settings.karpenter_replicas

  # Provisioners configuration
  karpenter_provisioners = var.karpenter_settings.karpenter_provisioners

  # Karpenter Taints (on which nodes to place Karpenter controller)
  taint_key            = var.karpenter_settings.taint_key
  taint_value          = var.karpenter_settings.taint_value
  tolerations_operator = var.karpenter_settings.tolerations_operator
  tolerations_effect   = var.karpenter_settings.tolerations_effect
  affinity_operator    = var.karpenter_settings.affinity_operator

  # EKS cluster size
  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name

  # Networking
  vpc_azs = data.terraform_remote_state.vpc.outputs.azs
  karpenter_subnet_ids = data.terraform_remote_state.vpc.outputs.k8s_subnets
  karpenter_sg_ids = [data.terraform_remote_state.eks.outputs.eks_node_sg_id]
  # Tags
  tags = var.tags
}
