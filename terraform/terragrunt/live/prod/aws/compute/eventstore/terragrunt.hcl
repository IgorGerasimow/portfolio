include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/compute/eventstore?ref=v0.1.94-eventstore"
}

inputs = {

  dns_zone = "studio.corp.loc"

  nodes = {
    eventstore_1 = {
      name              = "eventstore-1"
      instance_type     = "m5.4xlarge"
      ebs_size          = 100
      subnet_idx        = "0"
      tags              = {}
    }
    eventstore_2 = {
      name              = "eventstore-2"
      instance_type     = "m6a.4xlarge"
      ebs_size          = 100
      subnet_idx        = "1"
      tags              = {}
    }
    eventstore_3 = {
      name              = "eventstore-3"
      instance_type     = "m6a.4xlarge"
      ebs_size          = 100
      subnet_idx        = "2"
      tags              = {}
    }
  }
}

dependencies {
  paths = ["../../networking/securitygroups",
           "../../networking/vpc",
           "../../networking/route53",
           "../../security/key_pair",
           "../../security/iam",
          ]
}
