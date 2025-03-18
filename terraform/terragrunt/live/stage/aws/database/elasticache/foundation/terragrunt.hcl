include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/elasticache?ref=v0.1.81-elasticache"
}

inputs = {

  elasticache_instances = {

    redis-foundation = {
      name = "redis-foundation"
      description = "common Redis for redis-foundation"
      node_type = "cache.t4g.micro"
      parameter_group_name = "redis-foundation"
      subnet_group_name = "elasticache-common-stage"
      num_node_groups = 1
      replicas_per_node_group = 0
      engine_version = "7.0"
      dns_reader = true
      dns_primary = true
      dns_reader_name = "redis-foundation"
      dns_primary_name = "redis-foundation"
      security_group_ids = [dependency.sg.outputs.redis_sg_id]
      tags = { 
        Jira = "studioSTREAM-19541"
        Product = "rapid-segments"
        App = "ams-engine"
        Team = "studio-platform"
      }
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
