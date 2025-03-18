include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/manage-db/postgresql?ref=v0.1.55-mysql-postgresql"
}

locals {

  set_name = basename(get_terragrunt_dir())

  db_instances = {
      studio-common = {
        dbs = {
          studio_player_journey_reporting = {
            name              = "studio_PlayerJourneyReporting"
            owner             = "studio_player_journey_reporting"
          }
          studio_player_journey_reporting_multi_tenancy = {
            name              = "studio_PlayerJourneyReporting_MultiTenancy"
            owner             = "studio_player_journey_reporting_multi_tenancy"
          }
          studio_player_journey_reporting_hangfire = {
            name              = "studio_PlayerJourneyReporting_Hangfire"
            owner             = "studio_player_journey_reporting"
          }
          decision_split_activity = {
            name              = "decision-split-activity"
            owner             = "decision_split_activity_owner"
          }
          segment_source_activity = {
            name              = "segment-source-activity"
            owner             = "segment_source_activity_owner"
          }
        }

        roles = {
          studio_player_journey_reporting = {
            name  = "player_journey_reporting"
            login = false
          }

          studio_player_journey_reporting_user = {
            name = "player_journey_reporting_user"
            login = true
            encrypted_kms_password = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AEUTBioP5rcU29GcPJdoL0BAAAAcDBuBgkqhkiG9w0BBwagYTBfAgEAMFoGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMd5y3WOd9c5H5pdlCAgEQgC3ZReU1Xcq0SCWFSZKafH5nNNRvike7l+8H9nEke/Bd5zOQhBiBMOQamVrrCJ0="
            roles = ["studio_player_journey_reporting"]
          }

          studio_player_journey_reporting_multi_tenancy = {
            name  = "player_journey_reporting_multi_tenancy"
            login = false
          }

          studio_player_journey_reporting_multi_tenancy_user = {
            name = "player_journey_reporting_multi_tenancy_user"
            login = true
            encrypted_kms_password = "AQICAHhVCcbWAuaYTt995+ylkUHOqDv394RG0D+/euMrSro+ogFR4/8Pc3IDrSdzvlYw8ebeAAAAdDByBgkqhkiG9w0BBwagZTBjAgEAMF4GCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMulYypf8W/Gp8CIZqAgEQgDFX706DPt9ukUvwQ4/pwv7XC1Yak44MVAu2XlaNZrISlQ+efoVP+mG0R0bYM0bAqE81"
            roles = ["studio_player_journey_reporting_multi_tenancy"]
          }

          decision_split_activity_owner = {
            name  = "decision_split_activity_owner"
            login = false
          }

          decision_split_activity = {
            name = "decision-split-activity"
            login = true
            encrypted_kms_password = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AGWrYfT4aoLmmTgHZaGmXAMAAAAcjBwBgkqhkiG9w0BBwagYzBhAgEAMFwGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMTMG2YSq1z+18XE/NAgEQgC/rSNSzV8nwraxxLT4UzPoxkYNFXAriH7OYfDx0To5ivnmZFxdOBxSaTFjdJHiAIg=="
            roles = ["decision_split_activity_owner"]
          }

          segment_source_activity_owner = {
            name  = "segment_source_activity_owner"
            login = false
          }

          segment_source_activity = {
            name = "segment-source-activity"
            login = true
            encrypted_kms_password = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AFUDmqMneSIFUyTAKfKOEcZAAAAcTBvBgkqhkiG9w0BBwagYjBgAgEAMFsGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMUXIa09lNC8LjVqEyAgEQgC57bNCJzak9brwb5wSIFWvLvUYtFzKkxYnH5NVPnasII0s6fuUAM+UI+XBJcMl9"
            roles = ["segment_source_activity_owner"]
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
