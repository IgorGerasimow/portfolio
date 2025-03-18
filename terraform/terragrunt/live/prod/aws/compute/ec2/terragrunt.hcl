include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/compute/ec2?ref=v0.1.43-ec2"
}

dependency "sg" {
  config_path = "../../networking/securitygroups"
}

inputs = {

  studio_ec2_instances = {
    kafka_jump_host = {
      name = "kafka-host"
      instance_type = "t3.medium"
      volume_size = "100"
      security_group = [dependency.sg.outputs.kafka_host_sg_id]
      subnet_id = 1
    }
  }
}

dependencies {
  paths = ["../../security/key_pair",
           "../../networking/securitygroups",
           "../../networking/vpc",
          ]
}
