resource "aws_route53_record" "envs" {
  count = length(var.alb_dns_names)
  zone_id = data.aws_route53_zone.public.zone_id
  name    = element(var.alb_dns_names, count.index)
  type    = "A"
  alias {
      name = module.alb.dns_name
      zone_id = module.alb.zone_id
      evaluate_target_health = false
  }
}


resource "aws_route53_record" "ext_rds" {
  count = var.rds.ext_dns ? 1 : 0
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "rds.${var.env}.${data.aws_route53_zone.public.name}"
  type    = "CNAME"
  records = ["rds.${var.env}.${data.aws_route53_zone.public.name}"]
}

resource "aws_route53_record" "int_rds" {
  count = var.rds.int_dns ? 1 : 0
  zone_id = data.terraform_remote_state.base.outputs.r53_zone_int_id
  name    = "rds.${var.env}.${data.terraform_remote_state.base.outputs.r53_zone_int_name}"
  ttl    = 60
  type    = "CNAME"
  records = [split(":",module.rds.endpoint)[0]]

}