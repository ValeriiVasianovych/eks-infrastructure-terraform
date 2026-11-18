variable "account_id" {
  description = "The AWS account ID"
  type        = string
  default     = ""
}

variable "cluster_iam_arn" {
  description = "The IAM role ARN of the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = ""
}

variable "env" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "hosted_zone_name" {
  description = "The hosted zone name"
  type        = string
  default     = ""
}

variable "internal_alb_security_group_id" {
  description = "Security group of the internal ALB. Ingress is limited to the Client VPN."
  type        = string
}

variable "kube_prometheus_stack_version" {
  description = "Version of the kube-prometheus-stack Helm chart"
  type        = string
  default     = ""
}

variable "private_subnet_ids" {
  description = "Private subnets for the internal ALB"
  type        = list(string)
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC for the split-horizon private hosted zone (same name as the public zone)"
  type        = string
}
