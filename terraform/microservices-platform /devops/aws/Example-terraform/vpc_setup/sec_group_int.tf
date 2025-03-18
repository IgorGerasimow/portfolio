resource "aws_security_group" "db" {
    name        = "${local.main_prefix}-db-access"
    description = "Seg group for db"
    vpc_id      = module.vpc.vpc_id
    
    tags = {
        Name = "${local.main_prefix}-db-access"
        platform = var.platform
        group  = var.group
        env = var.env
        region = var.region
    }
}

resource "aws_security_group_rule" "allow_postgres" {
  type            = "ingress"
  from_port       = 5432
  to_port         =  5432
  protocol        = "tcp"
  security_group_id = aws_security_group.db.id
  cidr_blocks = [var.vpc_cidr]
}


resource "aws_security_group_rule" "allow_egress_db_ext" {
  type            = "egress"
  from_port       = 0
  to_port         =  0
  protocol        = "-1"
  security_group_id = aws_security_group.db.id
  cidr_blocks = ["0.0.0.0/0"]
}
