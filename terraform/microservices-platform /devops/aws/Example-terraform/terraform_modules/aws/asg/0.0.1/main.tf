data "aws_subnet" "az" {
  count = var.enabled ? length(var.subnets) : 0
  id = element(var.subnets, count.index)
  
}


resource "aws_launch_template" "this" {
  count = var.enabled ? 1 : 0
  name  = "${local.main_prefix}-${var.svc}"

  dynamic "block_device_mappings" {
    for_each = var.device_block_mappings
    content {
      device_name = block_device_mappings.value["device_name"]
      ebs {
        volume_size = block_device_mappings.value["ebs_volume_size"]
      }
    }
  }

  disable_api_termination = var.disable_api_termination
  ebs_optimized           = var.ebs_optimized

  iam_instance_profile {
    name = var.iam_instance_profile
  }
  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.security_groups
  }
  # vpc_security_group_ids = var.security_groups

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      local.tags
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      var.tags,
      local.tags
    )
  }

  user_data = var.user_data == "" ? null : base64encode(var.user_data)
}

resource "aws_autoscaling_group" "this" {
  name               = "${local.main_prefix}-${var.svc}"
  availability_zones = data.aws_subnet.az[*].availability_zone
  max_size           = var.max_size
  min_size           = var.min_size
  health_check_type  = var.health_check_type
  load_balancers     = var.load_balancers
  target_group_arns  = var.target_group_arns

  launch_template {
    id      = aws_launch_template.this[0].id
    version = "$Latest"
  }
  tags = concat(
    var.tags_asg,
    local.tags_asg
  )
  vpc_zone_identifier = var.subnets
}