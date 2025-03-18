# VPC Creation 

resource "aws_vpc" "this" {
  count                = var.vpc_enable ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      Name   = "${var.infra_name}-${var.env}-${var.region}"
      region = var.region
    },
    var.tags
  )
}


resource "aws_subnet" "subnets_internal" {
  count                   = var.vpc_enable && length(var.subnets_int) > 0 ? var.az_count : 0
  vpc_id                  = aws_vpc.this[0].id
  map_public_ip_on_launch = var.map_public_ip_on_launch_int
  availability_zone       = var.az_list[count.index]
  cidr_block              = lookup(var.subnets_int, var.az_list[count.index])

  tags = merge(
    {
      Name   = "${var.infra_name}-${var.env}-${var.az_list[count.index]}-int",
      region = var.region
    },
    var.tags,
    var.tags_internal_subnet
  )
}

resource "aws_subnet" "subnets_external" {
  count                   = var.vpc_enable && length(var.subnets_ext) > 0 ? var.az_count : 0
  vpc_id                  = aws_vpc.this[0].id
  map_public_ip_on_launch = var.map_public_ip_on_launch_ext
  availability_zone       = var.az_list[count.index]
  cidr_block              = lookup(var.subnets_ext, var.az_list[count.index])

  tags = merge(
    {
      Name   = "${var.infra_name}-${var.env}-${var.az_list[count.index]}-ext"
      region = var.region
    },
    var.tags,
    var.tags_external_subnet
  )
}

# DMZ setup 

resource "aws_internet_gateway" "this" {
  count = var.vpc_enable ? 1 : 0
  tags = {
    Name = "${var.infra_name}-${var.env}-ext"
  }
  vpc_id = aws_vpc.this[0].id
}

resource "aws_route_table" "access_ext" {
  count  = var.vpc_enable ? 1 : 0
  vpc_id = aws_vpc.this[0].id

  tags = merge(
    {
      Name = "${var.infra_name}-${var.env}-ext"
    },
    var.tags
  )
}

resource "aws_route" "pub_access_dmz" {
  count                  = var.vpc_enable ? 1 : 0
  route_table_id         = aws_route_table.access_ext[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}


resource "aws_route_table_association" "access_ext" {
  count          = var.vpc_enable ? var.az_count : 0
  route_table_id = aws_route_table.access_ext[0].id
  subnet_id      = aws_subnet.subnets_external[count.index].id
}

# NAT gataway setup 

resource "aws_eip" "this" {
  count = var.vpc_enable ? var.az_count : 0
}

resource "aws_nat_gateway" "this" {
  count         = var.vpc_enable ? var.az_count : 0
  allocation_id = aws_eip.this[count.index].id
  subnet_id     = aws_subnet.subnets_external[count.index].id
}

resource "aws_route_table" "access_int" {
  count  = var.vpc_enable ? var.az_count : 0
  vpc_id = aws_vpc.this[0].id
  tags = merge(
    {
      Name = "${var.infra_name}-${var.env}-${var.az_list[count.index]}-int"
    },
    var.tags
  )
}

resource "aws_route" "pub_access" {
  count                  = var.vpc_enable ? var.az_count : 0
  route_table_id         = aws_route_table.access_int[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "nat_rules" {
  count          = var.vpc_enable ? var.az_count : 0
  route_table_id = aws_route_table.access_int[count.index].id
  subnet_id      = aws_subnet.subnets_internal[count.index].id
}

# DHCP options 

resource "aws_vpc_dhcp_options" "this" {
  count = var.vpc_enable ? 1 : 0

  domain_name          = var.domain_name
  domain_name_servers  = var.domain_name_servers
  ntp_servers          = var.ntp_servers
  netbios_name_servers = var.netbios_name_servers
  netbios_node_type    = var.netbios_node_type

  tags = merge(
    {
      Name = "${var.infra_name}-${var.env}-${var.region}"
    },
    var.tags
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = var.vpc_enable ? 1 : 0

  vpc_id          = aws_vpc.this[0].id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}

# Default VPC ACL 

resource "aws_default_network_acl" "this" {
  count = var.vpc_enable ? 1 : 0

  default_network_acl_id = aws_vpc.this[0].default_network_acl_id

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      action          = ingress.value.action
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = ingress.value.from_port
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
    }
  }
  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      action          = egress.value.action
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = egress.value.from_port
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
    }
  }

  tags = merge(
    {
      Name = "${var.infra_name}-${var.env}-${var.region}"
    },
    var.tags
  )
}

# ACL's 

resource "aws_network_acl" "public" {
  count = var.vpc_enable ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = aws_subnet.subnets_external.*.id

  tags = merge(
    {
      Name = "${var.infra_name}-${var.env}-${var.region}-ext"
    },
    var.tags
  )
}

resource "aws_network_acl_rule" "public_inbound" {
  count = var.vpc_enable ? length(var.private_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.public[0].id

  egress      = false
  rule_number = var.public_inbound_acl_rules[count.index]["rule_number"]
  rule_action = var.public_inbound_acl_rules[count.index]["rule_action"]
  from_port   = var.public_inbound_acl_rules[count.index]["from_port"]
  to_port     = var.public_inbound_acl_rules[count.index]["to_port"]
  protocol    = var.public_inbound_acl_rules[count.index]["protocol"]
  cidr_block  = var.public_inbound_acl_rules[count.index]["cidr_block"]
}

resource "aws_network_acl_rule" "public_outbound" {
  count = var.vpc_enable ? length(var.private_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.public[0].id

  egress      = true
  rule_number = var.public_outbound_acl_rules[count.index]["rule_number"]
  rule_action = var.public_outbound_acl_rules[count.index]["rule_action"]
  from_port   = var.public_outbound_acl_rules[count.index]["from_port"]
  to_port     = var.public_outbound_acl_rules[count.index]["to_port"]
  protocol    = var.public_outbound_acl_rules[count.index]["protocol"]
  cidr_block  = var.public_outbound_acl_rules[count.index]["cidr_block"]
}

# Acl local 

resource "aws_network_acl" "private" {
  count = var.vpc_enable ? 1 : 0

  vpc_id     = aws_vpc.this[0].id
  subnet_ids = aws_subnet.subnets_internal.*.id

  tags = merge(
    {
      Name = "${var.infra_name}-${var.env}-${var.region}-int"
    },
    var.tags
  )
}

resource "aws_network_acl_rule" "private_inbound" {
  count = var.vpc_enable ? length(var.private_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.private[0].id

  egress      = false
  rule_number = var.private_inbound_acl_rules[count.index]["rule_number"]
  rule_action = var.private_inbound_acl_rules[count.index]["rule_action"]
  from_port   = var.private_inbound_acl_rules[count.index]["from_port"]
  to_port     = var.private_inbound_acl_rules[count.index]["to_port"]
  protocol    = var.private_inbound_acl_rules[count.index]["protocol"]
  cidr_block  = var.private_inbound_acl_rules[count.index]["cidr_block"]
}

resource "aws_network_acl_rule" "private_outbound" {
  count = var.vpc_enable ? length(var.private_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.private[0].id

  egress      = true
  rule_number = var.private_outbound_acl_rules[count.index]["rule_number"]
  rule_action = var.private_outbound_acl_rules[count.index]["rule_action"]
  from_port   = var.private_outbound_acl_rules[count.index]["from_port"]
  to_port     = var.private_outbound_acl_rules[count.index]["to_port"]
  protocol    = var.private_outbound_acl_rules[count.index]["protocol"]
  cidr_block  = var.private_outbound_acl_rules[count.index]["cidr_block"]
}
