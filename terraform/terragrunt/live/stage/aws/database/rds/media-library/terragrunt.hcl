include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds?ref=v0.1.56-rds"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  db_instances = {

    media-library = {
      engine                = "postgres"
      family                = "postgres15"
      engine_version        = "15.4"
      allocated_storage     = 50
      max_allocated_storage = 100
      db_name               = ""
      identifier            = "media-library"
      instance_class        = "db.t4g.small"
      username              = "admin_media_library"
      encrypted_password    = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AHF/ljfXrJMkJ9HFN1vFtKOAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMeiazj5ml6W8lBPhzAgEQgCsKKCLwogGolliP6GuUUNXZI2vwWzaOgJlmmgQl/mG2LjByBLcTecJrK2B0"
      security_group_ids    = [dependency.sg.outputs.postgresql_sg_id]
      parameter_group_name  = dependency.pg.outputs.parameter_group["psql_15"].name
      tags                  = { Jira  = "studioSTREAM-22467"
                                App   = "media-library"
                                Owner = "Notification-Center" }
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
