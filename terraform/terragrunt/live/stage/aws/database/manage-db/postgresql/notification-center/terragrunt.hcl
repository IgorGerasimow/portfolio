include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/manage-db/postgresql?ref=v0.1.55-mysql-postgresql"
}

locals {

  set_name = basename(get_terragrunt_dir())

  db_instances = {
      nc-fe = {
        dbs = {
          notifc_fe = {
            name  = "notifc_fe"
            owner = "notifc_admin"
          }
        }

        roles = {
          notifc_admin = {
            name = "notifc_admin"
            login = true
            encrypted_kms_password = "AQICAHhVCcbWAuaYTt995+ylkUHOqDv394RG0D+/euMrSro+ogFCMOhLrUlzcFny1pBIDDyKAAAAbDBqBgkqhkiG9w0BBwagXTBbAgEAMFYGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMnhaGDFGSDG6LYAZCAgEQgCn29jYTVJB+nM1otfPUYk/S3LL1k1RdbeLZs8K6vWz2MV5K2Ed2uxSk6w=="
          }

          delivery = {
            name = "delivery"
            login = false
          }
          notifc_view = {
            name = "notifc_view"
            login = false
          }
          notifc_service = {
            name = "notifc_service"
            login = false
          }

          fe_delivery_api = {
            name = "fe_delivery_api"
            login = true
            encrypted_kms_password = "AQICAHhVCcbWAuaYTt995+ylkUHOqDv394RG0D+/euMrSro+ogFTP0kKcoF5uhCBjzCIcvn5AAAAbDBqBgkqhkiG9w0BBwagXTBbAgEAMFYGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMbmSVVGXWOyWpEYWUAgEQgCln0l69X23joE45Rb4THyihexo6wgtM0B4ncOpmsn++8MHRdsbxd8oyBA=="
            roles = ["delivery", "notifc_service"]
          }

          notifc_agent = {
            name = "notifc_agent"
            login = true
            encrypted_kms_password = "AQICAHhVCcbWAuaYTt995+ylkUHOqDv394RG0D+/euMrSro+ogGLR0jXe408G4Tf6+1LUPgpAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMTG9mxujIz1WQtujLAgEQgCvqbZBOVFhHnlnCfUHqlT+18DXppCaIh/1UMllqh9FlhfgfvLfeF/q52VQl"
            roles = ["notifc_service"]
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

