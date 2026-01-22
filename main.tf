provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket = "tf-state-aws-study-kentouwajima"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}