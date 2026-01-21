# -----------------------------------------------------------
# security.tf の設定値を検証するテスト
# -----------------------------------------------------------

# ALB用セキュリティグループの検証
run "verify_alb_sg" {
  command = plan

  # 名前が正しいか
  assert {
    condition     = aws_security_group.alb_sg.name == "aws-study-alb-sg"
    error_message = "ALB SGの名前が不正です。"
  }

  # HTTP(80)が 0.0.0.0/0 から許可されているか検証
  # ingressはリストなので、forループで回して「条件に合うものが1つでもあるか(anytrue)」を確認します
  assert {
    condition = anytrue([
      for rule in aws_security_group.alb_sg.ingress :
      rule.from_port == 80 && rule.to_port == 80 && contains(rule.cidr_blocks, "0.0.0.0/0")
    ])
    error_message = "ALB SGでPort 80 (0.0.0.0/0) が許可されていません。"
  }
}

# EC2用セキュリティグループの検証
run "verify_ec2_sg" {
  command = plan

  # 名前が正しいか
  assert {
    condition     = aws_security_group.ec2_sg.name == "aws-study-ec2-sg"
    error_message = "EC2 SGの名前が不正です。"
  }

  # SSH(22)が 指定IP から許可されているか検証
  assert {
    condition = anytrue([
      for rule in aws_security_group.ec2_sg.ingress :
      rule.from_port == 22 && contains(rule.cidr_blocks, "118.6.173.228/32")
    ])
    error_message = "EC2 SGでSSH (指定IP) が許可されていません。"
  }

  # HTTP(8080) が許可されているか検証
  # (セキュリティグループIDの参照チェックはPlan段階では複雑になるため、ポートとプロトコルを重点的にチェック)
  assert {
    condition = anytrue([
      for rule in aws_security_group.ec2_sg.ingress :
      rule.from_port == 8080 && rule.protocol == "tcp"
    ])
    error_message = "EC2 SGでPort 8080 が許可されていません。"
  }
}

# RDS用セキュリティグループの検証
run "verify_rds_sg" {
  command = plan

  # 名前が正しいか
  assert {
    condition     = aws_security_group.rds_sg.name == "aws-study-rds-sg"
    error_message = "RDS SGの名前が不正です。"
  }

  # MySQL(3306) が許可されているか検証
  assert {
    condition = anytrue([
      for rule in aws_security_group.rds_sg.ingress :
      rule.from_port == 3306 && rule.protocol == "tcp"
    ])
    error_message = "RDS SGでPort 3306 が許可されていません。"
  }
}