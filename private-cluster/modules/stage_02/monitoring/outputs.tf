output "grafana_ingress_host" {
  value       = local.grafana_hostname
  description = "The hostname for Grafana ingress"

  depends_on = [kubernetes_ingress_v1.grafana]
}

output "prometheus_ingress_host" {
  value       = local.prometheus_hostname
  description = "The hostname for Prometheus ingress"

  depends_on = [kubernetes_ingress_v1.prometheus]
}

output "private_hosted_zone_id" {
  value       = aws_route53_zone.private.zone_id
  description = "Private Route53 zone ID (split-horizon, same name as public zone)"
}
