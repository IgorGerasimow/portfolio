resource "aws_eks_cluster" "this" {
  count = var.enabled ? 1 : 0
  name            = "${local.main_prefix}-${var.svc}"
  role_arn        = var.master_role_arn == "" ? aws_iam_role.eks_master[0].arn : var.master_role_arn
  version         = var.eks_version
  enabled_cluster_log_types = var.enabled_cluster_log_types
  vpc_config {
    subnet_ids         = var.subnet_ids
    public_access_cidrs = var.public_access_cidrs
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access = var.endpoint_public_access
  }
  tags = merge(
    local.tags,
    var.tags
  )
}

# Kubernetes apply

resource "kubernetes_config_map" "aws_auth" {
  count = var.enabled ? 1 : 0
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = data.template_file.worker_access[0].rendered
    mapUsers = var.mapUsers == "" ? null : var.mapUsers
  }
}



module "asg" {
    source = "../terraform_modules/aws/asg/0.0.1/"
    device_block_mappings = var.device_block_mappings
    project = var.project
    region  = var.region 
    svc     = var.svc
    env     = var.env 
    iam_instance_profile = var.worker_profile_name == "" ? aws_iam_instance_profile.eks_worker[0].name : var.worker_profile_name
    image_id =  data.aws_ami.eks.id
    instance_type = var.worker_instance_type
    key_name = var.key_name
    security_groups = compact(concat([aws_eks_cluster.this[0].vpc_config.0.cluster_security_group_id],[aws_security_group.eks[0].id], var.security_group_ids_workers))
    tags_asg = concat(var.tags_asg, 
    [{
        key               = "kubernetes.io/cluster/${aws_eks_cluster.this[0].id}"
        value               = "owned"
        propagate_at_launch = true
    }])
    tags      = var.tags
    user_data = data.template_file.eks_worker[0].rendered
    max_size = var.max_size
    min_size = var.min_size
    target_group_arns = var.target_group_arns == [] ? null : var.target_group_arns
    subnets = var.subnet_ids
    health_check_type = var.health_check_type
}

