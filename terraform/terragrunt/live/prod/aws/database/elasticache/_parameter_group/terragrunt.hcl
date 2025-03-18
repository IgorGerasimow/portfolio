include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/elasticache/parameter_group?ref=v0.1.113-elasticache"
}

inputs = {
    parameter_groups = {

      redis-template-renderer = {
        name = "redis-template-renderer"
        family = "redis7"
        parameters = [
          {
            name  = "rename-commands"
            value = "FLUSHDB blocked FLUSHALL blocked"
          },
          {
            name  = "cluster-enabled"
            value = "yes"
          }
        ]
        tags = { Jira = "studioSTREAM-23898" }
      }
    }
}
