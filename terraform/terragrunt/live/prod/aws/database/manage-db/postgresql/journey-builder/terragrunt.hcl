include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/manage-db/postgresql?ref=v0.1.55-mysql-postgresql"
}

locals {

  set_name = basename(get_terragrunt_dir())

  db_instances = {
      studio-wait-time-journey-activity = {
        dbs = {
          studio_wait_time_journey_activity = {
            name              = "studio_wait_time_journey_activity"
            owner             = "studio_wait_time_journey_activity_owner"
          }
          studio_wait_time_journey_activity_hangfire = {
            name              = "studio_wait_time_journey_activity_hangfire"
            owner             = "studio_wait_time_journey_activity_owner"
          }
        }

        roles = {
          studio_wait_time_journey_activity_owner = {
            name  = "studio_wait_time_journey_activity_owner"
            login = false
          }

          studio_wait_time_journey_activity_user = {
            name = "studio_wait_time_journey_activity_user"
            login = true
            encrypted_kms_password = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgHHRiHqPatvHQnMPv8sJMRnAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMPR3REA6dnm5eGJ1YAgEQgCvhwkbhEl2Hof8OorOUfXOFT2rrri5ctrHxNj23VLKu48CSpa1imMaP9/Lo"
            roles = ["studio_wait_time_journey_activity_owner"]
          }
        }
      }

      studio-journey-activation-tracking = {
        dbs = {
          studio_journey_activation_tracking = {
            name              = "studio_journey_activation_tracking"
            owner             = "studio_journey_activation_tracking_owner"
          }
          studio_journey_activation_tracking_hangfire = {
            name              = "studio_journey_activation_tracking_hangfire"
            owner             = "studio_journey_activation_tracking_owner"
          }
        }

        roles = {
          studio_journey_activation_tracking_owner = {
            name  = "studio_journey_activation_tracking_owner"
            login = false
          }

          studio_journey_activation_tracking_user = {
            name = "studio_journey_activation_tracking_user"
            login = true
            encrypted_kms_password = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgEwR/BwYurTdFbvP8H7qTneAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMplMxeXRqoc7AxLH7AgEQgCuf9GRRDx57d4t+XS+w02XoBFMt/UWzG64BtWoN0HzePV4BCZ0hkHl/aTuL"
            roles = ["studio_journey_activation_tracking_owner"]
          }
        }
      }
  }
}

inputs = {
  db_instances = local.db_instances
}

# Generate a provider and module call for each RDS instance
generate "postgresql" {
  path      = "main_generated.tf"
  if_exists = "overwrite"
  contents = templatefile("../../../../../../_common/aws/database/manage-db/postgresql/postgresql-rds.tmpl", {
    db_instances = local.db_instances
    rds = dependency.rds.outputs.db_instance
  })
}

dependencies {
  paths = [
    "../../../rds/${local.set_name}"
  ]
}

dependency "rds" {
  config_path = "../../../rds/${local.set_name}"
}
