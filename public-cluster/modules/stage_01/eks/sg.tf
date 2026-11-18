resource "aws_security_group" "sg" {
  description = "${var.prefix_name} cluster Security Group"
  name        = "${var.prefix_name}-sg-${var.env}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = ingress.value
      protocol    = "tcp"
      to_port     = ingress.value
    }
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}
