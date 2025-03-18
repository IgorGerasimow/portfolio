include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/k8s/security?ref=v0.1.9"
}

inputs = {
  private_registry_token_encrypted = "TokenID"
  docker_registry_token_encrypted  = "TokenID"
}

dependencies {
  paths = ["../../aws/containers/eks",
           "../../aws/security/kms",
          ]
}
