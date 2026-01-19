# ----------------------------
# Security Group for ALB
# ----------------------------
resource "aws_security_group" "alb_sg" {
  name        = "aws-study-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.study_vpc.id  # network.tfのVPCを参照

  # Inbound Rules (HTTP 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules (Allow All)
  # ※Terraformでは明示しないとアウトバウンドが拒否されるため必須
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws-study-alb-sg"
  }
}

# ----------------------------
# Security Group for EC2
# ----------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "aws-study-ec2-sg"
  description = "Security group for aws-study-ec2"
  vpc_id      = aws_vpc.study_vpc.id

  # SSH (22) from specific IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["118.6.173.228/32"] # CFnテンプレートの値を指定
  }

  # HTTP (8080) from ALB SG
  # ソースに他のセキュリティグループIDを指定する場合
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Outbound Rules (Allow All)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws-study-ec2-sg"
  }
}