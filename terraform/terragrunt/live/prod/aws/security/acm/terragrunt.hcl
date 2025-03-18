include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/security/acm?ref=v0.1.33-acm"
}

inputs = {
  certificates = {  "*.studio.corp.loc" = {
                      private_key_pem_enc = file("_w_.studio.corp.loc.key.enc"),
                      cert_pem = file("_w_.studio.corp.loc.crt"),
                      certificate_chain = file("corp-Certificate-Authority.pem")
                      tags = {
                        "Jira"    = "None",
                        "App"     = "shared",
                        "Product" = "shared",
                      }
                   },
                 }
}

dependencies {
  paths = ["../../security/kms",
          ]
}
