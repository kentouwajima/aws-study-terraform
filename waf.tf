# ----------------------------
# WAF Web ACL
# ----------------------------
resource "aws_wafv2_web_acl" "study_web_acl" {
  name        = "aws-study-waf-webacl"
  description = "Web ACL for aws-study-alb"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # AWS Managed Rules (Common Rule Set)
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "aws-study-waf-webacl"
    sampled_requests_enabled   = true
  }
}

# ----------------------------
# WAF Association (ALBへの紐付け)
# ----------------------------
resource "aws_wafv2_web_acl_association" "study_web_acl_assoc" {
  resource_arn = aws_lb.study_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.study_web_acl.arn
}

# ----------------------------
# WAF Log Group
# ----------------------------
resource "aws_cloudwatch_log_group" "waf_log_group" {
  # CloudFormationの ${AWS::StackName} の代わりに、
  # プロジェクト名を含めた固定名を設定します
  # ※ "aws-waf-logs-" で始まる必要があります
  name              = "aws-waf-logs-aws-study"
  retention_in_days = 7
}

# ----------------------------
# WAF Logging Configuration
# ----------------------------
resource "aws_wafv2_web_acl_logging_configuration" "study_waf_logging" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_log_group.arn]
  resource_arn            = aws_wafv2_web_acl.study_web_acl.arn
}