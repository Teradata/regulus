resource "aws_launch_template" "this" {
  name_prefix   = var.jupyter_name
  image_id      = data.aws_ami.this.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.subnet_id
    security_groups             = [aws_security_group.this.id]
  }

  key_name = var.key_name

  monitoring {
    enabled = var.monitoring_enabled
  }

  tags = merge({
    Name = var.jupyter_name
    },
    var.tags
  )

  tag_specifications {
    resource_type = "volume"
    tags          = merge({ Name = join("-", [var.jupyter_name, "jupyter-volume"]) }, var.tags)
  }

  metadata_options {
    instance_metadata_tags = "enabled"
    http_endpoint          = "enabled"
    http_tokens            = "required"
  }

}

resource "aws_instance" "this" {
  #checkov:skip=CKV_AWS_88: "EC2 instance should not have public IP."
  user_data_base64            = data.cloudinit_config.this.rendered
  user_data_replace_on_change = false

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp2"
    encrypted             = true
  }

  tags = {
  Name = join("-", [var.jupyter_name, "jupyter"]) }

  disable_api_termination = true

  lifecycle {
    ignore_changes = [
      launch_template["version"],
      user_data_base64,
      tags["AWSCaseID"],
      tags["PrincipalId"]
    ]
  }
}

resource "random_uuid" "jupyter_token" {}
