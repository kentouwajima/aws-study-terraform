# ----------------------------
# Application Load Balancer
# ----------------------------
resource "aws_lb" "study_alb" {
  name               = "aws-study-alb"
  internal           = false
  load_balancer_type = "application"

  # セキュリティグループ（security.tfで作成したもの）
  security_groups = [aws_security_group.alb_sg.id]

  # サブネット（network.tfで作成したパブリックサブネット2つ）
  subnets = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]

  tags = {
    Name = "aws-study-alb"
  }
}

# ----------------------------
# Target Group
# ----------------------------
resource "aws_lb_target_group" "study_tg" {
  name     = "aws-study-tg"
  port     = 8080 # アプリは8080番で待ち受ける想定
  protocol = "HTTP"
  vpc_id   = aws_vpc.study_vpc.id

  # ヘルスチェック設定
  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "aws-study-tg"
  }
}

# ----------------------------
# Listener (HTTP)
# ----------------------------
resource "aws_lb_listener" "study_alb_listener" {
  load_balancer_arn = aws_lb.study_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.study_tg.arn
  }
}

# ----------------------------
# Target Group Attachment
# ----------------------------
# 作成済みのEC2インスタンスをターゲットグループに登録
resource "aws_lb_target_group_attachment" "study_ec2_attach" {
  target_group_arn = aws_lb_target_group.study_tg.arn
  target_id        = aws_instance.study_ec2.id
  port             = 8080
}