resource "aws_security_group" "http_ext" {
    name        = "${local.main_prefix}-http-ext"
    description = "Seg group for http and https externaly"
    vpc_id      = module.vpc.vpc_id
    
    tags = {
        Name = "${local.main_prefix}-http-ext"
        platform = var.platform
        group  = var.group
        env = var.env
        region = var.region
    }
}

resource "aws_security_group_rule" "allow_http_ext" {
  type            = "ingress"
  from_port       = 80
  to_port         =  80
  protocol        = "tcp"
  security_group_id = aws_security_group.http_ext.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_ext" {
  type            = "ingress"
  from_port       = 443
  to_port         =  443
  protocol        = "tcp"
  security_group_id = aws_security_group.http_ext.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_egress_http_ext" {
  type            = "egress"
  from_port       = 0
  to_port         =  0
  protocol        = "-1"
  security_group_id = aws_security_group.http_ext.id
  cidr_blocks = ["0.0.0.0/0"]
}
