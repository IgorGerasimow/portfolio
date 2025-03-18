
output "id" {
  value = aws_instance.this[0].id
}

output "arn" {
  value = aws_instance.this[0].arn
}

output "private_ip" {
  value = aws_instance.this[0].private_ip
}
