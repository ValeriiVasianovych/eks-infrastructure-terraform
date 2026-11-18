locals {
  # Internal (private zone + internal ALB + VPN): grafana.dev.internal.<zone>
  grafana_record_name    = "grafana.${var.env}.internal"
  prometheus_record_name = "prometheus.${var.env}.internal"

  grafana_hostname    = "${local.grafana_record_name}.${var.hosted_zone_name}"
  prometheus_hostname = "${local.prometheus_record_name}.${var.hosted_zone_name}"

  # External (public zone + internet-facing ALB): e.g. app.dev.<zone> — add in a public-app module later.
}
