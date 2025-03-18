include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/storage/s3?ref=v0.1.87-s3"
}

inputs = {
  studio_bucket = {
    studio-salesforce = {
      name = "studio-salesforce"
      acl  = "private"
      block_public_acls       = "true"
      block_public_policy     = "true"
      ignore_public_acls      = "true"
      restrict_public_buckets = "true"
      policy                  = ""
      tags = {
        Jira = "studioSTREAM-15111"
        Team = "Salesforce"
        App  = "studio-salesforce"
      }
    }
    foundation-static-segments = {
      name = "foundation-static-segments"
      acl  = "private"
      block_public_acls       = "true"
      block_public_policy     = "true"
      ignore_public_acls      = "true"
      restrict_public_buckets = "true"
      attach_policy           = "true"
      policy                  = file("./policies/foundation-static-segments.json")
      tags = {
        Jira = "studioSTREAM-15978"
        Team = "Foundation"
        App  = "engine"
      }
    }
    studio-internal-storage = {
      name = "studio-internal-storage"
      acl  = "private"
      block_public_acls       = "true"
      block_public_policy     = "true"
      ignore_public_acls      = "true"
      restrict_public_buckets = "true"
      policy                  = ""
      tags = {
        Jira = "studioSTREAM-17096"
        Team = "studio"
        App  = "studio-studio"
      }
    }
    player-journey-reporting = {
      name = "player-journey-reporting"
      acl  = "private"
      block_public_acls       = "true"
      block_public_policy     = "true"
      ignore_public_acls      = "true"
      restrict_public_buckets = "true"
      policy                  = ""
      cors_rule = [
          {
            allowed_headers = ["*"]
            allowed_methods = ["GET", "HEAD"]
            allowed_origins = ["http://rea-backoffice.kube.private", "https://rea-backoffice.kube.private"]
            expose_headers  = []
            max_age_seconds = 3000
          }
      ]

      tags = {
        Jira = "studioSTREAM-21408"
        Team = "processing"
        App  = "player-journey-reporting"
      }
    }
  }
}

dependencies {
  paths = [
    "../../security/iam"
  ]
}
