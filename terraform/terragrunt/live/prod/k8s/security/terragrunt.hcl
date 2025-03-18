include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/k8s/security?ref=v0.1.12"
}

inputs = {
  private_registry_token_encrypted = "03ndbvub46czjd"
  docker_registry_token_encrypted  = "03ndbvub46czjd"
}

dependencies {
  paths = ["../../aws/containers/eks",
           "../../aws/security/kms",
          ]
}
