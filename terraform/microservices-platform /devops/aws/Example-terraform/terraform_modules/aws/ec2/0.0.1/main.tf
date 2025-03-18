resource "aws_instance" "this" {
  count                                = var.enabled ? 1 : 0
  ami                                  = var.ami
  instance_type                        = var.instance_type
  availability_zone                    = var.availability_zone == "" ? null : var.availability_zone
  placement_group                      = var.placement_group == "" ? null : var.placement_group
  ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  key_name                             = var.key_name
  monitoring                           = var.monitoring
  vpc_security_group_ids               = var.vpc_security_group_ids
  subnet_id                            = var.subnet_id
  associate_public_ip_address          = var.associate_public_ip_address
  private_ip                           = var.private_ip == "" ? null : var.private_ip
  source_dest_check                    = var.source_dest_check
  user_data                            = var.user_data == "" ? null : var.user_data
  iam_instance_profile                 = var.iam_instance_profile == "" ? null : var.iam_instance_profile
  tags = merge(
    local.tags,
    var.tags
  )
  volume_tags = merge(
    local.tags,
    var.tags
  )
  root_block_device {
    volume_type           = lookup(var.root_block_device, "volume_type", null)
    volume_size           = lookup(var.root_block_device, "volume_size", null)
    iops                  = lookup(var.root_block_device, "iops", null)
    delete_on_termination = lookup(var.root_block_device, "delete_on_termination", null)
    encrypted             = lookup(var.root_block_device, "encrypted", null)
    kms_key_id            = lookup(var.root_block_device, "kms_key_id", null)

  }
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      device_name           = lookup(ebs_block_device.value, "device_name", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device["device_name"]
      virtual_name = lookup(ephemeral_block_device, "snapshot_id", null)
      no_device    = lookup(ephemeral_block_device, "volume_type", null)
    }
  }
}