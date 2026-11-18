variable "hosted_zone_name" {
  description = "Existing public Route53 zone."
  type        = string
}

variable "kube_prometheus_stack_version" {
  description = "Version of the kube-prometheus-stack Helm chart"
  type        = string
  default     = "75.15.0"
}
