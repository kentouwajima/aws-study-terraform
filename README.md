# AWS Study Terraform

以前 CloudFormation で構築した AWS インフラ環境を、**Terraform** を使用して再現・構築するための学習用リポジトリです。

## プロジェクト概要

本プロジェクトでは、AWS の基本的な 3層アーキテクチャ（Web/App/DB）に加え、WAF や CloudWatch アラームを含めた実用的な構成を Terraform コード（HCL）で管理します。

## アーキテクチャ構成

CloudFormation テンプレートに基づき、以下のリソースを Terraform で再現します。



### 1. Network (VPC)
* **VPC:** 10.0.0.0/16
* **Subnets:**
    * Public Subnets (x2): ALB, EC2 用
    * Private Subnets (x2): RDS 用
* **Gateways:** Internet Gateway
* **Endpoints:** S3 VPC Endpoint (Gateway型)

### 2. Compute (EC2)
* **Instance:** t3.micro (Amazon Linux 2023)
* **Security Group:**
    * SSH (22): 特定のIPのみ許可
    * HTTP (8080): ALB からのアクセスのみ許可

### 3. Database (RDS)
* **Engine:** MySQL 8.0.43
* **Instance Class:** db.t4g.micro
* **Storage:** 20GB (gp2)
* **Security Group:** EC2 からのアクセス (3306) のみ許可

### 4. Load Balancer (ALB)
* **Type:** Application Load Balancer (Internet-facing)
* **Listener:** HTTP (80) -> EC2 (8080) へフォワード
* **Health Check:** HTTP / 200 OK

### 5. Security (WAF)
* **Web ACL:** Regional
* **Rules:** AWSManagedRulesCommonRuleSet
* **Association:** ALB に関連付け
* **Logging:** CloudWatch Logs へログ出力

### 6. Monitoring (CloudWatch & SNS)
* **Alarm 1 (EC2):** CPU使用率が 10% を超えた場合に通知
* **Alarm 2 (WAF):** リクエストがブロックされた場合に通知
* **Notification:** SNS Topic (Email通知)

## 前提条件 (Prerequisites)

* **Terraform:** v1.5.0 以上推奨 (Apple Silicon Macの場合は arm64版)
* **AWS CLI:** インストール済みで、適切なプロファイル設定ができていること
* **EC2 Key Pair:** `kentouwajima` (または自身の環境に合わせて変更)

## ディレクトリ構成（予定）

機能ごとにファイルを分割して管理します。

```text
.
├── main.tf          # Provider設定
├── variables.tf     # 変数定義
├── network.tf       # VPC, Subnet, IGW, RouteTable
├── security.tf      # Security Groups
├── compute.tf       # EC2 Instance
├── database.tf      # RDS Instance
├── lb.tf            # ALB, Target Group
├── waf.tf           # WAF WebACL
└── monitoring.tf    # CloudWatch, SNS