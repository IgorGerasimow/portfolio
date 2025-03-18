include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/elasticache?ref=v0.1.113-elasticache"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  elasticache_instances = {

    redis-template-renderer = {
      name = "redis-template-renderer"
      description = "Redis for template-renderer"
      node_type = "cache.t4g.small"
      parameter_group_name = dependency.pg.outputs.parameter_group["redis-template-renderer"].name
      num_node_groups = 1
      replicas_per_node_group = 0
      automatic_failover = true
      engine_version = "7.0"
      dns_configuration = true
      dns_configuration_name = "redis-template-renderer"
      security_group_ids = [dependency.sg.outputs.redis_sg_id]
      tags = { 
        Jira = "studioSTREAM-23898"
        Product = "th"
        App = "template-renderer"
      }
    }
  }
  dns_zone = "studio.corp.loc"
}

dependencies {
  paths = [
    "../../../networking/vpc",
    "../../../networking/securitygroups",
    "../_parameter_group",
  ]
}

dependency "sg" {
  config_path = "../../../networking/securitygroups"
}

dependency "pg" {
  config_path = "../_parameter_group"
}
