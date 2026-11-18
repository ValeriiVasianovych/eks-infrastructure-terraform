data "aws_region" "current" {}

resource "aws_security_group" "client_vpn" {
  description = "Client VPN endpoint ENIs. Referenced as the source of traffic from VPN clients."
  name        = "${var.prefix_name}-client-vpn-${var.env}"
  vpc_id      = var.vpc_id

  egress {
    cidr_blocks = [var.vpc_cidr]
    description = "VPN clients to VPC resources"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "${var.prefix_name}-client-vpn-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "client_vpn" {
  name              = "/aws/client-vpn/${var.prefix_name}-${var.env}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "client_vpn" {
  log_group_name = aws_cloudwatch_log_group.client_vpn.name
  name           = "connections"
}

resource "aws_ec2_client_vpn_endpoint" "this" {
  client_cidr_block      = var.client_cidr_block
  description            = "${var.prefix_name}-${var.env} client vpn"
  security_group_ids     = [aws_security_group.client_vpn.id]
  self_service_portal    = "disabled"
  server_certificate_arn = var.server_certificate_arn
  split_tunnel           = true
  transport_protocol     = "udp"
  vpc_id                 = var.vpc_id
  vpn_port               = 443

  # VPC resolver is the VPC CIDR base + 2, so clients resolve the EKS private endpoint.
  dns_servers = [cidrhost(var.vpc_cidr, 2)]

  authentication_options {
    root_certificate_chain_arn = var.root_certificate_chain_arn
    type                       = "certificate-authentication"
  }

  connection_log_options {
    cloudwatch_log_group  = aws_cloudwatch_log_group.client_vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.client_vpn.name
    enabled               = true
  }

  tags = {
    Name = "${var.prefix_name}-client-vpn-${var.env}"
  }

  lifecycle {
    precondition {
      condition     = split(":", var.server_certificate_arn)[3] == data.aws_region.current.region
      error_message = "vpn_server_cert_arn must be an ACM certificate in ${data.aws_region.current.region}. Client VPN cannot use a certificate from another region."
    }

    precondition {
      condition     = split(":", var.root_certificate_chain_arn)[3] == data.aws_region.current.region
      error_message = "vpn_client_cert_arn must be an ACM certificate in ${data.aws_region.current.region}. Client VPN cannot use a certificate from another region."
    }
  }
}

resource "aws_ec2_client_vpn_network_association" "private" {
  count = length(var.private_subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = var.private_subnet_ids[count.index]
}

resource "aws_ec2_client_vpn_authorization_rule" "vpc" {
  authorize_all_groups   = true
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  description            = "Allow authenticated clients to reach the VPC"
  target_network_cidr    = var.vpc_cidr
}

# Association routes only the associated subnet CIDRs. The resolver (.2) is outside every subnet.
resource "aws_ec2_client_vpn_route" "vpc_dns" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  description            = "Amazon VPC DNS resolver"
  destination_cidr_block = "${cidrhost(var.vpc_cidr, 2)}/32"
  target_vpc_subnet_id   = var.private_subnet_ids[0]

  depends_on = [aws_ec2_client_vpn_network_association.private]
}
