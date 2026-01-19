# ----------------------------
# Data Source: Get Latest AMI
# ----------------------------
# CloudFormationの {{resolve:ssm:...}} 相当
# パラメータストアから最新のAmazon Linux 2023のAMI IDを取得
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

# ----------------------------
# EC2 Instance
# ----------------------------
resource "aws_instance" "study_ec2" {
  ami           = data.aws_ssm_parameter.al2023_ami.value
  instance_type = "t3.micro"
  key_name      = "kentouwajima"          # CFnテンプレートの値を指定
  subnet_id     = aws_subnet.public_1a.id # network.tfのSubnetを参照

  # セキュリティグループの紐付け
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  # EBSなどのストレージ設定はデフォルト(gp3/gp2などAMIの設定)が使用されます
  # 必要であれば root_block_device ブロックで指定可能

  tags = {
    Name = "aws-study-ec2"
  }
}
