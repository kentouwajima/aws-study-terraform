# ----------------------------
# SNS Topic
# ----------------------------
resource "aws_sns_topic" "cpu_alarm_topic" {
  name         = "aws-study-cpu-alarm-topic"
  display_name = "AWS Study Alarm"
}

# ----------------------------
# SNS Subscription (Email)
# ----------------------------
resource "aws_sns_topic_subscription" "cpu_alarm_email" {
  topic_arn = aws_sns_topic.cpu_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email # variables.tfで定義した変数を利用
}

# ----------------------------
# CloudWatch Alarm (EC2 CPU)
# ----------------------------
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "aws-study-ec2-cpu-high"
  alarm_description   = "Alarm when CPU exceeds 10%"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  
  # 監視対象の特定（compute.tfで作ったEC2のIDを参照）
  dimensions = {
    InstanceId = aws_instance.study_ec2.id
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Average"
  threshold           = 10

  # アラーム状態になった時のアクション（SNSへの通知）
  alarm_actions       = [aws_sns_topic.cpu_alarm_topic.arn]
}

# ----------------------------
# CloudWatch Alarm (WAF Blocked)
# ----------------------------
resource "aws_cloudwatch_metric_alarm" "waf_blocked_alarm" {
  alarm_name          = "aws-study-waf-blocked"
  alarm_description   = "Alarm when WAF blocks any request"
  namespace           = "AWS/WAFV2"
  metric_name         = "BlockedRequests"
  
  dimensions = {
    WebACL = aws_wafv2_web_acl.study_web_acl.name
    Region = "ap-northeast-1"
    Rule   = "ALL"
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  alarm_actions       = [aws_sns_topic.cpu_alarm_topic.arn]
}