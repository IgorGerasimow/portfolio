data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.terraform_remote_state_s3_bucket
    key    = "${var.aws_region}/${var.env}/aws/networking/vpc/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "sg" {
  backend = "s3"

  config = {
    bucket = var.terraform_remote_state_s3_bucket
    key    = "${var.aws_region}/${var.env}/aws/networking/securitygroups/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = var.terraform_remote_state_s3_bucket
    key    = "${var.aws_region}/${var.env}/aws/containers/eks/terraform.tfstate"
    region = var.aws_region
  }
}
