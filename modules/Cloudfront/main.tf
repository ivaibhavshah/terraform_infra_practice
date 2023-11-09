resource "aws_cloudfront_distribution" "cf_dist" {

  enabled                    = true
  aliases                    = var.aliases
  price_class                = var.price_class
  origin {
    domain_name              = var.alb_dns_name
    origin_id                = var.alb_dns_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = var.origin_protocol_policy
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = var.alb_dns_name
    viewer_protocol_policy   = var.viewer_protocol_policy
    cache_policy_id          = var.caching_policy
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    
  }
  restrictions {
    geo_restriction {
      restriction_type       = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  web_acl_id = var.web_acl_arn
}
