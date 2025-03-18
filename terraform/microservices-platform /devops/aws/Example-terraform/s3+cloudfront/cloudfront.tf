resource "aws_s3_bucket" "cloudfront" {
  count = length(var.cloudfront)
  bucket = "${local.cloudfront_prefix}-${var.cloudfront[count.index].id}-${var.svc}"
  acl    = "private"

  tags = {
    Name = "${local.cloudfront_prefix}-${var.cloudfront[count.index].id}-${var.svc}"
    env    = var.env
    region = var.region
    svc    = var.svc
  }

  website {
      index_document = "index.html" 
      error_document = "index.html" 
  }
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  count = length(var.cloudfront)

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class = "PriceClass_All"
  http_version = "http2"

  origin {
    domain_name = aws_s3_bucket.cloudfront[count.index].bucket_regional_domain_name
    origin_id   = var.cloudfront[count.index].origin_id
    custom_origin_config {
        http_port = 80
        https_port = 443
        origin_keepalive_timeout = 5 
        origin_protocol_policy = "http-only"
        origin_read_timeout = 30
        origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  aliases = [var.cloudfront[count.index].origin_id]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.cloudfront[count.index].origin_id

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = false
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
      acm_certificate_arn = var.cloudfront[count.index].cert_arn
      ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  tags = {
    env    = var.env
    region = var.region
    svc    = var.svc
  }

}

resource "aws_route53_record" "frontend" {
  count = length(var.cloudfront)
  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.cloudfront[count.index].origin_id
  type    = "CNAME"
  ttl     = "60"
  records = [aws_cloudfront_distribution.s3_distribution[count.index].domain_name]
  
}
