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
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }
}

resource "aws_instance" "this" {
  #checkov:skip=CKV_AWS_88: "EC2 instance should not have public IP."
  user_data_base64            = data.cloudinit_config.this.rendered
  user_data_replace_on_change = false # ce is not yet elastic

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  root_block_device {
    delete_on_termination = true
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name   = join("-", [var.workspaces_name, "workspaces"])}

  lifecycle {
    ignore_changes = [
      launch_template["version"], # we always want to use the latest version on create, but not on update 
      user_data_base64,           # though this should be revisited once we have elastic ce
      tags["AWSCaseID"],
      tags["PrincipalId"]
    ]
  }
}