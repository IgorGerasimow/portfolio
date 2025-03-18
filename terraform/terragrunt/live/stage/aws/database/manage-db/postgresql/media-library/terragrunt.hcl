include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/manage-db/postgresql?ref=v0.1.55-mysql-postgresql"
}

locals {

  set_name = basename(get_terragrunt_dir())

  db_instances = {
      media-library = {
        dbs = {
          media-library = {
            name              = "media_library"
            owner             = "media-library"
          }
        }

        roles = {
          media-library = {
            name  = "media_library"
            login = false
          }

          ml-admin = {
            name  = "ml_admin"
            login = false
          }

          ml-view = {
            name  = "ml_view"
            login = false
          }

          ml-service = {
            name  = "ml_service"
            login = false
          }

          media-library_user = {
            name = "media_library_user"
            login = true
            encrypted_kms_password = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AGjGi1opA8dtlKupQh0vPORAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM1+H7n8Aw47LDCUc3AgEQgCvzJiobO6oSnYEVHH+3K/8l1YO0TtFoPOLEeLMRV3RQwvVWokikKjlIdV9P"
            roles = ["media-library","ml-admin"]
          }

          ml-backoffice-api = {
            name = "ml_backoffice_api"
            login = true
            encrypted_kms_password = "AQICAHhVCcbWAuaYTt995+ylkUHOqDv394RG0D+/euMrSro+ogGifbZZEId5u1sS8El80IK+AAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMvMRfwYX4RM4LnbfPAgEQgCuN5u/2r/0ASJZsQ7ricoo8vsTkjgZmvAp2oRr70JUo6FmyP8o2Xgb4GAFa"
            roles = ["ml-service","ml-view"]
          }

          ml-content-api = {
            name = "ml_content_api"
            login = true
            encrypted_kms_password = "AQICAHhVCcbWAuaYTt995+ylkUHOqDv394RG0D+/euMrSro+ogFEhb0I23vIC9XASnRcB/aTAAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMhvXkVrIvxGD1cg8JAgEQgCvBIqZ+YZtKCGqybJzrtn4jstN8ZI58a8oiVAKq/R7PwY80Cw3yuxvXKgzn"
            roles = ["ml-service","ml-view"]
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
