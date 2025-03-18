locals {
  short_region = "${replace(var.region, "/^([a-z]*)-([a-z])[a-z]{3,4}?([a-z]?)[a-z]*-(\\d)$/", "$1$2$3$4")}"
  main_prefix  = "${var.project}-${local.short_region}-${var.env}"
  tags = {
    env    = var.env
    region = var.region
    svc    = var.svc
  }
  tags_asg = [
    {
      key                 = "env"
      value               = var.env
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${local.main_prefix}-${var.svc}"
      propagate_at_launch = true
    },
    {
      key                 = "region"
      value               = var.region
      propagate_at_launch = true
    },
    {
      key                 = "svc"
      value               = var.svc
      propagate_at_launch = true
  }]
}
