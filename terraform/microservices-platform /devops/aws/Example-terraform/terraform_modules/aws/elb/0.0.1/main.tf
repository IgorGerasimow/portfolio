resource "aws_elb" "this" {
  count = var.enabled ? 1 : 0
  name  = "${local.main_prefix}-${var.svc}-${var.type}"
  # availability_zones = var.availability_zones
  security_groups = var.security_groups
  subnets         = var.subnets

  access_logs {
    enabled       = var.access_log_enabled
    bucket        = var.access_log_bucket
    bucket_prefix = var.access_log_prefix
    interval      = var.access_log_interval
  }

  dynamic "listener" {
    for_each = var.listeners
    content {
      instance_port      = listener.value["instance_port"]
      instance_protocol  = listener.value["instance_protocol"]
      lb_port            = listener.value["lb_port"]
      lb_protocol        = listener.value["lb_protocol"]
      ssl_certificate_id = lookup(listener.value, "ssl_certificate_id", null)
    }
  }

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.health_timeout
    target              = var.health_target
    interval            = var.health_interval
  }

  instances = var.instances == [] ? null : var.instances

  cross_zone_load_balancing   = var.cross_zone_load_balancing
  idle_timeout                = var.idle_timeout
  connection_draining         = var.connection_draining
  connection_draining_timeout = var.connection_draining_timeout

  tags = merge(
    local.tags,
    var.tags
  )
}