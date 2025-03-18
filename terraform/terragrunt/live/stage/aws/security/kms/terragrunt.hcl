include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/security/kms?ref=v0.1.29-kms"
}

inputs = {
  tags = {
    Jira = "None"
    Team = "DevOps"
    App  = "None"
  }
}
