include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/storage/s3?ref=v0.1.93-s3"
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
      name                    = "foundation-static-segments"
      acl                     = "private"
      block_public_acls       = "true"
      block_public_policy     = "true"
      ignore_public_acls      = "true"
      restrict_public_buckets = "true"
      policy                  = <<POLICY
      {
        "Version": "2012-10-17",
        "Id": "Policy1598967848906",
        "Statement": [
          {
            "Sid": "Stmt1598967844619",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::prod-foundation-static-segments",
                "arn:aws:s3:::prod-foundation-static-segments/*"
            ],
            "Condition": {
              "IpAddress": {
                "aws:SourceIp": [
                    "3.121.23.59/32",
                    "3.121.28.124/32",
                    "3.121.38.70/32"
                ]
              }
            }
          },
          {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::195710261801:role/engine-aws-prod-shared-eks-oidc"
            },
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:PutObjectAcl",
                "s3:GetObjectAcl",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::prod-foundation-static-segments",
                "arn:aws:s3:::prod-foundation-static-segments/*"
            ]
          }
        ]
      }
      POLICY
      tags = {
        Jira = "studioSTREAM-15978"
        Team = "studio-platform"
        App  = "ams-engine"
        Product = "rapid-segments"
      }
    }
    player-journey-reporting = {
      name                    = "player-journey-reporting"
      acl                     = "private"
      block_public_acls       = "true"
      block_public_policy     = "true"
      ignore_public_acls      = "true"
      restrict_public_buckets = "true"
      attach_policy           = "true"
      policy                  = file("./policies/player-journey-reporting.json")
      cors_rule = [
          {
            allowed_headers = ["*"]
            allowed_methods = ["GET", "HEAD"]
            allowed_origins = ["http://rea.corp.loc", "https://rea.corp.loc"]
            expose_headers  = []
            max_age_seconds = 3000
          }
      ]

      tags = {
        Jira    = "studioSTREAM-21855"
        Team    = "studio-platform"
        Product = "journey-builder"
        App     = "studio-player-journey-reporting"
      }
    }
  }
}

dependencies {
  paths = [
    "../security/iam"
  ]
}
