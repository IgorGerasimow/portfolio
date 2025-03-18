include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/compute/containers/ecs/atlantis?ref=v0.1.54-atlantis"
}

inputs = {
  atlantis_dns_zone              = "studio.corp.loc"
  atlantis_gitlab_user           = "atlantis-aws-prod-studio"
  atlantis_gitlab_user_token_enc = "AQICAHjujYkfYCPLziWNrTkT0Q2X0fuj0qSc7AU3TddW+Y2frgFTicuzSQYjdZbuSicnRaV5AAAAeDB2BgkqhkiG9w0BBwagaTBnAgEAMGIGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM6Ox9NBMhkZ8mbXK+AgEQgDXFV6KUvSP6g4CuBjGtM20HfieZLpD9VW8kU3Y8nHDW4YHQQ80LLB3NBAaVmqDqt34aU4NNtQ=="
  infracost_token_enc            = "AQICAHjujYkfYCPLziWNrTkT0Q2X0fuj0qSc7AU3TddW+Y2frgHRMZxjSF/yLbuzXf5l+pzeAAAAcjBwBgkqhkiG9w0BBwagYzBhAgEAMFwGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMk9CndhcXgQibIROwAgEQgC8v0EdMyf2XB/Bsu4EZ7WWL9izD2gcjczy3NEo4eM09eWBDO1xOCFvDki86LrRF8A=="
}

dependencies {
  paths = ["../../../../security/kms",
           "../../../../security/acm",
           "../../../../networking/route53",
           "../../../../networking/vpc",
          ]
}
