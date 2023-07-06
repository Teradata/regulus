output "public_ip_workspaces" {
  value = aws_instance.this.public_ip
}

output "private_ip_workspaces" {
  value = aws_instance.this.private_ip
}

output "private_http_access_workspaces" {
  value = "http://${aws_instance.this.private_ip}:${var.http_port}"
}

output "public_http_access_workspaces" {
  value = "http://${aws_instance.this.public_dns}:${var.http_port}"
}

output "private_grpc_access_workspaces" {
  value = "${aws_instance.this.private_ip}:${var.grpc_port}"
}

output "public_grpc_access_workspaces" {
  value = "${aws_instance.this.public_dns}:${var.grpc_port}"
}

output "security_group" {
  value = aws_security_group.this.id
}
