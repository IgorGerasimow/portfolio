locals {
  short_region = "${replace(var.region, "/^([a-z]*)-([a-z])[a-z]{3,4}?([a-z]?)[a-z]*-(\\d)$/", "$1$2$3$4")}"
  main_prefix  = "${var.project}-${local.short_region}-${var.env}"
  cloudfront_prefix = "${var.project}-ui-${local.short_region}"
  tags = {
    Name   = "${local.main_prefix}-${var.svc}"
    env    = var.env
    region = var.region
    svc    = var.svc
  }
}
