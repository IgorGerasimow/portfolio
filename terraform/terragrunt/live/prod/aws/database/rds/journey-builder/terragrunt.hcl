include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds?ref=v0.1.102-rds"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  db_instances = {

    studio-wait-time-journey-activity = {
      engine                = "postgres"
      family                = "postgres15"
      engine_version        = "15.4"
      allocated_storage     = 10
      max_allocated_storage = 100
      identifier            = "studio-wait-time-journey-activity"
      instance_class        = "db.r6g.large"
      username              = "studio_wait_time_journey_activity_admin"
      encrypted_password    = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgGw5oJKu9gAQsA/5r4l5OPzAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMYk+FE0UrBNx4egJTAgEQgCvdGdvEJEJhXmed+VHi2fAJls8pgFDV0vD5YIGVdSWUiP/oyNcMarf1dxNL"
      security_group_ids    = [dependency.sg.outputs.postgresql_sg_id]
      parameter_group_name  = dependency.pg.outputs.parameter_group["psql_15"].name
      tags                  = { Jira    = "studioSTREAM-22790"
                                App     = "studio-wait-time-journey-activity"
                                Product = "Journey-Builder"
                                Owner   = "studio-Platform" }

      allow_major_version_upgrade = true
    }

    studio-journey-activation-tracking = {
      engine                = "postgres"
      family                = "postgres14"
      engine_version        = "14.9"
      allocated_storage     = 10
      max_allocated_storage = 100
      identifier            = "studio-journey-activation-tracking"
      instance_class        = "db.r6g.xlarge"
      username              = "studio_journey_activation_tracking_admin"
      encrypted_password    = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgGrrHtKDMHmkEHaDM2aO8O1AAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMIQhLsfqnWBrtLNy+AgEQgCvb6QS+2f7yw88FJ7fx2szHOye390+TrNu3sys5MtwMBZY5gKk13mOa78TW"
      security_group_ids    = [dependency.sg.outputs.postgresql_sg_id]
      parameter_group_name  = dependency.pg.outputs.parameter_group["psql_14"].name
      tags                  = { Jira    = "studioSTREAM-22791"
                                App     = "studio-journey-activation-tracking"
                                Product = "Journey-Builder"
                                Owner   = "studio-Platform" }
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
