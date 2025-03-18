output "endpoint" {
  value = aws_db_instance.this != [] ? concat([aws_db_instance.this[0].endpoint], [""])[0] : null
}

output "availability_zone" {
  value = aws_db_instance.this != [] ? concat([aws_db_instance.this[0].availability_zone], [""])[0]  : null
}

output "arn" {
  value = aws_db_instance.this != [] ? concat([aws_db_instance.this[0].arn], [""])[0]  : null
}

output "address" {
  value = aws_db_instance.this != [] ? concat([aws_db_instance.this[0].address], [""])[0]  : null
}

output "id" {
  value = aws_db_instance.this != [] ? concat([aws_db_instance.this[0].id], [""])[0]  : null
}

output "name" {
  value = aws_db_instance.this != [] ? concat([aws_db_instance.this[0].name], [""])[0] : null
}

output "port" {
  value = aws_db_instance.this != [] ? concat([aws_db_instance.this[0].port], [""])[0] : null
}

output "status" {
  value = aws_db_instance.this != [] ? concat([aws_db_instance.this[0].status], [""])[0] : null
}

output "username" {
  value = aws_db_instance.this != [] ?  concat([aws_db_instance.this[0].username], [""])[0] : null
}