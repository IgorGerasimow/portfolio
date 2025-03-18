resource "aws_db_subnet_group" "this" {
  count      = var.enabled ? 1 : 0
  name       = "${local.main_prefix}-${var.svc}"
  subnet_ids = var.subnets
  tags = merge(
    var.tags,
    local.tags
  )
  description = "Managed by Terraform for svc ${var.svc}"
}

data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.enabled && var.monitoring_interval > 0 ? 1 : 0

  name               = "${local.main_prefix}-${var.svc}-rds"
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring.json

  tags = merge(
    var.tags,
    local.tags
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.enabled && var.monitoring_interval > 0 ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


resource "aws_db_instance" "this" {
  count      = var.enabled ? 1 : 0
  identifier = "${local.main_prefix}-${var.svc}"
  #DB server and type
  engine                = var.engine
  engine_version        = var.engine_version
  storage_type          = var.storage_type
  allocated_storage     = var.allocated_storage
  instance_class        = var.instance_class
  max_allocated_storage = var.max_allocated_storage
  iops                  = var.iops

  # Network
  db_subnet_group_name   = aws_db_subnet_group.this[0].id
  availability_zone      = var.multi_az ? null : var.availability_zone
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = var.vpc_security_group_ids

  username = var.username
  password = var.password

  #backupd and delete

  deletion_protection       = var.deletion_protection
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  delete_automated_backups  = var.delete_automated_backups
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "${local.main_prefix}-${var.svc}-final"
  maintenance_window        = var.maintenance_window
  # Monitor

  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_interval > 0 ? coalesce(var.monitoring_role_arn, tostring(aws_iam_role.this[0].arn), null) : null
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  # Other 
  tags = merge(
    var.tags,
    local.tags
  )


}