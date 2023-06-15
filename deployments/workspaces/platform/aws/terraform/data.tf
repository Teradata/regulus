data "aws_subnet" "this" {
  id = var.subnet_id
}

data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

data "cloudinit_config" "this" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/cloudinit.yaml.tftpl", {
      workspaces_service : base64encode(templatefile("${path.module}/templates/workspaces.service.tftpl", {
        workspaces_registry : var.workspaces_registry
        workspaces_repository : var.workspaces_repository
        workspaces_version : var.workspaces_version
        http_port : var.http_port
        grpc_port : var.grpc_port
      }))
    })
  }
}