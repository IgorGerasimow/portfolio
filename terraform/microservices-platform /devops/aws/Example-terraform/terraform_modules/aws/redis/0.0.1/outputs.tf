output "id" {
  value = aws_elasticache_replication_group.this[0].id
}

output "configuration_endpoint_address" {
  value = aws_elasticache_replication_group.this[0].configuration_endpoint_address
}

output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.this[0].primary_endpoint_address
}

output "member_clusters" {
  value = aws_elasticache_replication_group.this[0].member_clusters
}
