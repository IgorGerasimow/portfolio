
output "endpoint" {
  value = aws_eks_cluster.this != [] ? concat(aws_eks_cluster.this[*].endpoint, [""])[0] : null
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.this != [] ? concat([aws_eks_cluster.this[0].certificate_authority.0.data], [""])[0] : null 
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.this != [] ? concat([aws_eks_cluster.this[0].vpc_config.0.cluster_security_group_id], [""])[0] : null
}

output "worker_security_group_id" {
  value = concat([aws_security_group.eks[0].id], [""])[0]
}

output "vpc_id" {
  value = concat([aws_eks_cluster.this[0].vpc_config.0.vpc_id], [""])[0]
}

output "id" {
  value = concat(aws_eks_cluster.this[*].id, [""])[0]
}

output "arn" {
  value = concat(aws_eks_cluster.this[*].id, [""])[0]
}

output "platform_version" {
  value = concat(aws_eks_cluster.this[*].platform_version, [""])[0]
}

output "version" {
  value = concat(aws_eks_cluster.this[*].version, [""])[0]
}

output "master_role_arn" {
  value = concat(aws_iam_role.eks_master[*].arn, [""])[0]
}

output "master_role_name" {
  value = concat(aws_iam_role.eks_master[*].name, [""])[0]
}

output "worker_iam_role" {
  value = concat(aws_iam_role.eks_worker[*].arn, [""])[0]
}

output "kube_config_file" {
  value = local_file.kubeconfig.filename
}


output "worker_iam_role_name" {
  value = concat(aws_iam_role.eks_worker[*].name, [""])[0]
}

output "name_prefix" {
  value = "${local.main_prefix}-${var.svc}"
}

output "asg_arn" {
  value = module.asg.asg_arn
}

output "asg_name" {
  value = module.asg.asg_name
}

output "asg_id" {
  value = module.asg.asg_id
}

