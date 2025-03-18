output "vpc_id" {
  value = module.vpc.vpc_id
}

output "az" {
  value = data.aws_availability_zones.available.names
}

output "subnet_int" {
  value = module.vpc.subnet_int
}

output "subnet_ext" {
  value = module.vpc.subnet_ext
}

output "sg_http_ext" {
  value = aws_security_group.http_ext.id
}

output "sg_db_int" {
  value = aws_security_group.db.id
}