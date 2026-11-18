variable "client_cidr_block" {
  description = "CIDR assigned to VPN clients. Must be between /12 and /22 and must not overlap the VPC."
  type        = string
  default     = "172.16.0.0/22"
}

variable "env" {
  description = "The environment"
  type        = string
}

variable "prefix_name" {
  description = "Name prefix for Client VPN resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets associated with the Client VPN endpoint"
  type        = list(string)
}

variable "root_certificate_chain_arn" {
  description = "ACM ARN of the client root certificate chain used for mutual authentication. Must be in the same region as the endpoint."
  type        = string
}

variable "server_certificate_arn" {
  description = "ACM server certificate ARN for the Client VPN TLS listener. Must be in the same region as the endpoint."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR. Must not overlap client_cidr_block."
  type        = string
}

variable "vpc_id" {
  description = "VPC to associate the Client VPN endpoint with"
  type        = string
}
