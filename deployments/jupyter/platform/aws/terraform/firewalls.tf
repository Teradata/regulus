resource "aws_security_group" "this" {
  description = "allows access from regulus clients to the Teradata Worspaces service"
  vpc_id      = data.aws_subnet.this.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.egress_cidrs
    security_groups = var.access_security_groups
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.access_cidrs
    security_groups = var.access_security_groups
  }

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.access_cidrs
    security_groups = var.access_security_groups
  }

  tags = {
    Name = join("-", [var.jupyter_name, "access"])
  }
}
