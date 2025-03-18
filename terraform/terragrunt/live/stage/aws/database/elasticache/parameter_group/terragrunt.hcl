include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/elasticache/parameter_group?ref=v0.1.62-elasticache"
}

inputs = {
    parameter_groups = {

      redis-gamification = {
        name = "redis-gamification"
        family = "redis7"

        parameters = [
          {
            name  = "rename-commands"
            value = "FLUSHDB blocked FLUSHALL blocked"
          },
          {
            name  = "cluster-enabled"
            value = "no"
          }
        ]

        tags = { Jira = "studioSTREAM-14388" }

      }

      redis-foundation = {
        name = "redis-foundation"
        family = "redis7"

        parameters = [
          {
            name  = "rename-commands"
            value = "FLUSHDB blocked FLUSHALL blocked"
          },
          {
            name  = "cluster-enabled"
            value = "no"
          }
        ]

        tags = { Jira = "studioSTREAM-14388" }

      }
    }
}

