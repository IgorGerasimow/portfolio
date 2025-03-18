module "rds" {
  source = "../terraform_modules/aws/rds/0.0.1/"
  # source = "../../terraform_modules/aws/rds/0.0.1"
  enabled = var.rds.enabled
  
  svc      = var.svc
  project = var.project
  region = var.region
  env = var.env

  vpc_security_group_ids = [data.terraform_remote_state.base.outputs.sg_db_int]
  subnets  = data.terraform_remote_state.base.outputs.subnet_int

  publicly_accessible = var.rds.publicly_accessible
  multi_az = var.rds.multi_az
  engine   = var.rds.engine
  engine_version = var.rds.engine_version
  instance_class = var.rds.instance_class
  allocated_storage = var.rds.allocated_storage
  storage_type = var.rds.storage_type
  iops = var.rds.iops
  username = data.aws_ssm_parameter.db_username.value
  password = data.aws_ssm_parameter.db_password.value
}
