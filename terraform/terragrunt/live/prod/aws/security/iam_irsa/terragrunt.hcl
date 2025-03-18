include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/security/iam_irsa?ref=v0.1.114-iam_irsa"
}

dependencies {
  paths = ["../../networking/route53",
           "../../containers/eks",
          ]
}
inputs = {
  irsa_roles = {}
}
