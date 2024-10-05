# Output EC2 Instance Public IPs
output "webserver1_instance_public_ip-1" {
  description = "The public IP address of the EC2 instance in the first VPC"
  value       = aws_instance.web_server_1.public_ip
}

output "webserver2_instance_public_ip-2" {
  description = "The public IP address of the EC2 instance in the second VPC"
  value       = aws_instance.web_server_2.public_ip
}
