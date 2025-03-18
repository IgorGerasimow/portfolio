include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/elasticache-module?ref=v0.1.74-elasticache-module"
}

inputs = {
  studio_elasticache = {
    redis-studio-mail = {
      name = "redis-studio-mail"
      instance_type = "cache.t3.micro"
      tags = {
        Jira    = "studioSTREAM-14303"
        Team    = "studio"
        App     = "studio-mail"
        Product = "shared"
      }
    }
  }
  dns_zone = "studio-stage.corp.loc"
}

dependencies {
  paths = [
    "../../networking/vpc",
    "../../security/iam",
    "../../networking/route53"
  ]
}
