include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/storage/s3?ref=v0.1.93-s3"
}

inputs = {
  studio_bucket = {
    media-library-shared = {
      name = "media-library-shared"
      block_public_acls       = "true"
      block_public_policy     = "true"
      ignore_public_acls      = "true"
      restrict_public_buckets = "true"
      policy                  = ""
      tags = {
        Jira    = "studioSTREAM-22464"
        Product = "media-library"
        App     = "media-library"
        Owner   = "Notification-Center"
      }
    }
  }
}

dependencies {
  paths = [
    "../../security/iam"
  ]
}
