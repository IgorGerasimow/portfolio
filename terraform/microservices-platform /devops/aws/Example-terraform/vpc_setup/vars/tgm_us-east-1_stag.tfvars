route53_zone_int =  "Example.com." 

route53_zone_ext =  "" 

az_count = 3

subnets_int =  { 
    us-east-1a = "10.0.0.0/19" 
    us-east-1b = "10.0.32.0/19" 
    us-east-1c = "10.0.64.0/19" 
    us-east-1d = "10.0.96.0/19" 
    us-east-1e = "10.0.128.0/19" 
    us-east-1f = "10.0.160.0/19"  
}


subnets_ext = { 
    us-east-1a = "10.0.192.0/21" 
    us-east-1b = "10.0.200.0/21" 
    us-east-1c = "10.0.208.0/21" 
    us-east-1d = "10.0.216.0/21" 
    us-east-1e = "10.0.224.0/21" 
    us-east-1f = "10.0.232.0/21"  
}


vpc_cidr =  "10.0.0.0/16" 

tag_internal = {
        "kubernetes.io/cluster/backend-api-v1" = "owned"
        "kubernetes.io/cluster/Example-use1-prod-platform" = "shared"
        "kubernetes.io/role/internal-elb" = 1
    }

tag_external = {
        "kubernetes.io/cluster/backend-api-v1" = "owned"
        "kubernetes.io/cluster/Example-use1-prod-platform" = "shared"
        "kubernetes.io/role/elb" = 1
    }