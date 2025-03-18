include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds?ref=v0.1.102-rds"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  db_instances = {

     template-renderer = {
       engine                = "mysql"
       engine_version        = "8.0"
       storage_type          = "gp3"
       allocated_storage     = 20
       max_allocated_storage = 100
       identifier            = "template-renderer"
       instance_class        = "db.m6gd.large"
       username              = "root"
       encrypted_password    = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgHG3eQ6NCSDklmy7xNw+0W9AAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMfkMQyj3PR1puS8jzAgEQgCvPOkqFdnvCB7wWrzrJSaiao6KHDDKBSjJzfxYSn5f1U+TXt2QXjkJB/nxc"
       security_group_ids    = [dependency.sg.outputs.mysql_sg_id]
       deletion_protection   = true
       tags                  = { Jira    = "studioSTREAM-23897"
                                 Product = "TH"
                                 App     = "template-renderer" }
     }

     content-studio = {
       engine                = "mysql"
       engine_version        = "8.0"
       storage_type          = "gp3"
       allocated_storage     = 20
       max_allocated_storage = 100
       identifier            = "content-studio"
       instance_class        = "db.m6gd.large"
       username              = "root"
       encrypted_password    = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgFn6g9QMKwpXYZhEiQxw5E0AAAAbjBsBgkqhkiG9w0BBwagXzBdAgEAMFgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMaM5eqCMJfdx4fPwFAgEQgCuxP4vPH1hyPSR/vZeRv99MpMS9WplogT57PQ76pVx2bEABUkWcvBgKW3dp"
       security_group_ids    = [dependency.sg.outputs.mysql_sg_id]
       deletion_protection   = true
       tags                  = { Jira    = "studioSTREAM-23897"
                                 Product = "TH"
                                 App     = "content-studio" }
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
