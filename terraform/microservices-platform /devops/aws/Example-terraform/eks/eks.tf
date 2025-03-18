module "alb" {
  source = "../terraform_modules/aws/lb/0.0.1/"
  svc      = var.svc
  project = var.project
  region = var.region
  env = var.env
  subnet_ids = data.terraform_remote_state.base.outputs.subnet_ext
  internal = var.lb.internal
  sg_ids = [data.terraform_remote_state.base.outputs.sg_http_ext, module.eks.cluster_security_group_id]
}

module "target_group" {
  source = "../terraform_modules/aws/lb_target_group/0.0.1/"
  svc      = var.svc
  project = var.project
  region = var.region
  env = var.env
  port = var.target_group.port
  listener_port = var.target_group.listener_port
  listener_protocol = var.target_group.listener_protocol
  protocol = var.target_group.protocol
  certificate_arn = data.aws_acm_certificate.certs[0].arn
  vpc_id = data.terraform_remote_state.base.outputs.vpc_id
  lb_arn = module.alb.arn
  healthcheck_path = var.target_group.healthcheck_path
  healthcheck_port = var.target_group.healthcheck_port
}


module "eks" {
  source = "../terraform_modules/aws/eks/0.0.1/"
  subnet_ids = data.terraform_remote_state.base.outputs.subnet_int
  target_group_arns = [module.target_group.arn]
  svc      = var.svc
  project = var.project
  region = var.region
  env = var.env
  eks_release = var.eks.eks_release
  max_size = var.eks.max_size
  min_size = var.eks.min_size
  mapUsers = data.template_file.worker_user_access.rendered
  endpoint_public_access = var.eks.endpoint_public_access
  key_name = var.eks.key_name
  worker_instance_type = var.eks.worker_instance_type
}

resource "aws_lb_listener_certificate" "more_certs" {
  count  = length(var.certificate) - 1 
  listener_arn    = module.target_group.listener_arn
  certificate_arn = data.aws_acm_certificate.certs[count.index + 1].arn
}