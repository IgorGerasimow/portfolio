output "id" {
  value = aws_lb_target_group.this[0].id
}

output "arn" {
  value = aws_lb_target_group.this[0].arn
}

output "arn_suffix" {
  value = aws_lb_target_group.this[0].arn_suffix
}

output "name" {
  value = aws_lb_target_group.this[0].name
}

output "listener_arn" {
  value = aws_lb_listener.this[0].arn
}
