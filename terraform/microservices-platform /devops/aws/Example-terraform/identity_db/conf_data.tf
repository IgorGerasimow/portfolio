data "terraform_remote_state" "base" {
  backend = "s3"

  config = {
    bucket = var.remote_bucket_source[var.project]
    region = "us-east-2"
    key    = "terraform/us-east-2/infrastructure_us-east-2_all.tfstate"
  }
}


data "aws_route53_zone" "public" {
  name         = var.control_domain_dns
  private_zone = false
}

data "aws_ssm_parameter" "db_username" { 
  name = "${local.main_prefix}-${var.svc}-username"
}

data "aws_ssm_parameter" "db_password" { 
  name = "${local.main_prefix}-${var.svc}-password"
}

