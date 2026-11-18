variable "cluster_autoscaler_version" {
  description = "cluster-autoscaler Helm chart version"
  type        = string
  default     = "9.52.1"
}

variable "external_dns_version" {
  description = "external-dns Helm chart version"
  type        = string
  default     = "1.23.0"
}

variable "hosted_zone_name" {
  description = "The hosted zone name"
  type        = string
}

variable "kube_prometheus_stack_version" {
  description = "Version of the kube-prometheus-stack Helm chart"
  type        = string
  default     = "75.15.0"
}

variable "lb_controller_version" {
  description = "aws-load-balancer-controller Helm chart version"
  type        = string
  default     = "1.7.2"
}
