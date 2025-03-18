include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/manage-db/postgresql?ref=v0.1.55-mysql-postgresql"
}

locals {

  set_name = basename(get_terragrunt_dir())

  db_instances = {
      gamification-common = {
        dbs = {
          studio_gamification = {
            name              = "studio_gamification"
            owner             = "studio_gamification"
          }
          studio_gamification_wf = {
            name              = "studio_gamification_wf"
            owner             = "studio_gamification_wf"
          }
          peer2peer = {
            name              = "peer2peer"
            owner             = "peer2peer"
          }

        }

        roles = {
          studio_gamification = {
            name  = "studio_gamification"
            login = false
          }

          studio_gamification_wf = {
            name  = "studio_gamification_wf"
            login = false
          }

          peer2peer = {
            name  = "peer2peer"
            login = false
          }

          peer2peer-be-deposit = {
            name = "peer2peer-be-deposit"
            login = true
            encrypted_kms_password = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AH0mK7VpbHUjnuTPuLqbRzHAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMBjbOt767zCP+BIvsAgEQgCeyJlo3r+MVMDUwY9FFLfiI4no9GT6KTvtjVHx0K0w4qDCTlshsABM="
            roles = ["peer2peer"]
          }

          peer2peer-be = {
            name = "peer2peer-be"
            login = true
            encrypted_kms_password = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AG6ujf0GNzYpLmZFslntPJxAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMGgolxKb4zPeO9xh4AgEQgCc3u7T4MY+rRPyi8dEvcLsZVf3qwMBMq4Qzls1hpNDgXDc/j18ZKBA="
            roles = ["peer2peer"]
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
