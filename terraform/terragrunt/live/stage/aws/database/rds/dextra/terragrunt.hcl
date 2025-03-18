include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds?ref=v0.1.56-rds"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  db_instances = {

     dm = {
       engine                = "mysql"
       engine_version        = "8.0"
       storage_type          = "gp3"
       allocated_storage     = 20
       max_allocated_storage = 60
       identifier            = "dm"
       instance_class        = "db.t3.small"
       username              = "root"
       encrypted_password    = "AQICAHgauyOKvqqgBm6sbN1IAccCtERv7Fn9lXlWc6J58oOM0AH9sSYiofUhthOjT7LigU0+AAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMp0oASUkqiZ3G4pEIAgEQgCvgrKaVPt/cVj7zZDT9RdwYZQ2cNRNMDt6L6PXjgtlqsx2VhPyN0nGxyCaK"
       parameter_group_name  = dependency.pg.outputs.parameter_group["mysql-dms"].name
       security_group_ids    = [dependency.sg.outputs.mysql_sg_id]
       deletion_protection   = true
       tags                  = { Jira    = "studioSTREAM-16974"
                                 Product = "studio"
                                 App     = "studio" }
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
