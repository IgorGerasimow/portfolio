data "aws_iam_policy_document" "eks_master" {
  statement {
    actions = ["sts:AssumeRole"]
     principals {
        type = "Service"
        identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eks_worker_role" {
  statement {
    actions = ["sts:AssumeRole"]
     principals {
        type = "Service"
        identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eks_worker_policy_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["*"] 
  }
}

data "template_file" "eks_worker" { 
  count = var.enabled ? 1 : 0
  template = file("${path.module}/templates/worker_userdata.sh")
  vars = { 
    master_endpoint = aws_eks_cluster.this[0].endpoint
    certificate_authority = aws_eks_cluster.this[0].certificate_authority.0.data
    cluster_name =  aws_eks_cluster.this[0].id
  }
}

data "aws_ami" "eks" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_version}-${var.eks_release}"]
  }
  most_recent      = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}

data "aws_iam_instance_profile" "worker_role_arn" {
  count = var.enabled && var.worker_profile_name != "" ? 1 : 0
  name = var.worker_profile_name
}

data "template_file" "worker_access" { 
  count = var.enabled && var.worker_profile_name == "" ? 1 : 0
  template = file("${path.module}/templates/config_map.yml")
  vars = { 
    role_arn = var.worker_profile_name == "" ?  aws_iam_role.eks_worker[0].arn : data.aws_iam_instance_profile.worker_role_arn[0].arn
    additional_roles_arns = var.mapRoles
  }
}

data "aws_eks_cluster_auth" "cluster_auth" {
  count = var.enabled ? 1 : 0
  name = aws_eks_cluster.this[0].id
}
