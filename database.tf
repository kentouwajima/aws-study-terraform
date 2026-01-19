# ----------------------------
# RDS Subnet Group
# ----------------------------
resource "aws_db_subnet_group" "study_rds_subnet_group" {
  name        = "aws-study-rds-subnet-group"
  description = "subnet group for aws-study-rds"
  # プライベートサブネット(1a, 1c)に配置
  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id
  ]

  tags = {
    Name = "aws-study-rds-subnet-group"
  }
}

# ----------------------------
# RDS Instance
# ----------------------------
resource "aws_db_instance" "study_rds" {
  identifier     = "aws-study-rds"
  engine         = "mysql"
  engine_version = "8.0.43"
  instance_class = "db.t4g.micro"
  db_name        = "awsstudy"

  username = "root"
  password = "rootroot" # 学習用のためハードコード（本番ではSecretsManager等を推奨）

  allocated_storage     = 20
  max_allocated_storage = 1000
  storage_type          = "gp2"

  # ネットワーク設定
  db_subnet_group_name   = aws_db_subnet_group.study_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = false
  publicly_accessible    = false
  port                   = 3306

  # バックアップ・メンテ設定
  backup_retention_period    = 7
  auto_minor_version_upgrade = true

  # 削除時の設定（学習用に削除しやすく設定）
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "aws-study-rds"
  }
}
