resource "aws_security_group" "internal_alb" {
  description = "Internal ALB for Grafana and Prometheus. Ingress from Client VPN only."
  name        = "${var.prefix_name}-alb-internal-${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from Client VPN"
    from_port       = 80
    protocol        = "tcp"
    security_groups = [var.client_vpn_security_group_id]
    to_port         = 80
  }

  egress {
    cidr_blocks = [var.vpc_cidr]
    description = "ALB to pod IPs in the VPC"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "${var.prefix_name}-alb-internal-${var.env}"
  }
}

resource "aws_security_group" "external_alb" {
  description = "Internet-facing ALB for a public application ingress"
  name        = "${var.prefix_name}-alb-public-${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from the internet"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from the internet"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }

  egress {
    cidr_blocks = [var.vpc_cidr]
    description = "ALB to pod IPs in the VPC"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "${var.prefix_name}-alb-public-${var.env}"
  }
}
