include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/compute/containers/ecs/atlantis?ref=v0.1.54-atlantis"
}

inputs = {
  atlantis_dns_zone              = "studio-stage.corp.loc"
  atlantis_gitlab_user           = "atlantis-aws-stage-studio"
  atlantis_gitlab_user_token_enc = "TokenID"
  infracost_token_enc            = "TokenID"
}

dependencies {
  paths = ["../../../../security/kms",
           "../../../../security/acm",
           "../../../../networking/route53",
           "../../../../networking/vpc",
          ]
}
