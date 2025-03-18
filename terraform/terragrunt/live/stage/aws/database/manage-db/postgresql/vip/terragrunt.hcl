include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/manage-db/postgresql?ref=v0.1.55-mysql-postgresql"
}

locals {

  set_name = basename(get_terragrunt_dir())

  db_instances = {
      vip-common = {
        dbs = {
          vipdashboard = {
            name              = "vipdashboard"
            owner             = "vipdashboard"
          }

          vip_notifier_stage = {
            name              = "vip_notifier_stage"
            owner             = "vip_notifier_stage"
          }
        }

        roles = {
          vipdashboard = {
            name  = "vipdashboard"
            login = false
          }

          vipdashboard-web = {
            name = "vipdashboard-web"
            login = true
            encrypted_kms_password = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AEYUF66XsLxcGyzQr/8svCTAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMVyIrhZ3JTuQH2ADtAgEQgCczQK91CkUKDbv5FxO5ZYysvkMgzGJ16ANj9PcPxZQ4RPa6NQByOhs="
            roles = ["vipdashboard"]
          }

          vipdashboard-notifycreator = {
            name = "vipdashboard-notifycreator"
            login = true
            encrypted_kms_password = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AHj1TwKXQCGFpNNqGaxky4SAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM8lk8f0XQBIRdhoTTAgEQgCe2S/Y/a6xvLZMnlQNnIsPRfiTCSFkmYMf4kH3cFMmmpA25JHobI1Q="
            roles = ["vipdashboard"]
          }

          vipdashboard-entitysaver = {
            name = "vipdashboard-entitysaver"
            login = true
            encrypted_kms_password = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AH8xEtjU0NOWDva2pNwkcRjAAAAajBoBgkqhkiG9w0BBwagWzBZAgEAMFQGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM7gpFTSQLbTCBaF3zAgEQgCde+rETs0s67AuS0i6/9+uBQlABaRsN0tv39kBYvJ9NpHVcfW0HG1I="
            roles = ["vipdashboard"]
          }

          vip_notifier_stage = {
            name  = "vip_notifier_stage"
            login = false
          }

          notifier = {
            name = "notifier"
            login = true
            encrypted_kms_password = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AGuCnwPctYjee1NziqadE5eAAAAbTBrBgkqhkiG9w0BBwagXjBcAgEAMFcGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMsC+IxkPpQinQDltVAgEQgCo9R4b/OqkMJfQKx1QwdaiHBLTgfJFRhyHVEJoIjo5JddYNzXkcnodGDFU="
            roles = ["vip_notifier_stage"]
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

