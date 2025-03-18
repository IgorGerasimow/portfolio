locals {
  aws_region       = "eu-central-1"
  aws_azs          = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
  aws_account_id   = get_aws_account_id()

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.env

  k8s_cluster_name = format("%s-eks", local.env)

  # for terragrunt-atlantis-config
  extra_atlantis_dependencies = [
    "**/*.json",
    "**/*.yaml",
    "**/*.yml",
    "**/*.tpl",
    "**/*.tmpl",
    "**/*.crt",
    "**/*.enc",
  ]
}

remote_state {
  backend = "s3"
  config = {
    bucket = "pmtech-${local.aws_region}-${local.env}-${local.aws_account_id}-terraform-state"
    s3_bucket_tags = {
      Terragrunt  = "true"
      Stream      = "studio"
      Owner       = "studio-DevOps"
      Environment = local.env
    }
    key            = "${local.aws_region}/${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    # kms_key_id     = "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:alias/terraform-${local.env}-studio"
    dynamodb_table = "terraform-${local.env}-lock-state"
    region         = local.aws_region
    dynamodb_table_tags = {
      Terragrunt = "true"
      Stream     = "studio"
      Owner      = "studio-DevOps"
      Env        = local.env
    }
  }
}

inputs = {
  aws_region             = local.aws_region
  aws_azs                = local.aws_azs
  env                    = local.env
  allowed_aws_account_id = local.aws_account_id
  aws_profile            = "studio-${local.env}"
  default_provider_tags = {
    Env          = local.env
    Terraform    = "true"
    Stream       = "studio"
    DeleteAfter  = "-"
    Temporary    = "false"
    map-migrated = "d-server-13ndbvub46czjd"
  }
  terraform_remote_state_s3_bucket      = "pmtech-${local.aws_region}-${local.env}-${local.aws_account_id}-terraform-state"
  terraform_remote_state_dynamodb_table = "terraform-${local.env}-lock-state"
  terraform_remote_state_file_name      = "terraform.tfstate"
}
