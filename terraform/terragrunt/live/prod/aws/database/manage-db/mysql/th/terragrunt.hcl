include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/manage-db/mysql?ref=v0.1.55-mysql-postgresql"
}

locals {

  set_name = basename(get_terragrunt_dir())

  db_instances = {
      template-renderer = {

        dbs = {

          th_template_rendererDb = {
            name                  = "th_template_renderer"
            default_character_set = "utf8mb4"
            default_collation     = "utf8mb4_0900_ai_ci"
          }
        }

        users = {

          th_template_rendererUser = {
            user = "th_template_renderer"
            host = "%"
            grants = {
              th_content_studioDb_all = {
                database = "th_template_renderer"
                privileges = ["ALL PRIVILEGES"]
              }
            }
            encrypted_password = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgGOyKmWVUG5SiNzHtn0FKqvAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM/HZ28pntAYT/MTlOAgEQgCuSmZRr3j9ySklEfPxG6E88P7ZmewZ4LqjoA6ccli+BEGRzvq7G5aGE4YFt"
          }
        }
      }

      content-studio = {

        dbs = {

          th_content_studioDb = {
            name                  = "th_content_studio"
            default_character_set = "utf8mb4"
            default_collation     = "utf8mb4_0900_ai_ci"
          }
        }

        users = {

          th_content_studioUser = {
            user = "th_content_studio"
            host = "%"
            grants = {
              th_content_studioDb_all = {
                database = "th_content_studio"
                privileges = ["ALL PRIVILEGES"]
              }
            }
            encrypted_password = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgEBxkLWbhebC6aVGasHnK/8AAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMuPeQAgGbRi7i8c+GAgEQgCv7JN2Q7IeUtHBon876j4MkW960Sd7V/ifjZVP3X+lCvfs6GcRytnpFu4Hi"
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
