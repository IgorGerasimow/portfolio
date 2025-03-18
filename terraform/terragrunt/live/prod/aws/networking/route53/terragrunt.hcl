include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/networking/route53?ref=v0.1.88-route53"
}

inputs = {
  local_domains = ["studio.corp.loc"]
}

dependencies {
  paths = ["../../networking/securitygroups",
           "../../networking/vpc",
          ]
}
