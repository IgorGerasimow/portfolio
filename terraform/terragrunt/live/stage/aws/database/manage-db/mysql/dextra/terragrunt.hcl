include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/manage-db/mysql"
}

locals {

  set_name = basename(get_terragrunt_dir())

  db_instances = {
      dm = {

        dbs = {

          studiomailDb = {
            name                  = "studiomail_stage"
            default_character_set = "utf8mb4"
            default_collation     = "utf8mb4_0900_ai_ci"
          }

          th_content_studioDb = {
            name                  = "th_content_studio"
            default_character_set = "utf8mb4"
            default_collation     = "utf8mb4_0900_ai_ci"
          }

          th_template_rendererDb = {
            name                  = "th_template_renderer"
            default_character_set = "utf8mb4"
            default_collation     = "utf8mb4_0900_ai_ci"
          }
        }

        users = {

          studioUser = {
            user = "studio"
            host = "%"
            grants = {
              studiomailDb_all = {
                database = "studiomail_stage"
                privileges = ["ALL PRIVILEGES"]
              }
              th_content_studioDb_all = {
                database = "th_content_studio"
                privileges = ["ALL PRIVILEGES"]
              }
              th_template_rendererDb_all = {
                database = "th_template_renderer"
                privileges = ["ALL PRIVILEGES"]
              }
            }
            auth_plugin = "mysql_native_password"
            auth_string_hashed = "*FEF8CF7ED4494405C3F660872F7FDA2B084EFD4B"
          }
        }
      }
  }
}

inputs = {

  set_name     = local.set_name
  db_instances = local.db_instances
}

# Generate a provider and module call for each RDS instance
generate "mysql" {
  path      = "main_generated.tf"
  if_exists = "overwrite"
  contents = templatefile("../../../../../../_common/aws/database/manage-db/mysql/mysql-rds.tmpl", {
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
