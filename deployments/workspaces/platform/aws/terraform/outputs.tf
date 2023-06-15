output "public_ip" {
  value = aws_instance.this.public_ip
}

output "website_url" {
  value = "http://${aws_instance.this.public_dns}:${http_port}"
}

output "security_group" {
  value = aws_security_group.this.id
}
