# AWSを利用するための設定
provider "aws" {
  region = "ap-northeast-1"
}

# Terraformのバージョン指定など
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}