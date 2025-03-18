include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/manage-db/postgresql?ref=v0.1.55-mysql-postgresql"
}

locals {

  set_name = basename(get_terragrunt_dir())

  db_instances = {
      studio-engagement-promotion-integration = {
        dbs = {
          studio_engagement_promotion_integration = {
            name              = "studio_EngagementPromotionIntegration"
            owner             = "studio_engagement_promotion_integration_owner"
          }
          studio_engagement_promotion_integration_hangfire = {
            name              = "studio_EngagementPromotionIntegration_Hangfire"
            owner             = "studio_engagement_promotion_integration_owner"
          }
        }

        roles = {
          studio_engagement_promotion_integration_owner = {
            name  = "studio_engagement_promotion_integration_owner"
            login = false
          }

          studio_engagement_promotion_integration_user = {
            name = "studio_engagement_promotion_integration_user"
            login = true
            encrypted_kms_password = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgGzpC3ze7HJyjTP7cV6beGVAAAAdDByBgkqhkiG9w0BBwagZTBjAgEAMF4GCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMfeFqfsBz0SIlDxtoAgEQgDFOm24v85RlirIaY7lkhaE8MC8WTKcp2nKnZSuwwh6qEkoowGl6JU7Azha/J1Y+s/gU"
            roles = ["studio_engagement_promotion_integration_owner"]
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
