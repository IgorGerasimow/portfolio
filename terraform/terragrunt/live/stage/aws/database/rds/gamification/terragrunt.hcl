include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds?ref=v0.1.56-rds"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  db_instances = {

    gamification-common = {
      engine                = "postgres"
      family                = "postgres14"
      engine_version        = "14.7"
      allocated_storage     = 100
      max_allocated_storage = 500
      db_name               = ""
      identifier            = "gamification-common"
      instance_class        = "db.t4g.small"
      username              = "admin_gamification_common"
      encrypted_password    = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AG4kIlNd7FFmWVJvJA2RxkqAAAAaDBmBgkqhkiG9w0BBwagWTBXAgEAMFIGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMD1fMNTMR0bKcWPa7AgEQgCVs1z+PfvEWRexBBIfVJPNXHW4epVLxe19dwtUi23W19GSz5mah"
      security_group_ids    = [dependency.sg.outputs.postgresql_sg_id]
      parameter_group_name  = dependency.pg.outputs.parameter_group["psql_14"].name
      tags                  = { Jira = "studioSTREAM-14388"
                                Product  = "gamification"
                                Team  = "engagement-hub"
                                App  = "gamification-common" }
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
