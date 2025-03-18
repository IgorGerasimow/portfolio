include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/k8s/flux-resources?ref=v0.1.8"
}

inputs = {
  main_cert_name = "*.studio.corp.loc"
}

dependencies {
  paths = ["../../aws/containers/eks",
           "../../aws/security/acm",
          ]
}
