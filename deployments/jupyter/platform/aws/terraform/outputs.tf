output "public_ip" {
  value = aws_instance.this.public_ip
}

output "private_ip" {
  value = aws_instance.this.private_ip
}

output "public_http_access" {
  value = "http://${aws_instance.this.public_ip}:${var.http_port}?token=${random_uuid.jupyter_token.result}"
}

output "private_http_accessr" {
  value = "http://${aws_instance.this.private_ip}:${var.http_port}?token=${random_uuid.jupyter_token.result}"
}

output "security_group" {
  value = aws_security_group.this.id
}

output "ssh_connection" {
  value = "ssh ec2-user@${aws_instance.this.public_ip}"
}
