resource "aws_lb_target_group" "this" {
  count = var.enabled ? 1 : 0
  name     = "${local.main_prefix}-${var.svc}-${var.port}"
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  deregistration_delay = var.deregistration_delay 
  slow_start = var.slow_start
  load_balancing_algorithm_type = var.load_balancing_algorithm_type
  proxy_protocol_v2 = var.proxy_protocol_v2
  health_check {
    enabled = true
    interval = var.healthcheck_interval
    path = var.healthcheck_path
    port = var.healthcheck_port
    protocol = var.healthcheck_protocol
    timeout = var.healthcheck_timeout
    healthy_threshold = var.healthcheck_healthy_threshold
    unhealthy_threshold = var.healthcheck_unhealthy_threshold
    matcher = var.healthcheck_mathcer
  }
  stickiness { 
    enabled = var.stickiness_enabled
    type = "lb_cookie"
    cookie_duration = var.cookie_duration
  }
  target_type = var.target_type
}

resource "aws_lb_listener" "this" {
  count = var.enabled && var.action == "forward" ? 1 : 0
  load_balancer_arn = var.lb_arn
  port              = var.listener_port == 0 ?  var.port : var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.certificate_arn == null ? null : var.ssl_policy
  certificate_arn   = var.certificate_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }
}


