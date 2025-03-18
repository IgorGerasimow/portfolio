resource "aws_route53_zone" "private" {
  count = var.region == "us-east-1" ? 1 : 0
  name = var.route53_zone_int

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}


output "r53_zone_int_id" {
  value = compact(concat(aws_route53_zone.private.*.zone_id))[0]
}



output "r53_zone_int_name" {
  value = compact(concat(aws_route53_zone.private.*.name))[0]
}
