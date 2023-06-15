resource "aws_security_group" "this" {
    vpc_id = data.aws_subnet.this.vpc_id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.ingress_cidr
    }

    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = var.ingress_cidr
    }

    ingress {
        from_port = 3282
        to_port = 3282
        protocol = "tcp"
        cidr_blocks = var.ingress_cidr
    }

    tags = {
        Name = join("-",[var.workspaces_name, "-access"])
    }
}
