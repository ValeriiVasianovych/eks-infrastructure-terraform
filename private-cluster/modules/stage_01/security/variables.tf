variable "client_vpn_security_group_id" {
  description = "Client VPN security group allowed to reach the internal ALB"
  type        = string
}

variable "env" {
  description = "The environment"
  type        = string
}

variable "prefix_name" {
  description = "Name prefix for ALB security groups"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR used for ALB egress to pod IPs"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
