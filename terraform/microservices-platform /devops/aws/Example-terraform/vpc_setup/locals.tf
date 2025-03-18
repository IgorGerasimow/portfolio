locals {
  short_region = "${replace(var.region,"/^([a-z]*)-([a-z])[a-z]{3,4}?([a-z]?)[a-z]*-(\\d)$/", "$1$2$3$4")}"
  main_prefix = "${var.name_platform}-${var.env}-${local.short_region}"
}