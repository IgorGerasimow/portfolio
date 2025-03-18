include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds?ref=v0.1.56-rds"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  db_instances = {

    keycloak = {
      engine                = "postgres"
      family                = "postgres14"
      engine_version        = "14.7"
      allocated_storage     = 20
      max_allocated_storage = 50
      db_name               = "keycloak"
      identifier            = "keycloak"
      instance_class        = "db.t4g.small"
      username              = "admin_keycloak"
      encrypted_password    = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AF4lcKjPVjIKTH1Koyg6Th9AAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMGypzg3wZI/itaOniAgEQgCvCP1Q/JpmlxDn4mpoMYBQkyOrr+PxmFmkRJbrYjWG5ru1ZYc93okqJDSz/"
      security_group_ids    = [dependency.sg.outputs.postgresql_sg_id]
      tags                  = { Jira = "studioSTREAM-16994"
                                App  = "keycloak" }
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
