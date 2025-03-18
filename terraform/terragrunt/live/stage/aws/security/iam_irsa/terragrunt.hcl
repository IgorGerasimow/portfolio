include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/security/iam_irsa?ref=v0.1.96-iam"
}

dependencies {
  paths = ["../../networking/route53",
           "../../containers/eks",
          ]
}

inputs = {
  irsa_roles = {
    engine = {
      name = "engine"
      namespace = "foundation"
      iam_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "s3:*"
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:s3:::stage-foundation-static-segments",
              "arn:aws:s3:::stage-foundation-static-segments/*"
            ]
          },
        ]
      })
      tags = {
        Jira = "studioSTREAM-23096"
        Team = "studio-platform"
        App  = "engine"
        Product = "rapid-segments"
      }
    },
    player_journey_reporting = {
      name = "studio-player-journey-reporting"
      namespace = "jb"
      iam_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "s3:*"
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:s3:::stage-player-journey-reporting",
              "arn:aws:s3:::stage-player-journey-reporting/*"
            ]
          },
        ]
      })
      tags = {
        Jira    = "studioSTREAM-22455"
        Team    = "studio-platform"
        App     = "studio-player-journey-reporting"
        Product = "journey-builder"
      }
    },
    csv_import_journey_activity = {
      name = "studio-csv-import-journey-activity"
      namespace = "jb"
      iam_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "s3:*"
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:s3:::stage-studio-fe",
              "arn:aws:s3:::stage-studio-fe/*"
            ]
          },
        ]
      })
      tags = {
        Jira    = "studioSTREAM-23094"
        Team    = "studio-platform"
        App     = "studio-csv-import-journey-activity"
        Product = "journey-builder"
      }
    },
    studio_backoffice_api = {
      name = "studio-backoffice-api"
      namespace = "jb"
      iam_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "s3:*"
            ]
            Effect = "Allow"
            Resource = [
              "arn:aws:s3:::stage-studio-fe",
              "arn:aws:s3:::stage-studio-fe/*"
            ]
          },
        ]
      })
      tags = {
        Jira    = "studioSTREAM-23092"
        Team    = "studio-platform"
        App     = "studio-backoffice-api"
        Product = "journey-builder"
      }
    }
  }
}
