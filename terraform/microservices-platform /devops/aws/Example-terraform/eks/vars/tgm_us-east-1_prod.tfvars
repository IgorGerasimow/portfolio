certificate = ["*.Example.us"]

alb_dns_names = ["api.Example.us"]

lb = {
    internal = false
}

target_group = {
    port = 32080
    listener_port = 443 
    protocol = "HTTP"
    healthcheck_path = "/ping"
    healthcheck_port = 32081
    listener_protocol = "HTTPS"
}

eks = {
    endpoint_public_access = true
    worker_instance_type = "t3a.medium"
    key_name =  "platform_main"
    mapUsers = "templates/config_mapUsers_prod.yml"
    max_size = 4
    min_size = 2
    eks_release = "v20200312"
}

control_domain_dns = "Example.us."

namespaces = ["dev", "qa", "prod"]

cloudfront = [
    {
        id  = "dev" 
        origin_id = "Example.us"
        cert_arn  = "arn:aws:acm:us-east-1:Example:certificate/47519304-b39a-4e56-bc2f-99917df160e0"
    }
]

rds = {
  ext_dns = false
  int_dns = false
  enabled = false
  publicly_accessible = true
  multi_az = true
  engine = "postgres"
  engine_version = "11.6"
  instance_class = "db.t2.micro"
  allocated_storage = 100
  storage_type = "io1"
  iops = 1000
}