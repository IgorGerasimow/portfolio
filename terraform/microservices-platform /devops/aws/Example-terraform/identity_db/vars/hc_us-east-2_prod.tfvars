svc = "identity"

rds = {
  ext_dns = false
  int_dns = true
  enabled = true
  publicly_accessible = false
  multi_az = true
  engine = "postgres"
  engine_version = "11.6"
  instance_class = "db.t2.micro"
  allocated_storage = 100
  storage_type = "io1"
  iops = 1000
}

control_domain_dns = "Example.Example."