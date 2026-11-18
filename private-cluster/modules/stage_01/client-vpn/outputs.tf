output "client_cidr_block" {
  value       = var.client_cidr_block
  description = "CIDR assigned to VPN clients"
}

output "dns_server" {
  value       = cidrhost(var.vpc_cidr, 2)
  description = "VPC DNS resolver pushed to VPN clients"
}

output "endpoint_id" {
  value       = aws_ec2_client_vpn_endpoint.this.id
  description = "Client VPN endpoint ID"
}

output "security_group_id" {
  value       = aws_security_group.client_vpn.id
  description = "Security group attached to the Client VPN endpoint ENIs"
}
