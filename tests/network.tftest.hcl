# -----------------------------------------------------------
# network.tf の設定値を検証するテスト
# -----------------------------------------------------------

# テストケース1: VPCのCIDRブロック検証
run "verify_vpc_cidr" {
  
  # "plan"を指定することで、実際の作成を行わずに設定値のみチェックします
  command = plan

  assert {
    # aws_vpc.study_vpc の cidr_block が "10.0.0.0/16" であること
    condition     = aws_vpc.study_vpc.cidr_block == "10.0.0.0/16"
    error_message = "VPCのCIDRブロックが不正です。期待値: 10.0.0.0/16"
  }
}

# テストケース2: サブネットのCIDRブロック検証
run "verify_subnet_cidrs" {
  
  command = plan

  # Public Subnet 1a (10.0.1.0/24)
  assert {
    condition     = aws_subnet.public_1a.cidr_block == "10.0.1.0/24"
    error_message = "Public Subnet 1a (ap-northeast-1a) のCIDRが不正です。"
  }

  # Public Subnet 1c (10.0.2.0/24)
  assert {
    condition     = aws_subnet.public_1c.cidr_block == "10.0.2.0/24"
    error_message = "Public Subnet 1c (ap-northeast-1c) のCIDRが不正です。"
  }

  # Private Subnet 1a (10.0.11.0/24)
  assert {
    condition     = aws_subnet.private_1a.cidr_block == "10.0.11.0/24"
    error_message = "Private Subnet 1a (ap-northeast-1a) のCIDRが不正です。"
  }

  # Private Subnet 1c (10.0.12.0/24)
  assert {
    condition     = aws_subnet.private_1c.cidr_block == "10.0.12.0/24"
    error_message = "Private Subnet 1c (ap-northeast-1c) のCIDRが不正です。"
  }
}