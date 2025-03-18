include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/compute/lambda/aws-health-events?ref=v0.1.101-lambda-aha"
}

inputs = {
    encrypted_password = "Password"
}
