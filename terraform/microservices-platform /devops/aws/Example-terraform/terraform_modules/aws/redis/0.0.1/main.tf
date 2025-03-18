resource "aws_elasticache_subnet_group" "this" {
  count      = var.enabled ? 1 : 0
  name       = "${local.main_prefix}-${var.svc}-redis"
  subnet_ids = var.subnet_ids
}

# resource "aws_elasticache_security_group" "this" {
#   count                = var.enabled ? 1 : 0
#   name                 = "${local.main_prefix}-${var.svc}-redis"
#   security_group_names = var.security_groups
# }

resource "aws_elasticache_replication_group" "this" {
  count                         = var.enabled ? 1 : 0
  replication_group_id          = "${local.main_prefix}-${var.svc}-redis"
  replication_group_description = "test description"

  node_type = var.node_type
  # number_cache_clusters         = var.num_cache_nodes
  auto_minor_version_upgrade = true

  # cluster_mode {
  #   replicas_per_node_group = var.replicas_per_node_group
  #   num_node_groups         = var.num_node_groups
  # }

  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.auth_token == "" ? null : var.auth_token
  kms_key_id                 = var.kms_key_id == "" ? null : var.kms_key_id

  engine               = "redis"
  engine_version       = var.engine_version
  parameter_group_name = var.parameter_group_name
  port                 = var.port

  automatic_failover_enabled = var.automatic_failover_enabled


  subnet_group_name  = aws_elasticache_subnet_group.this[0].name
  security_group_ids = var.security_groups

  apply_immediately = var.apply_immediately

  # Support 
  maintenance_window       = var.maintenance_window
  notification_topic_arn   = var.notification_topic_arn == "" ? null : var.notification_topic_arn
  snapshot_arns            = var.snapshot_arns == [] ? null : var.snapshot_arns
  snapshot_name            = var.snapshot_name == "" ? null : var.snapshot_name
  snapshot_window          = var.snapshot_window
  snapshot_retention_limit = var.snapshot_retention_limit
  tags = merge(
    local.tags,
    var.tags
  )
}