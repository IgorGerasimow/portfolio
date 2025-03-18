resource "aws_route53_record" "ext_rds" {
  count = var.rds.ext_dns ? 1 : 0
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "identitydb.${var.env}.${data.aws_route53_zone.public.name}"
  type    = "CNAME"
  records = ["rds.${var.env}.${data.aws_route53_zone.public.name}"]
}

resource "aws_route53_record" "int_rds" {
  count = var.rds.int_dns ? 1 : 0
  zone_id = data.terraform_remote_state.base.outputs.r53_zone_int_id
  name    = "identitydb.${var.env}.${data.terraform_remote_state.base.outputs.r53_zone_int_name}"
  ttl    = 60
  type    = "CNAME"
  records = [split(":",module.rds.endpoint)[0]]

}