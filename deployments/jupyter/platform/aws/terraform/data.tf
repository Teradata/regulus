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
      jupyter_service : base64encode(templatefile("${path.module}/templates/jupyter.service.tftpl", {
        jupyter_registry : var.jupyter_registry
        jupyter_repository : var.jupyter_repository
        jupyter_version : var.jupyter_version
        jupyter_token : random_uuid.jupyter_token.result
        http_port : var.http_port
      }))
    })
  }
}
