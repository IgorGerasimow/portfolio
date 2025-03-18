output "id" {
  value = aws_lb.this[0].id
}

output "arn" {
  value = aws_lb.this[0].arn
}

output "dns_name" {
  value = aws_lb.this[0].dns_name
}


output "arn_suffix" {
  value = aws_lb.this[0].arn_suffix
}

output "zone_id" {
  value = aws_lb.this[0].zone_id
}