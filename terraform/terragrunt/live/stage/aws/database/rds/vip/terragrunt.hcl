include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds?ref=v0.1.56-rds"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  db_instances = {

    vip-common = {
      engine                = "postgres"
      family                = "postgres14"
      engine_version        = "14.7"
      allocated_storage     = 20
      max_allocated_storage = 100
      db_name               = ""
      identifier            = "vip-common"
      instance_class        = "db.t4g.small"
      username              = "admin_vip_common"
      encrypted_password    = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AHfNQ34gLDouBqQyl++oRDhAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMMWxOihz/e6YK3VrkAgEQgCdkHitSgtkUM67dRkesIE2c4J6XIfus5KB0kxaHO9SSPjcCnU2lU/Y="
      security_group_ids    = [dependency.sg.outputs.postgresql_sg_id]
      parameter_group_name  = dependency.pg.outputs.parameter_group["psql_14"].name
      tags                  = { Jira = "studioSTREAM-18414"
                                App  = "vip-common" }
    }
  }
}

dependencies {
  paths = [
    "../../../security/kms",
    "../../../networking/vpc",
    "../../../networking/securitygroups",
    "../_parameter_group",
  ]
}

dependency "pg" {
  config_path = "../_parameter_group"
}

dependency "sg" {
  config_path = "../../../networking/securitygroups"
}

