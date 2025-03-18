data "aws_subnet" "az" {
  count = var.enabled ? length(var.subnet_ids) : 0
  id = element(var.subnet_ids, count.index)
  
}

data "aws_vpc" "get_cidr" {
  count = var.enabled ? 1 : 0
  id = data.aws_subnet.az[0].vpc_id
  
}

resource "aws_security_group" "eks" {
    count = var.enabled ? 1 : 0
    name        = "${local.main_prefix}-${var.svc}"
    description = "EKS master role for ${local.main_prefix}-${var.svc}"
    vpc_id      = data.aws_subnet.az[0].vpc_id
    
    tags = merge(
        local.tags, 
        var.tags
        )
}

resource "aws_security_group_rule" "allow_all_inside" {
    count = var.enabled ? 1 : 0
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  security_group_id = aws_security_group.eks[0].id
  source_security_group_id = aws_security_group.eks[0].id
}

resource "aws_security_group_rule" "allow_pc_ssh" {
    count = var.enabled ? 1 : 0
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_group_id = aws_security_group.eks[0].id
  cidr_blocks = [data.aws_vpc.get_cidr[0].cidr_block]
}


resource "aws_security_group_rule" "allow_egress_ext" {
  count = var.enabled ? 1 : 0
  type            = "egress"
  from_port       = 0
  to_port         =  0
  protocol        = "-1"
  security_group_id = aws_security_group.eks[0].id
  cidr_blocks = ["0.0.0.0/0"]
}