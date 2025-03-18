resource "aws_lb" "this" {
  count = var.enabled ? 1 : 0
  name               = "${local.main_prefix}-${var.svc}"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.sg_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = var.drop_invalid_header_fields
  idle_timeout = var.load_balancer_type ==  "application" ?  var.idle_timeout : null
  enable_http2 = var.load_balancer_type ==  "application" ?  var.enable_http2 : null
  ip_address_type = var.ip_address_type

  access_logs {
    bucket  = var.log_bucket
    prefix  = var.log_prefix
    enabled = var.log_bucket == "" ? false : true
  }

  tags = merge(
      local.tags,
      var.tags
  )
}

