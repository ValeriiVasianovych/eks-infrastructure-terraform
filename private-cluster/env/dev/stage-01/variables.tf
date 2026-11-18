variable "automation_role_arn" {
  description = "The ARN of the automation role"
  type        = string
}

variable "client_cidr_block" {
  description = "CIDR assigned to Client VPN clients. Must not overlap the VPC."
  type        = string
  default     = "172.16.0.0/22"
}

variable "env" {
  description = "The environment"
  type        = string
  # default     = "development"
}

variable "prefix_name" {
  description = "The name prefix of the EKS cluster"
  type        = string
  # default     = "new-eks-cluster"
}

variable "region" {
  description = "The AWS region"
  type        = string
  # default     = "us-east-1"
}

variable "vpn_client_cert_arn" {
  description = "ACM ARN of the client root certificate chain for Client VPN mutual authentication"
  type        = string
}

variable "vpn_server_cert_arn" {
  description = "The ARN of the VPN server certificate"
  type        = string
}

locals {
  capacity_type   = "ON_DEMAND"
  cluster_version = "1.33"
  desired_size    = 2
  ingress_ports   = [80, 443, 3000]
  instance_types  = "t3.small"
  max_size        = 10
  max_unavailable = 1
  min_size        = 2

  # Addon versions
  coredns_version        = "v1.12.4-eksbuild.1"
  ebs_csi_version        = "v1.50.1-eksbuild.1"
  kube_proxy_version     = "v1.33.3-eksbuild.6"
  metrics_server_version = "v0.8.0-eksbuild.2"
  pod_identity_version   = "v1.3.8-eksbuild.2"
  vpc_cni_version        = "v1.20.2-eksbuild.1"

  # Charts versions
  cert_manager_version       = "v1.14.5"
  cluster_autoscaler_version = "9.52.1"
  lb_controller_version      = "1.7.2"
  nginx_ingress_version      = "4.10.1"
}
