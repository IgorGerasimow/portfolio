data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}
