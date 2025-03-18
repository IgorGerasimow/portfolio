include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/storage/s3?ref=v0.1.68-s3"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.env
}

inputs = {
  studio_bucket = {
    studio-public-storage = {
        name = "studio-public-storage"
        acl  = "public-read"
        block_public_acls       = "false"
        block_public_policy     = "false"
        ignore_public_acls      = "false"
        restrict_public_buckets = "false"
        attach_policy           = "true"
        policy                  = templatefile("../../../../_common/aws/s3/studio-public-storage.json.tmpl", {
          env      = local.env
          iam_role = dependency.iam.outputs.aws_studio_platform_iam_role_arn })
        cors_rule = [
            {
              allowed_headers = ["*"]
              allowed_methods = ["GET", "HEAD"]
              allowed_origins = ["http://*", "https://*"]
              expose_headers  = ["Access-Control-Allow-Origin"]
              max_age_seconds = 3000
            }
        ]
        tags = {
          Jira = "studioSTREAM-17096"
          Team = "studio"
          App  = "studio-studio"
        }
    }
  }
}

dependencies {
  paths = [
    "../../../aws/security/iam_irsa"
  ]
}

dependency "iam" {
  config_path = "../../../aws/security/iam_irsa"
}
