# ----------------------------
# VPC
# ----------------------------
resource "aws_vpc" "study_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "aws-study-vpc"
  }
}

# ----------------------------
# Internet Gateway
# ----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.study_vpc.id  # !Ref StudyVPC の代わり

  tags = {
    Name = "aws-study-igw"
  }
}

# ----------------------------
# Public Subnets
# ----------------------------
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.study_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "aws-study-public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.study_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "aws-study-public-1c"
  }
}

# ----------------------------
# Private Subnets
# ----------------------------
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.study_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "aws-study-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.study_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "aws-study-private-1c"
  }
}

# ----------------------------
# Route Table (Public)
# ----------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.study_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "aws-study-public-rt"
  }
}

# ----------------------------
# Route Table Associations
# ----------------------------
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

# ----------------------------
# S3 VPC Endpoint
# ----------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.study_vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.public.id]
}