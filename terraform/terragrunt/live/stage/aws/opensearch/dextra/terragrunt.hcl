include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/opensearch?ref=v0.1.78-opensearch"
}

inputs = {

  studio_elasticsearch = {
    studiomail = {
      name = "studiomail"
      elasticsearch_version = "6.4"
      instance_type = "t3.small.elasticsearch"
      instance_count = 3
      ebs_volume_size = 50
      encrypt_at_rest_enabled = false
      dedicated_master_enabled = false
      create_iam_service_linked_role = true
      zone_awareness_enabled = true
      availability_zone_count = 3
      kibana_subdomain_name = "kibana-studiomail"
      kibana_hostname_enabled = false
      domain_hostname_enabled = true
      domain_endpoint_https = false
      tags = {
        "App"     = "shared",
        "Product" = "studio",
        "Jira"    = "None",
      }
    }
  }
  dns_zone = "studio-stage.corp.loc"
  name = "elasticsearch"
}

dependencies {
  paths = [
    "../../networking/vpc",
    "../../networking/route53",
  ]
}
