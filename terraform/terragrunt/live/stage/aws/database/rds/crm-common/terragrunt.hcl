include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds?ref=v0.1.56-rds"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  db_instances = {

    studio-common = {
      engine                = "postgres"
      family                = "postgres14"
      engine_version        = "14.7"
      allocated_storage     = 100
      max_allocated_storage = 500
      db_name               = "studio_common"
      identifier            = "studio-common"
      instance_class        = "db.t4g.medium"
      username              = "admin_studio_common"
      encrypted_password    = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AFBgKJvJ1X8hz6oKmsFY+97AAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMY1XuL+10TIyNWPkSAgEQgCu35BxGuE+ThSe67CmASTX11Un2j+V+Ywd3A7xSOeUJvPqemgC0uel7xDHw"
      security_group_ids    = [dependency.sg.outputs.postgresql_sg_id]
      tags                  = { Jira = "studioSTREAM-14387"
                                App  = "studio-common" }
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
