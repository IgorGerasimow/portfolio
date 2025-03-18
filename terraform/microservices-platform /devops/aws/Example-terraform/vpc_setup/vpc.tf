module "vpc" { 
    source              = "../terraform_modules/aws/vpc/0.0.1/"
    vpc_cidr            = var.vpc_cidr
    env                 = var.env
    region              = var.region
    infra_name          = var.name_platform
    az_count            = var.az_count
    az_list             = data.aws_availability_zones.available.names
    subnets_int         = var.subnets_int
    subnets_ext         = var.subnets_ext
    domain_name         = compact(concat(aws_route53_zone.private.*.name))[0]
    domain_name_servers = ["AmazonProvidedDNS"]
    ntp_servers         = []

    tags_internal_subnet = var.tag_internal
    
    tags_external_subnet = var.tag_external
    tags = {
      platform = var.platform
      group  = var.group
      env = var.env
      region = var.region
    }
}