# Outputs
output "web_instance_ips" {
  value = [aws_instance.web_1.public_ip, aws_instance.web_2.public_ip]
}

output "app_instance_ips" {
  value = [aws_instance.app_1.private_ip, aws_instance.app_2.private_ip]
}