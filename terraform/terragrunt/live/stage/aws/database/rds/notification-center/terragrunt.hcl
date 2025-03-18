include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds?ref=v0.1.56-rds"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  db_instances = {

    nc-fe = {
      engine                = "postgres"
      family                = "postgres14"
      engine_version        = "14.7"
      allocated_storage     = 20
      max_allocated_storage = 100
      db_name               = ""
      identifier            = "nc-fe"
      instance_class        = "db.t4g.small"
      username              = "admin_user"
      encrypted_password    = "AQICAHhVCcbWAuaYTt995+ylkUHOqDv394RG0D+/euMrSro+ogFLDh9mTwJKVBYdmhZYof4SAAAAbDBqBgkqhkiG9w0BBwagXTBbAgEAMFYGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMLDjwe48ojihrgFwlAgEQgCkAQ1vvNASscNVwduSHFVCdf5tepGR5xRQUk6MBO33SRF8CsN5M7N9riw=="
      security_group_ids    = [dependency.sg.outputs.postgresql_sg_id]
      parameter_group_name  = dependency.pg.outputs.parameter_group["psql_14"].name
      tags                  = { Jira = "studioSTREAM-23799"
                                App  = "fe-delivery" }
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

