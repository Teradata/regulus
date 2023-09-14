resource "aws_launch_template" "this" {
  name_prefix   = var.workspaces_name
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
    Name = var.workspaces_name
    },
    var.tags
  )

  tag_specifications {
    resource_type = "volume"
    tags          = merge({ Name = join("-", [var.workspaces_name, "workspaces-volume"]) }, var.tags)
  }

  metadata_options {
    instance_metadata_tags = "enabled"
    http_endpoint          = "enabled"
    http_tokens            = "required"
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
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
    volume_size           = var.volume_size
    volume_type           = "gp2"
    encrypted             = true
  }

  tags = merge(
    var.user_tags,
    {
      Name = join("-", [var.workspaces_name, "workspaces"])
    }
  )

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      var.user_tags,
      {
        Name = join("-", [var.workspaces_name, "workspaces"])
      }
    )
  }

  disable_api_termination = var.termination_protection

  lifecycle {
    ignore_changes = [
      launch_template["version"],
      user_data_base64,
      tags["AWSCaseID"],
      tags["PrincipalId"]
    ]
  }
}
