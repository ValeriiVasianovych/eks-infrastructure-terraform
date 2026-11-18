resource "aws_security_group" "sg" {
  description = "${var.prefix_name} cluster Security Group"
  name        = "${var.prefix_name}-sg-${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Client VPN to Kubernetes API"
    from_port       = 443
    protocol        = "tcp"
    security_groups = [var.client_vpn_security_group_id]
    to_port         = 443
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

# The EKS-managed cluster security group is attached to the control plane ENIs and the nodes.
resource "aws_security_group_rule" "vpn_to_cluster" {
  description              = "Client VPN to Kubernetes API"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
  source_security_group_id = var.client_vpn_security_group_id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "internal_alb_to_pods" {
  description              = "Internal ALB to pods"
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
  source_security_group_id = var.internal_alb_security_group_id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "external_alb_to_pods" {
  description              = "Internet-facing ALB to pods"
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
  source_security_group_id = var.external_alb_security_group_id
  to_port                  = 65535
  type                     = "ingress"
}
