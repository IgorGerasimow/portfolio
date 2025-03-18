output "vpc_id" {
  value = aws_vpc.this[0].id
}

output "subnet_int" {
  value = aws_subnet.subnets_internal.*.id
}

output "subnet_ext" {
  value = aws_subnet.subnets_external.*.id
}


