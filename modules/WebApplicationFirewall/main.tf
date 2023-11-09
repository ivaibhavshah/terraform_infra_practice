resource "aws_wafv2_web_acl" "WafWebAcl" {
  
  name        = "rate-based-example"
  description = "Example of a Cloudfront rate based statement."
  scope       = "CLOUDFRONT"
  provider    =  aws.us-east
  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"

        
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}

resource "aws_cloudwatch_log_group" "WafWebAclLoggroup" {
  count = terraform.workspace == "prod" ? 1 : 0

  name              = "aws-waf-logs-wafv2-web-acl"
  retention_in_days = 30
}


