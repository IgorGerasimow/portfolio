include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds?ref=v0.1.102-rds"
}

inputs = {

  set_name = basename(get_terragrunt_dir())

  db_instances = {

    studio-engagement-promotion-integration = {
      engine                = "postgres"
      family                = "postgres14"
      engine_version        = "14.9"
      allocated_storage     = 10
      max_allocated_storage = 100
      identifier            = "studio-engagement-promotion-integration"
      instance_class        = "db.t4g.medium"
      username              = "studio_engagement_promotion_integration_admin"
      encrypted_password    = "AQICAHhB3ALNLeZo91htOFIfIg6ls4VzgNq0Sx75zFNU9X2FlgFNC89AGaeOHbU7SOJkgm2MAAAAcTBvBgkqhkiG9w0BBwagYjBgAgEAMFsGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMlBTHEiXap4ycSq3wAgEQgC4WknWyGCdE07izDRxvRF15WcEyFINX5rVp7DC6zCesYrqQXWAmJes/0EiHSHUj"
      security_group_ids    = [dependency.sg.outputs.postgresql_sg_id]
      parameter_group_name  = dependency.pg.outputs.parameter_group["psql_14"].name
      tags                  = { Jira    = "studioSTREAM-23911"
                                App     = "studio-engagement-promotion-integration"
                                Product = "Promotions"
                                Owner   = "Promo-Mechanics"
                                Team    = "Engagement-Hub" }
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
