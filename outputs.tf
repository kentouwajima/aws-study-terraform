# EC2のパブリックIPを出力
# 後のステップでAnsibleがこのIPを使ってSSH接続します
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.study_ec2.public_ip
}

output "security_group_id" {
  description = "ID of the Security Group"
  value       = aws_security_group.ec2_sg.id
}