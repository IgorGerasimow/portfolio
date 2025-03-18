include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/elasticache?ref=v0.1.65-elasticache"
}

inputs = {

  elasticache_instances = {

    redis-gamification = {
      name = "redis-gamification"
      description = "common Redis for redis-gamification"
      node_type = "cache.t4g.micro"
      parameter_group_name = "redis-gamification"
      num_node_groups = 1
      replicas_per_node_group = 0
      engine_version = "7.0"
      dns_reader = true
      dns_primary = true
      dns_reader_name = "redis-gamification"
      dns_primary_name = "redis-gamification"
      security_group_ids = [dependency.sg.outputs.redis_sg_id]
      tags                  = { Jira = "studioSTREAM-14388"
                                Product  = "gamification"
                                Team  = "engagement-hub"
                                App  = "gamification-common" }
    }
  }
  dns_zone = "studio-stage.corp.loc"
}

dependencies {
  paths = [
    "../../../networking/vpc",
    "../../../networking/securitygroups",
    "../parameter_group",
  ]
}

dependency "sg" {
  config_path = "../../../networking/securitygroups"
}
